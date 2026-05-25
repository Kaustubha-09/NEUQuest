# Architecture

NEUQuest is a polyglot cross-platform app: a native Android (Java + Material 3) client and a native iOS (SwiftUI + MVVM) client share a single Firebase backend and a single Gemini 1.5 Flash model.

## System diagram

```
┌─────────────────────────────┐      ┌─────────────────────────────┐
│   Android client (Java)     │      │   iOS client (SwiftUI)      │
│   Material 3 · ViewBinding  │      │   MVVM strict · @MainActor  │
│   Activities, no Fragments  │      │   ViewState<T> pattern      │
│   ThreadPoolExecutor +      │      │   Combine for @Published    │
│   Firebase Tasks            │      │   async/await for HTTP      │
└──────────────┬──────────────┘      └──────────────┬──────────────┘
               │                                    │
               │     Shared Firebase project        │
               │     Shared Gemini API key          │
               ▼                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Firebase                                  │
│   ├─ Authentication (email/password, NEU-domain-gated)          │
│   ├─ Realtime Database  (events, trips, users, comments)        │
│   └─ Storage           (event images, profile photos)           │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │
                              │ Gemini 1.5 Flash REST
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│   Gemini 1.5 Flash                                              │
│   ├─ AI event ranking by user interests + attendance history    │
│   └─ AI trip name generation from location + budget + dates     │
└─────────────────────────────────────────────────────────────────┘
```

## Two rules every platform obeys

1. **Firebase is the single source of truth.** No domain state is persisted client-side beyond display caches. Every read and write goes through Realtime Database, Auth, or Storage.
2. **Models → Services → ViewModels → Views.** On iOS this is explicit MVVM with `@Published` state and `@MainActor` ViewModels. On Android it's the same logical separation: Activities act as Views, Repositories under `firebase/repository/` act as Services, and POJOs under `model/` are Models — there are no Fragments and no ViewModels in the canonical AAC sense (yet — Kotlin + Jetpack Compose migration is on the [roadmap](roadmap.md)).

## Shared database schema

```
/users/{uid}
  name, campus, profileImage, isAdmin
  interests: [string]
  plannedTrips:    [tripID]
  eventsAttended:  [eventID]

/events/{eventID}
  title, description, category, location, price
  startDate (dd/MM/yyyy), endDate, startTime (HH:mm), endTime
  image, registerLink, createdBy, isReported
  comments/{commentID}: text, commenterName, timestamp

/trips/{tripID}
  title, location, minBudget, maxBudget
  startDate, endDate, startTime, endTime
  mealsIncluded, transportIncluded
  eventIDs: [eventID]
```

Both clients hit these paths verbatim. There is no version-skew protocol between them — when the schema changes, both clients must follow.

## Auth gating

Email/password signup is restricted to `@northeastern.edu` and `@husky.neu.edu` addresses at the client layer:

- Android: `SignUpActivity.isValidNeuEmail(email)` rejects non-NEU domains before calling Firebase.
- iOS: `AuthViewModel.signUp(email:password:)` mirrors the same regex.

After signup, Firebase sends a verification email; the client app shows an `EmailVerificationReminderActivity` (Android) or `EmailVerificationView` (iOS) until the user clicks the link.

## Gemini integration

| Use case | Implementation |
|---|---|
| Event ranking | Both clients POST the user's interests + attended-event history to Gemini, receive a re-ranked list of event IDs from a candidate set, and use that ordering for the Right Now feed. |
| Trip name generation | Both clients POST trip location + budget range + dates to Gemini, receive a 3–5 word evocative trip name. |

The Gemini API key is configured per-client (Android: `GeminiClient.java` constant excluded from version control; iOS: `Services/GeminiService.swift` similar pattern). There is no backend proxy in front of Gemini — the API key is in the app binary, which is **not** production-grade. A real deployment should proxy through a Firebase Cloud Function or a dedicated backend.

## Android architecture

Activities-based (no Fragments). Each Activity is a screen. Repositories handle Firebase access; adapters handle list rendering.

```
app/src/main/java/edu/northeastern/numad24su_group9/
├── NEUQuestApplication.java   # Firebase init, offline persistence
├── AppConstants.java          # All shared constants (final class)
├── (Activities)               # MainActivity, RightNowActivity, ProfileActivity, …
├── model/                     # Event, Trip, User, Comment (POJOs)
├── firebase/
│   ├── AuthConnector.java
│   ├── DatabaseConnector.java
│   ├── StorageConnector.java
│   └── repository/
│       ├── database/
│       │   ├── EventRepository.java
│       │   ├── TripRepository.java
│       │   └── UserRepository.java
│       └── storage/
│           ├── EventImageRepository.java
│           └── UserProfileRepository.java
├── gemini/
│   └── GeminiClient.java      # ListenableFuture wrapper
└── recycler/                  # ListAdapter + DiffUtil for all 5 RecyclerViews
```

**Key choices:**

- All five RecyclerView adapters extend `ListAdapter<T, VH>` with a `DiffUtil.ItemCallback` — no manual `notifyDataSetChanged()`.
- `FirebaseDatabase.setPersistenceEnabled(true)` in `NEUQuestApplication` — events and trips cache locally; cold-launch loads instantly from disk.
- `AppConstants` is a `final class` with a private constructor (not an interface). All thresholds, budget bounds, debounce intervals, and SharedPreferences keys live here.
- `ThreadPoolExecutor` for background work, not `AsyncTask` (deprecated since Android 11).
- `Glide` for hero images, `Picasso` for thumbnails — historic inconsistency tracked in the [roadmap](roadmap.md).

## iOS architecture

Strict MVVM. Views read from `@Published` state on `@MainActor ObservableObject` ViewModels.

```
NEUQuest/
├── Models/              # Codable structs — Event, Trip, User, Comment
├── Services/            # @MainActor ObservableObject singletons (FirebaseService, GeminiService)
├── ViewModels/          # @MainActor ObservableObject, @Published state
├── Views/
│   ├── Auth/            # Splash, Login, SignUp, EmailVerification
│   ├── Events/          # RightNow feed, EventDetail, RegisterEvent
│   ├── Trips/           # TripPlanner, TripDetail
│   ├── Profile/         # ProfileView, InterestsView
│   ├── Admin/           # AdminConsole, AddEvent
│   └── Components/      # EventCard, CategoryChipRow, CommentView, BudgetRangeSlider
└── Utils/               # AppTheme, Extensions
```

**Key choices:**

- Zero business logic in views. Every screen reads from `@Published` state on its ViewModel and routes user intents back via VM method calls.
- Firebase SDK added via Swift Package Manager (FirebaseAuth, FirebaseDatabase, FirebaseStorage).
- Gemini calls via `URLSession` — no third-party SDK for Gemini on iOS.
- `AppTheme.swift` owns brand decisions (Colors, Fonts, Spacing, Radius, Shadow namespaces).

## Color reality vs. claim

The repo's current Android theme renders a **dusty rose** (~`#7A5C58`) on a **cream background** (~`#F4EAD7`) — visible in the Welcome / Trip Budget / Profile screenshots. The original design spec called for **NEU Red `#CC0000`** + cream + navy, but the implemented Android theme drifted to a softer palette during the Material 3 migration.

The iOS `AppTheme.swift` still uses `#CC0000`. So the two clients are visually different today. Reconciliation is tracked in the [roadmap](roadmap.md) under "Cross-platform brand unification".

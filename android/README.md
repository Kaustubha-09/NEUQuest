# NEUQuest — Android

> The Android client for NEUQuest, built with Java and the Android SDK. Discover NEU events, plan budget trips with AI assistance, and connect with the Northeastern community — natively on Android.

[![Java](https://img.shields.io/badge/Java-8-007396)](https://www.java.com)
[![Android](https://img.shields.io/badge/Android-API%2027%2B-3DDC84)](https://developer.android.com)
[![Material 3](https://img.shields.io/badge/UI-Material%203-757575)](https://m3.material.io)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28)](https://firebase.google.com)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

The native Android surface of [NEUQuest](../README.md) — paired with the SwiftUI [iOS client](../ios/README.md) against the same Firebase project and Gemini 1.5 Flash model.

---

## Screenshots

Captured in [`../Screenshots/`](../Screenshots/). Key shots: Explore (`01_explore.png`), Trip Planner (`02_budget.png`), Profile (`03_profile.png`), plus six additional captures from the 2026-01-24 demo session.

---

## Features

### Explore & Discover
- Right Now feed: AI-ranked events via Gemini 1.5 Flash
- Category chips: Art, Nature, Photography, Travel, Music, Movies, Food, Sports
- Full-text search with live filtering
- Event cards with image, location, price, date/time

### Event Detail
- Full description, pricing, location, date range, register link
- Comment thread (read + post)
- Report event → admin moderation queue

### Budget Trip Planner
- AI-generated trip names via Gemini
- Date range picker with start/end time
- Range slider: min/max budget ($0–$1,000)
- Toggles: include meals / include transport
- Auto-matches events within trip date range

### Trip Detail
- Timeline view of all events in the trip
- Budget summary, duration, date range

### Profile
- Photo upload (camera or gallery)
- Campus selection, interest editing
- Planned trips overview
- Events attended history

### Auth & Security
- Email/password with mandatory email verification
- NEU email gating (`@northeastern.edu` / `@husky.neu.edu` only)
- Role-based admin access

### Admin Console
- Review reported events
- Approve or remove flagged content
- Create new events

---

## Architecture

```
app/src/main/java/edu/northeastern/numad24su_group9/
├── NEUQuestApplication.java        ← Firebase init, notification channel
├── AppConstants.java               ← Centralized constants (final class)
├── MainActivity.java               ← Welcome / auth gateway
├── LoginActivity.java
├── SignUpActivity.java
├── EmailVerificationActivity.java
├── EmailVerificationReminderActivity.java
├── RightNowActivity.java           ← Main feed (Gemini-ranked events)
├── EventDetailsActivity.java
├── RegisterEventActivity.java
├── AddEventsActivity.java          ← Admin: create events + add to trip
├── PlanningTripActivity.java       ← Trip planner (budget slider, AI naming)
├── TripDetailsActivity.java        ← Trip timeline view
├── ProfileActivity.java
├── InterestsActivity.java
├── AdminConsole.java
├── NotificationHelper.java
├── CurrencyInputFilter.java
│
├── model/
│   ├── Event.java                  ← title, category, dates, price, location, comments
│   ├── Trip.java                   ← dates, budget range, meals/transport flags, eventIDs
│   ├── User.java                   ← name, campus, interests, plannedTrips, eventsAttended
│   └── Comment.java
│
├── firebase/
│   ├── AuthConnector.java          ← FirebaseAuth singleton
│   ├── DatabaseConnector.java      ← FirebaseDatabase reference
│   ├── StorageConnector.java       ← FirebaseStorage reference
│   └── repository/
│       ├── database/
│       │   ├── EventRepository.java
│       │   ├── TripRepository.java
│       │   └── UserRepository.java
│       └── storage/
│           ├── EventImageRepository.java
│           └── UserProfileRepository.java
│
├── gemini/
│   └── GeminiClient.java           ← Gemini 1.5 Flash: ranking + trip naming
│
└── recycler/
    ├── EventAdapter.java            ← ListAdapter + DiffUtil
    ├── TripAdapter.java
    ├── CommentsAdapter.java
    ├── TimelineEventAdapter.java
    └── AdminConsoleAdapter.java
```

### Key architecture decisions

- **DiffUtil in all adapters** — all 5 RecyclerView adapters extend `ListAdapter<T, VH>` with `DiffUtil.ItemCallback`. `submitList()` drives every update.
- **Firebase offline persistence** — enabled in `NEUQuestApplication` via `setPersistenceEnabled(true)`. Cached data loads instantly on relaunch.
- **NEU email gating** — only `@northeastern.edu` and `@husky.neu.edu` accepted at signup (`SignUpActivity.isValidNeuEmail()`).
- **AppConstants** — a `final class` (not an interface) with a private constructor. All shared constants live here: `PREFS_USER_INFO`, `BUDGET_SLIDER_MIN/MAX/STEP`, `BACK_PRESS_INTERVAL_MS`, `RECYCLER_VIEW_CACHE_SIZE`.
- **Gemini integration** — `GeminiClient` uses `ListenableFuture` via Guava. Two uses: event feed ranking by user interests, and AI trip name generation in `PlanningTripActivity`.

---

## Design System

Brand decisions live in `res/values/colors.xml` and `themes.xml`.

| Token | Hex | Role |
|---|---|---|
| NEU Red | `#CC0000` | Primary CTAs, app bar |
| Dark Navy | `#0A1628` | Headers |
| Gold | `#FFD700` | Accent |
| Surface | `?attr/colorSurface` | Adaptive light/dark |

**Typography** — Material 3 rounded type scale. **Spacing** — 4-point grid (`4 / 8 / 12 / 16 / 20 / 24 / 32 / 48`). **Radius** — `sm 8 · md 12 · lg 16 · xl 20 · pill 999`.

Mirrors the iOS `AppTheme.swift` so the two clients render visually consistent.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 8 |
| Min SDK | API 27 (Android 8.1) |
| Target SDK | API 34 (Android 14) |
| UI | Material Design 3, XML layouts, ViewBinding |
| Architecture | MVC with MVVM infrastructure |
| Async | ThreadPoolExecutor + Firebase Tasks |
| Image loading | Glide + Picasso |
| AI | Gemini 1.5 Flash via Guava `ListenableFuture` |
| Backend | Firebase Authentication, Realtime Database, Storage |
| Testing | JUnit + Espresso (30 unit tests) |

---

## Getting Started

### Prerequisites
- Android Studio Hedgehog (2023.1.1) or later
- JDK 8 or higher
- Android SDK API 27+

### Setup

```bash
git clone https://github.com/Kaustubha-09/NEUQuest.git
cd NEUQuest/android
# Open in Android Studio and let Gradle sync
```

1. **Add Firebase config**
   - Create a project at [Firebase Console](https://console.firebase.google.com/).
   - Enable Authentication (Email/Password), Realtime Database, and Storage.
   - Download `google-services.json` → place in `app/`.

2. **Add Gemini API key**
   - Get a key from [Google AI Studio](https://aistudio.google.com/).
   - Add to `GeminiClient.java` (excluded from version control).

3. **Build and run**
   ```bash
   ./gradlew assembleDebug
   # Or use Android Studio ▶ Run
   ```

4. **Run tests**
   ```bash
   ./gradlew test
   ```

---

## Demo Credentials

| Field | Value |
|---|---|
| Email | `demo@northeastern.edu` |
| Password | `demo1234` |

---

## Tests (30 unit tests)

| Class | Coverage |
|---|---|
| `Event.isWithinDateRange` | 8 cases: boundary dates, cross-year ranges |
| `Event.compareTo` / sort ordering | 4 cases |
| `RightNowActivity.extractTitles` | 4 regex cases |
| `SignUpActivity.isValidNeuEmail` | 5 cases incl. spoofed domains |
| `Trip.addEventID` null safety | 2 cases |
| `AppConstants` value sanity | 4 cases |

---

## Roadmap

- [ ] Migrate to Kotlin + Jetpack Compose
- [ ] Full MVVM with ViewModels + StateFlow
- [ ] Navigation Component (fix broken back stack)
- [ ] Push notifications (FCM)
- [ ] Like/dislike events for feed personalization
- [ ] Budget pie chart visualization
- [ ] Google Maps integration
- [ ] CI/CD with GitHub Actions

---

## License

Developed as a university course project. MIT License.

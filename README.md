# NEUQuest — Where Budget Meets Adventure

> A cross-platform event discovery and trip planning app exclusively for Northeastern University students. Discover affordable events, plan budget trips with AI assistance, and connect with the NEU community — on Android and iOS.

[![Android](https://img.shields.io/badge/Android-Java%20%2B%20Material%203-3DDC84)](android/)
[![iOS](https://img.shields.io/badge/iOS-SwiftUI%20%2B%20MVVM-blue)](ios/)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28)](https://firebase.google.com)
[![Gemini](https://img.shields.io/badge/AI-Gemini%201.5%20Flash-4285F4)](https://ai.google.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

Both platforms talk to the same Firebase project (Auth, Realtime DB, Storage) and the same Gemini 1.5 Flash model for AI-ranked event feeds and AI-generated trip names. Per-platform READMEs: [`android/README.md`](android/README.md) · [`ios/README.md`](ios/README.md).

---

## Screenshots

| Explore | Trip Planner | Profile |
|:-:|:-:|:-:|
| <img src="Screenshots/01_explore.png" width="220" /> | <img src="Screenshots/02_budget.png" width="220" /> | <img src="Screenshots/03_profile.png" width="220" /> |

Additional captures from the 2026-01-24 demo session live in [`Screenshots/`](Screenshots/) (`04_capture_1.png` through `09_capture_6.png`).

---

## Features

### Explore & Discover
- **Right Now** feed: real-time events ranked by AI (Google Gemini 1.5 Flash)
- Category chips: Art, Nature, Photography, Travel, Music, Movies, Food, Sports
- Full-text search with live filtering
- Event cards: image, location, price, date/time at a glance

### Event Details & Registration
- Full event detail: description, pricing, location, date range, register link
- Comment system for community discussion
- Report suspicious events → admin moderation queue

### Budget Trip Planner
- AI-generated trip names via Gemini
- Date range picker with start/end time
- Range slider: min/max budget ($0–$1000)
- Toggle: include meals / include transport
- Auto-matches events within trip date range and budget
- Timeline view of your trip itinerary

### Personalized Feed
- Gemini ranks events based on your registered events + declared interests
- Interest tags: Art, Nature, Photography, Travel, Music, Movies, Food, Sports
- Like/dislike signals fine-tune recommendations over time

### Profiles
- Photo upload (camera or gallery)
- Campus selection, interest editing
- Planned trips overview
- Events attended history

### Auth & Security
- Email/password with mandatory email verification
- Only `@northeastern.edu` and `@husky.neu.edu` addresses accepted
- Role-based admin access (managed at signup)

### Admin Console
- Review reported events
- Approve or remove flagged content
- Add new events to the platform

---

## Architecture

```
NEUQuest/
├── android/                    Java + Material 3 + Activities client (production)
│   └── app/src/main/java/edu/northeastern/numad24su_group9/
│       ├── model/              Event · Trip · User · Comment
│       ├── firebase/           Auth · Database · Storage connectors + repositories
│       ├── gemini/             GeminiClient (AI ranking + trip naming)
│       └── recycler/           ListAdapter + DiffUtil for all 5 RecyclerViews
├── ios/                        SwiftUI + MVVM client (in progress)
│   └── NEUQuest/
│       ├── Models/             Codable structs
│       ├── Services/           @MainActor singletons (Firebase, Gemini)
│       ├── ViewModels/         @MainActor ObservableObject, @Published state
│       ├── Views/              Zero business logic, grouped by feature
│       └── Utils/              AppTheme, Extensions
├── docs/                       Wireframes + prototypes
├── Screenshots/                Top-level captures referenced by this README
└── README.md
```

Two rules every platform obeys:
1. **Firebase is the single source of truth.** No domain state is persisted client-side — every read/write goes through Realtime Database, Auth, or Storage.
2. **Models → Services → ViewModels → Views.** Views never call Firebase or Gemini directly; they read from `@Published` state on a ViewModel.

### Shared Database Schema

```
/users/{uid}
  name, campus, profileImage, isAdmin
  interests: [string]
  plannedTrips: [tripID]
  eventsAttended: [eventID]

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

---

## Design System

Brand decisions live in `Utils/AppTheme.swift` (iOS) and `res/values/colors.xml` + `themes.xml` (Android).

| Token | Hex | Role |
|---|---|---|
| NEU Red | `#CC0000` | Primary CTAs, brand mark |
| Dark Navy | `#0A1628` | Headers, key surfaces |
| Gold | `#FFD700` | Accent / highlight |
| Background | `systemBackground` (iOS) / `?attr/colorSurface` (Android) | Adaptive light/dark |

**Typography** — SF Rounded (iOS) / Material rounded (Android). Sizes: `largeTitle 34 · title 28 · title2 22 · title3 20 · headline 17 · body 17 · callout 16 · subheadline 15 · footnote 13 · caption 12 · caption2 11`.

**Spacing** — 4-point grid: `xxs 4 · xs 8 · sm 12 · md 16 · lg 20 · xl 24 · xxl 32 · xxxl 48`.

**Radius** — `sm 8 · md 12 · lg 16 · xl 20 · pill 999`.

**Reusable modifiers (iOS)** — `.cardStyle()` · `.primaryButton()` · `.secondaryButton()` · `.chipStyle(isSelected:)`.

---

## Tech Stack

### Backend (shared)

| Service | Usage |
|---|---|
| Firebase Authentication | Email/password, email verification, role-based access |
| Firebase Realtime Database | Events, Trips, Users, Comments — real-time sync |
| Firebase Storage | Event images, user profile photos |
| Google Gemini 1.5 Flash | AI event ranking, AI trip name generation |

### Android

| Layer | Technology |
|---|---|
| Language | Java 8 |
| Min SDK | API 27 (Android 8.1) |
| Target SDK | API 34 (Android 14) |
| UI | Material Design 3, XML layouts, ViewBinding |
| Architecture | MVC with MVVM infrastructure (ViewBinding + Lifecycle) |
| Async | ThreadPoolExecutor + Firebase Tasks |
| Image loading | Glide + Picasso |
| AI | Gemini 1.5 Flash via Guava `ListenableFuture` |
| Testing | JUnit + Espresso (30 unit tests) |

### iOS

| Layer | Technology |
|---|---|
| Language | Swift 5.9 |
| Min target | iOS 17 |
| UI | SwiftUI |
| Architecture | MVVM (strict — zero logic in views) |
| State | Combine + `@Published` |
| Async | Swift Concurrency (`async/await`, `@MainActor`) |
| Persistence | UserDefaults + JSONEncoder |
| AI | Gemini 1.5 Flash via URLSession |

---

## Getting Started

### Android

```bash
git clone https://github.com/Kaustubha-09/NEUQuest.git
cd NEUQuest/android

# Add your google-services.json to app/
./gradlew assembleDebug

# Run tests
./gradlew test
```

### iOS

```bash
cd NEUQuest/ios
open NEUQuest.xcodeproj
# Select an iPhone simulator (iOS 17+) and press ⌘R
```

- Firebase: add `GoogleService-Info.plist` to the iOS target.
- Gemini: add your API key to `Services/GeminiService.swift`.

See [`android/README.md`](android/README.md) and [`ios/README.md`](ios/README.md) for full platform setup.

---

## Demo Credentials

| Field | Value |
|---|---|
| Email | `demo@northeastern.edu` |
| Password | `demo1234` |

The app ships with full mock data — no Firebase setup needed for UI development.

---

## Platform Status

| Platform | Language | Framework | Status |
|---|---|---|---|
| Android | Java | Activities + Material 3 | Complete |
| iOS | Swift | SwiftUI + MVVM | In progress |
| Web | TypeScript | Next.js + React | Planned |

---

## Roadmap

- [ ] Android → Kotlin + Jetpack Compose migration
- [ ] iOS App Store submission
- [ ] Web app (Next.js + Firebase)
- [ ] Push notifications (FCM / APNs)
- [ ] Google Maps integration for event locations
- [ ] Like/dislike system for feed personalization
- [ ] Budget pie chart visualization
- [ ] Calendar app integration
- [ ] Social features (friends, shared trips)
- [ ] CI/CD with GitHub Actions

---

## Project Stats

| Metric | Android | iOS |
|---|---|---|
| Source files | 36 Java | 35+ Swift |
| Unit tests | 30 | In progress |
| Third-party deps | 6 | 0 |
| AI integration | Gemini 1.5 Flash | Gemini 1.5 Flash |

---

## Team

**Group 9 — Northeastern University · NUMAD24Su**

- Agllai Papaj
- Harshitha Chava
- Kaustubha Eluri
- Sampada Kulkarni
- Winston Heinrichs

**Course:** Mobile Application Development (NUMAD24Su) · Northeastern University · Summer 2024

---

## License

Developed as a university course project. MIT License.

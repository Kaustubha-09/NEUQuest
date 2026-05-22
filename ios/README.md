# NEUQuest — iOS

> The iOS client for NEUQuest, built with SwiftUI following strict MVVM architecture. Discover NEU events, plan budget trips with AI assistance, and connect with the Northeastern community — natively on iPhone.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blueviolet)](https://developer.apple.com/xcode/swiftui/)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28)](https://firebase.google.com)
[![License](https://img.shields.io/badge/license-MIT-green)](#license)

The native iOS surface of [NEUQuest](../README.md) — paired with the Java + Material 3 [Android client](../android/README.md) against the same Firebase project and Gemini 1.5 Flash model.

---

## Screenshots

Captured in [`../Screenshots/`](../Screenshots/). Key shots: Explore (`01_explore.png`), Trip Planner (`02_budget.png`), Profile (`03_profile.png`), plus six additional captures from the 2026-01-24 demo session.

---

## Features

### Explore / Right Now
- Live event feed, AI-ranked by user interests and attendance history
- Category chip filters: Art, Nature, Photography, Travel, Music, Movies, Food, Sports
- Full-text search with live filtering
- Empty / loading / error states on all lists

### Event Detail
- Hero image, title, category badge, price, dates, location
- Register link
- Comment thread (read + post)
- Report event (feeds admin moderation queue)

### Budget Trip Planner
- Location input with start/end date + time pickers
- Range slider: min/max budget ($0–$1,000)
- Toggles: include meals / include transport
- AI trip name generated via Gemini 1.5 Flash
- Auto-matches events within trip date range

### Trip Detail
- Timeline view of all events in the trip
- Budget summary: range, meals, transport
- Duration and date range

### Profile
- Name, campus, profile photo
- Interest tag editor
- Planned trips list
- Events attended history
- Light / dark / system appearance toggle
- Logout

### Admin (role-gated)
- Review reported events
- Approve or remove flagged content
- Create new events

### Auth
- Splash screen
- Email/password login + sign-up
- NEU email gating (`@northeastern.edu` / `@husky.neu.edu` only)
- Email verification reminder flow

---

## Architecture

```
NEUQuest/
├── Models/              # Codable structs — Event, Trip, User, Comment
├── Services/            # @MainActor ObservableObject singletons
├── ViewModels/          # @MainActor ObservableObject, @Published state, Combine
├── Views/
│   ├── Auth/            # Splash, Login, SignUp, EmailVerification
│   ├── Events/          # RightNow feed, EventDetail, RegisterEvent
│   ├── Trips/           # TripPlanner, TripDetail
│   ├── Profile/         # ProfileView, InterestsView
│   ├── Admin/           # AdminConsole, AddEvent
│   └── Components/      # EventCard, CategoryChipRow, CommentView, BudgetRangeSlider
└── Utils/               # AppTheme, Extensions
```

**Pattern:** Models → Services → ViewModels → Views. Zero business logic in views — every screen reads from `@Published` state on a ViewModel; every side effect (Firebase, Gemini) lives in a Service singleton.

---

## Design System (`Utils/AppTheme.swift`)

| Token | Value |
|---|---|
| Brand | `#CC0000` (NEU Red) |
| Navy | `#0A1628` |
| Gold | `#FFD700` |
| Surface | `#112040` |
| Typography | SF Rounded, `largeTitle` → `caption2` |
| Spacing | `4 · 8 · 12 · 16 · 20 · 24 · 32 · 48` |
| Radius | `sm 8 · md 12 · lg 16 · xl 20 · pill 999` |

**View modifiers:** `.cardStyle()` · `.primaryButton()` · `.secondaryButton()` · `.chipStyle(isSelected:)`

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9 |
| Min target | iOS 17 |
| UI | SwiftUI |
| Architecture | MVVM (strict — zero logic in views) |
| State | Combine + `@Published` |
| Async | Swift Concurrency (`async/await`, `@MainActor`) |
| Persistence | UserDefaults + JSONEncoder/Decoder |
| AI | Gemini 1.5 Flash via URLSession |
| Auth/DB/Storage | Firebase SDK (add via SPM) |
| Dependencies | 0 third-party at MVP; Firebase added via SPM |

---

## Getting Started

### 1. Open in Xcode

```bash
cd NEUQuest/ios
open NEUQuest.xcodeproj
```

### 2. Add Firebase (via Swift Package Manager)

In Xcode: **File → Add Package Dependencies**

```
https://github.com/firebase/firebase-ios-sdk
```

Add targets: `FirebaseAuth`, `FirebaseDatabase`, `FirebaseStorage`

Then add `GoogleService-Info.plist` to the `NEUQuest` target (download from Firebase Console).

### 3. Add Gemini API Key

In `Services/GeminiService.swift`:
```swift
private let apiKey = "YOUR_GEMINI_API_KEY"
```

Get a key at [Google AI Studio](https://aistudio.google.com/).

### 4. Build and Run

Select **NEUQuest** scheme + iPhone simulator (iOS 17+) → **⌘R**

---

## Demo Credentials

| Field | Value |
|---|---|
| Email | `demo@northeastern.edu` |
| Password | `demo1234` |

The app ships with full mock data — no Firebase setup needed for UI development.

---

## Roadmap

- [ ] Firebase SDK integration (replace mock services)
- [ ] Push notifications (APNs)
- [ ] Like/dislike events for AI feed tuning
- [ ] Google Maps for event locations
- [ ] Calendar app integration
- [ ] Haptic feedback polish
- [ ] App Store submission

---

## License

Developed as a university course project. MIT License.

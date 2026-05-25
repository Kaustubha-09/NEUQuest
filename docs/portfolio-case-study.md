# NEUQuest — Portfolio Case Study

Built as a 5-person team project for NUMAD24Su (Mobile Application Development) at Northeastern, Summer 2024. Skim time: 3 minutes.

## The problem

Northeastern students juggle a dozen tools to find affordable events around campus — Eventbrite for paid events, club Discords for free ones, the NEU events portal for official campus events, Facebook groups for last-minute meetups. There's no single feed tuned to *student* budgets and *student* interests.

## The product

A mobile app — native Android and native iOS — exclusively for NEU students. Discover events, plan budget trips with AI assistance, and connect with the campus community. Both clients sit on top of one Firebase project and use Gemini 1.5 Flash for ranking and trip-name generation.

## The architecture I'd defend in an interview

### 1. Two native clients sharing one backend

A single Firebase project (Auth + Realtime Database + Storage). A single Gemini API contract. Two clients (Java + Material 3 for Android, SwiftUI + MVVM for iOS) that talk to it. Cross-client features (a trip created on Android visible on iPhone) come for free. See [decisions.md, ADR-001](decisions.md#adr-001--native-android--native-ios-not-react-native--flutter) and [ADR-002](decisions.md#adr-002--single-firebase-project-for-both-clients).

### 2. Domain-gated signups, layered defense

Client-side: `SignUpActivity.isValidNeuEmail()` rejects non-NEU addresses before calling Firebase. Backstop: Realtime Database security rules reject writes where `auth.token.email` doesn't end in `.edu`. Two layers because a client-only check can be bypassed by hitting the Firebase REST API directly. See [ADR-003](decisions.md#adr-003--neu-domain-gating-at-the-client-layer).

### 3. Firebase offline persistence on by default

`FirebaseDatabase.setPersistenceEnabled(true)` in the Android `Application`. Cold-launch shows the previous session's data instantly while the network sync runs in the background. The 5 MB cost is a fair trade for never showing a blank loading state on app open. See [ADR-006](decisions.md#adr-006--firebase-offline-persistence-on).

### 4. `ListAdapter` + `DiffUtil` for every RecyclerView

All five RecyclerView adapters extend `ListAdapter<T, VH>` with a typed `DiffUtil.ItemCallback`. `submitList()` drives every update. No manual `notifyDataSetChanged()`. Item-level diffing animates only the changed cells. See [ADR-005](decisions.md#adr-005--listadapter--diffutil-everywhere).

### 5. Gemini for ranking + naming, kept narrow

Gemini does two things: rank a candidate set of events against a user's interests + attendance history, and generate a 3–5 word evocative trip name. We did not put Gemini in the loop of any critical path (auth, payments, sign-up). The features that use it would degrade gracefully if it's down (default chronological feed; user-typed trip name).

### 6. The honest part

- The Gemini API key is in the client binary. Demo-grade, called out in [ADR-008](decisions.md#adr-008--gemini-api-key-in-the-client-binary). Fix is a Cloud Function proxy.
- Android renders dusty rose; iOS renders NEU Red. The two clients drifted visually during Material 3 migration. Documented in [ADR-010](decisions.md#adr-010--different-color-palettes-between-android-and-ios-today).
- The iOS client still has mock services in places; full Firebase wire-up is roadmap Phase 2.
- `04_capture_*.png` files are early wireframes, not app captures. Preserved deliberately because they show the design iteration.

## What I'd do next

[Phase 1 of the roadmap](roadmap.md): migrate Android from Java + XML to Kotlin + Jetpack Compose, replace Activities with Navigation Compose, add AAC `ViewModel` + `StateFlow`. That brings Android to parity with the iOS architectural pattern and unlocks shared design tokens.

## What this signals to a recruiter

- I can collaborate on a 5-person mobile project and ship something that works.
- I write platform-idiomatic code on both Android and iOS without forcing a cross-platform compromise.
- I understand layered defense (client check + DB rule) without leaning on one alone.
- I document drift honestly (color palette divergence, Gemini key in binary, demo-grade integrations) rather than hiding it.
- I know what `ListAdapter` is and why it exists (item-level diffing > sledgehammer `notifyDataSetChanged()`).
- I can ship Gemini integration as a feature, not as a research project — using it for ranking and naming, keeping it out of critical paths.

# Roadmap

Phased plan. The course-project version is done; this is what it would take to ship.

## Phase 1 — Android: Kotlin + Jetpack Compose migration (3–4 weeks)

- Migrate the Java codebase to Kotlin file-by-file (Android Studio's auto-convert is a starting point, not a finishing point).
- Replace Activities with a single-Activity / Navigation Compose architecture.
- Add `ViewModel` (AAC) + `StateFlow` for state holding.
- Replace XML layouts with Compose `@Composable` functions screen by screen.

## Phase 2 — iOS: complete Firebase wire-up (1 week)

- Remove `MockData` paths from iOS ViewModels.
- All Firebase calls through `Services/FirebaseService` (`@MainActor` singleton).
- Add iOS app icon + LaunchScreen polish.
- Keychain-backed token storage.

## Phase 3 — Backend proxy for Gemini (1 week)

- Firebase Cloud Function in front of Gemini.
- Both clients send Firebase ID token + payload; function validates the token, calls Gemini, returns response.
- Rotate the leaked client-binary key.

## Phase 4 — Cross-platform brand unification (1 week)

- Pick a canonical palette: either current Android (dusty rose + cream) or current iOS (NEU Red + navy).
- Update both clients to match.
- Document tokens in `docs/design-system.md` as the canonical source.

## Phase 5 — Feedback signals + AI tuning (2 weeks)

- Capture like/dislike signals per event per user → `/user_feedback/{uid}/{eventID}`.
- Feed signals into the Gemini ranking prompt.
- Add an "Explore vs. Refine" toggle so users can choose serendipity vs. curated.

## Phase 6 — Polish (2 weeks)

- Push notifications (FCM + APNs).
- Google Maps for event locations.
- Calendar export (`.ics` for iOS / Google Calendar).
- Budget pie chart visualization.
- Like/dislike toast feedback.
- Empty / loading / error states audited on every screen.

## Phase 7 — Distribution

- Play Store submission.
- App Store submission with privacy manifest.
- Firebase Cloud Messaging setup.
- Production analytics (Firebase Analytics + Crashlytics).
- Sentry integration.

## Phase 8 — Web (long-term)

- Next.js + TypeScript + Firebase JS SDK.
- Same Firebase project, same Gemini contract.
- SSR for SEO on public event listings (course catalog browse, public events).

## Out of scope

- **Replacing Eventbrite for general events.** NEUQuest is for the NEU community; we don't compete with general-purpose event platforms.
- **Direct ticketing/payments.** Register links open external sites. We don't process payments.
- **Trip-booking integrations (hotels, flights).** This is a discovery + budgeting tool, not a booking platform.

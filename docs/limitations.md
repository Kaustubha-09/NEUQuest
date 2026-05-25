# Limitations

NEUQuest is a university course project (NUMAD24Su, Group 9, Summer 2024). It is not deployed to the Play Store or App Store, and is not intended for production use.

## Auth + Security

- **Gemini API key in the client binary.** Anyone who decompiles the APK or the iOS binary can extract the key. Mitigation today is Google AI Studio's per-key spend cap. Fix is a backend proxy.
- **NEU domain check is client-side.** Realtime Database security rules act as a backstop, but a determined attacker can hit the Firebase REST API directly with a non-NEU email and write data if the rules are misconfigured.
- **No 2FA / passkeys.** Email/password only.
- **No password-strength enforcement.** Firebase Auth's default 6-character minimum is the only rule.
- **No rate limiting** on comment posting, event reporting, or trip creation.

## Cross-platform inconsistency

- **Color palette differs.** Android is dusty rose + cream; iOS is NEU Red + navy. See [decisions.md, ADR-010](decisions.md#adr-010--different-color-palettes-between-android-and-ios-today).
- **iOS still has mock services.** The iOS roadmap calls out "Firebase SDK integration (replace mock services)" — meaning the iOS client today is partly stubbed against `MockData`. Android is fully wired against Firebase.
- **No image-loading library parity.** Android uses Glide + Picasso (historic inconsistency); iOS uses a bespoke `AsyncCachedImage` wrapping NSCache.

## Platform-specific

### Android
- No Jetpack Compose. XML layouts + ViewBinding.
- No ViewModels (in the AAC sense). Each Activity owns its own state.
- No Navigation Component. `Intent`-driven navigation, back-stack is brittle in places.
- No Kotlin — pure Java 8.
- No Hilt / Dagger. Repositories are manually instantiated.

### iOS
- Firebase SDK not wired in for all surfaces — some screens still use `MockData`.
- No iOS app icon set finalized.
- No iCloud Keychain handling for tokens.

## Data + Backend

- **No paginated event feed.** All events load at once; viable for the current dataset (~50 events) but breaks at scale.
- **No search indexing.** Full-text search is client-side substring matching on the loaded set.
- **No real ranking-feedback loop.** The README claims "Like/dislike signals fine-tune recommendations over time" — those signals aren't yet captured. Roadmap item.
- **Realtime Database, not Firestore.** Schema is denormalized for read efficiency; complex queries are awkward.
- **No backup/export.** If the Firebase project is deleted, data is gone.

## Permissions and platform features

- **No push notifications.** Neither FCM nor APNs are configured.
- **No deep linking.** Web → app links don't open the app.
- **No Google Maps integration.** Event locations are strings, not pinned coordinates.
- **No calendar integration.** Trip itineraries can't be exported to iOS / Google Calendar.
- **No biometric lock.** Anyone with the phone has app access after first login.

## Operational

- **No CI/CD when this README was first written.** GitHub Actions workflow added in 2026 (see [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)).
- **No analytics.** No Firebase Analytics, no Mixpanel, no event funnels.
- **No crash reporting.** Crashes are local; no Crashlytics or Sentry.
- **No A/B testing infrastructure.**

## Team / Project

- **Built in a 6-week summer course.** Scope was deliberately bounded to a working demo.
- **Five contributors.** Code style varies across files — some classes have JavaDoc, others don't.
- **Submission focus.** The demo loop was prioritized over edge cases (locale handling, RTL, network-loss recovery).

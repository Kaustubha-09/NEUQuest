# Architecture Decision Records

Dated decisions. Append-only.

## ADR-001 · Native Android + Native iOS, not React Native / Flutter

**Date:** 2024-07
**Status:** Accepted

We chose two native clients instead of one cross-platform codebase.

**Why:** the course (NUMAD24Su — Mobile Application Development) explicitly required platform-native development. The choice gave us idiomatic UX on each platform (Material 3 on Android, SF Rounded + iOS conventions on iPhone) at the cost of double-implementation.

**Cost:** model and feature changes need to land twice. Mitigated by a shared Firebase schema (which neither client can fork from) and a shared Gemini contract.

---

## ADR-002 · Single Firebase project for both clients

**Date:** 2024-07
**Status:** Accepted

Auth, Realtime Database, and Storage are one Firebase project shared by Android and iOS. Same `events` tree, same `users` tree, same Storage bucket.

**Why:** the data is the source of truth, not the client. Cross-client features (a trip created on Android visible on iPhone) come for free.

**Cost:** schema changes must coordinate across clients. Versioning would require a `/v2/events` path migration. Tracked in [roadmap.md](roadmap.md).

---

## ADR-003 · NEU domain gating at the client layer

**Date:** 2024-07
**Status:** Accepted

`SignUpActivity.isValidNeuEmail()` (Android) and the iOS equivalent reject non-`@northeastern.edu` / `@husky.neu.edu` addresses before calling Firebase.

**Why:** the app is for the NEU community. A non-NEU signup wastes a Firebase user slot and pollutes the dataset.

**Why client-side:** Firebase Authentication doesn't expose a server-side rule for domain-restricted signup without a Cloud Function. We did the cheap thing in the client and accept that a determined attacker can hit the Firebase REST API directly to bypass the check. Mitigation: Realtime Database security rules reject writes where `auth.token.email` doesn't end in `.edu`.

---

## ADR-004 · Activities, not Fragments, on Android

**Date:** 2024-07
**Status:** Accepted

Each screen is its own Activity. No Fragments.

**Why:** the 2024 NUMAD course material taught Activities; Fragments add lifecycle complexity for a project at this scale. Activity-per-screen is simpler to reason about and debug at the cost of richer nested-navigation patterns.

**When to revisit:** Kotlin + Jetpack Compose migration ([roadmap](roadmap.md), Phase 1) replaces this with Navigation Compose / single-Activity architecture.

---

## ADR-005 · `ListAdapter` + `DiffUtil` everywhere

**Date:** 2024-07
**Status:** Accepted

All five RecyclerView adapters extend `ListAdapter<T, VH>` with a `DiffUtil.ItemCallback`. `submitList()` drives every update.

**Why:** `notifyDataSetChanged()` is a sledgehammer — it re-binds every visible item. `ListAdapter` + `DiffUtil` computes the minimum item-level diff and animates only the changed cells.

**Cost:** every adapter must define `areItemsTheSame` and `areContentsTheSame`. Two extra lines per model. Acceptable.

---

## ADR-006 · Firebase offline persistence ON

**Date:** 2024-07
**Status:** Accepted

`FirebaseDatabase.setPersistenceEnabled(true)` in `NEUQuestApplication`. Events and trips cache to disk.

**Why:** cold-launch shows the previous session's data instantly while the network sync runs in the background. Without it, every cold start hits a blank loading state.

**Cost:** disk usage. Acceptable on modern Android (typical cache ~5 MB).

---

## ADR-007 · `AppConstants` as a `final class`, not an interface

**Date:** 2024-07
**Status:** Accepted

```java
public final class AppConstants {
    private AppConstants() {}

    public static final String PREFS_USER_INFO = "user_info_prefs";
    public static final int    BUDGET_SLIDER_MIN  = 0;
    public static final int    BUDGET_SLIDER_MAX  = 1000;
    public static final int    BUDGET_SLIDER_STEP = 25;
    public static final long   BACK_PRESS_INTERVAL_MS = 2000L;
    public static final int    RECYCLER_VIEW_CACHE_SIZE = 20;
    // …
}
```

**Why:** interfaces in Java force every constant to be `public static final` implicitly — fine, except that an interface can be implemented, which lets a subclass leak the constants under a different name. A `final class` with a private constructor is a Joshua Bloch *Effective Java* pattern: explicit non-instantiable singletons for constants.

---

## ADR-008 · Gemini API key in the client binary

**Date:** 2024-07
**Status:** Accepted, demo-grade

The Gemini API key is configured in `GeminiClient.java` (Android) and `Services/GeminiService.swift` (iOS). Both files are excluded from version control.

**Why we did it:** the project is a course demo. Proxying every Gemini call through a Firebase Cloud Function adds infrastructure (CF deploy, IAM, billing) that wasn't part of the course scope.

**Cost:** anyone who decompiles the binary can extract the key and use our Gemini quota. Mitigation: Google AI Studio lets us cap per-key spend; if abuse happens, we rotate.

**When to fix:** before any non-demo deployment. The fix is a Cloud Function in front of Gemini — both clients then call our function with the user's Firebase ID token; the function validates and proxies to Gemini.

---

## ADR-009 · Wireframes preserved in `Screenshots/`, not deleted

**Date:** 2024-08
**Status:** Accepted

Files `04_capture_1.png` through `09_capture_6.png` are early pen-and-paper wireframes from the design phase, not app captures. They live alongside the real screenshots.

**Why preserved:** they show the iterative design process — useful as portfolio context. Renamed to a `wireframes/` subfolder would lose the chronological index. We just label them clearly in the README ("Early wireframes & prototypes — 2024-07").

---

## ADR-010 · Different color palettes between Android and iOS (today)

**Date:** 2024-09
**Status:** Accepted, debt

Android renders with a dusty-rose primary (~`#7A5C58`) on a cream background; iOS uses `#CC0000` NEU Red. The two clients are visually different.

**Why it drifted:** Android theme migration to Material 3 used the M3 color-token system; the team adopted softer tones from the M3 palette. iOS retained the original spec. Nobody reconciled before the demo.

**When to fix:** [roadmap.md](roadmap.md) Phase 4 ("Cross-platform brand unification") — pick one canonical palette and migrate both clients.

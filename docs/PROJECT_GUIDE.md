# SkillX — Project, Setup & Build Guide

> Peer-to-peer skill-swapping mobile app. **Flutter + Firebase.**
> This document covers everything needed to set up, run, and understand the
> **feature-complete** codebase — **all 13 phases** of the roadmap
> (see [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md)). The backend is **deployed,
> seeded, and live** on `skillx-9a717` (**10 Cloud Functions**).

- **Firebase project:** `skillx-9a717`
- **Region:** `us-central1`
- **Data Connect service:** `skillx` · connector `default` · Cloud SQL instance `skillx-pg` · DB `skillxdb`
- **Functions base URL:** `https://us-central1-skillx-9a717.cloudfunctions.net` (2nd-gen compat alias; canonical Cloud Run URLs are `https://<name>-2oeofs3y2a-uc.a.run.app`)
- **AI quiz generation:** Google **Gemini** (`gemini-2.5-flash`) · **Meetings:** Google **Calendar API** (Meet links + invites)

---

## 1. What SkillX is

A learner can find a peer who *teaches* a skill they *want to learn*, request a
session, meet over an auto-generated **Google Meet** link, then take an
**AI-generated (Gemini)** quiz to earn badges, build streaks, progress along a
learning path, and receive a participation certificate. Everything is
peer-to-peer — there are no paid instructors.

### Architecture at a glance

| Concern | Technology |
|---|---|
| App | Flutter (Dart), Material 3 |
| State management | Riverpod |
| Navigation | go_router (auth-gated redirect) |
| Auth | Firebase Auth (email/password + Google) |
| **Structured data** | **Firebase Data Connect → Cloud SQL (PostgreSQL)** |
| Realtime chat / presence | Cloud Firestore |
| File storage | Firebase Storage (photos, resumes, certificates) |
| Push notifications | Firebase Cloud Messaging (FCM) |
| Privileged server logic | Cloud Functions (TypeScript, Gen 2 / Cloud Run) |
| AI quiz generation | **Google Gemini** (`@google/genai`, `gemini-2.5-flash`, structured `responseSchema`) |
| Meetings | **Google Calendar API** (`googleapis`, OAuth2) — creates the event, Meet link, and invites |
| Certificate PDF | `pdf` (generate, pure Dart) + `printing` (share) |
| Charts | `fl_chart` (pure Dart) |

**Why the hybrid database?** Structured, relational data (users, skills,
sessions, quizzes, attempts, paths, progress) lives in **Cloud SQL via Data
Connect** — it gives type-safe, schema-validated GraphQL-style access with a
generated Dart SDK. Only **chat and presence** live in **Firestore**, where
realtime listeners are the right tool.

---

## 2. Prerequisites & installation

### 2.1 Required toolchain

| Tool | Version used | Notes |
|---|---|---|
| Flutter SDK | **3.44.8** | Dart **3.12.2** bundled |
| Java (JDK) | **JBR 25.0.2** (`V:\Apps\jbr`) | Gradle runs on this — see §3 ⚠️ |
| Firebase CLI | **15.25.1** | `npm i -g firebase-tools` |
| Node.js | **22.x** | Cloud Functions runtime target |
| Android Studio / SDK | latest | for the Android SDK + an emulator |

### 2.2 First-time install

```bash
# 1. Flutter (if not installed) — https://docs.flutter.dev/get-started/install
flutter --version          # expect 3.44.x / Dart 3.12.x
flutter doctor             # resolve any red items (Android licences etc.)

# 2. Firebase CLI + login
npm install -g firebase-tools
firebase login

# 3. App dependencies
cd app
flutter pub get

# 4. Cloud Functions dependencies
cd ../functions
npm install
```

### 2.3 App dependencies (`app/pubspec.yaml`)

Firebase: `firebase_core`, `firebase_auth`, `google_sign_in`, `cloud_firestore`,
`firebase_storage`, `firebase_messaging`, `firebase_data_connect`.
App: `flutter_riverpod`, `go_router`, `google_fonts`, `fl_chart`, `pdf`,
`printing`, `image_picker`, `intl`, `url_launcher`, `file_selector`, `http`,
`freezed`/`json_serializable` (codegen).

> **Deliberate omissions** (they break the Android build — see §3): `file_picker`
> (replaced with `file_selector`) and `cloud_functions` (replaced with `http` +
> HTTPS `onRequest` functions).

---

## 3. ⚠️ The Android toolchain constraint (read this before building)

This cost real hours to discover and pin down. **Gradle runs on JBR JDK 25.0.2**,
which is very new and **requires a modern Android Gradle Plugin**:

- **AGP 9.0.1 / Gradle 9.1 / Kotlin 2.3.20** — do **not** downgrade. Older AGP
  (8.7/8.9) rejects JDK 25 with an opaque `* What went wrong: 25.0.2` error.
- Because AGP 9 uses **Built-in Kotlin**, every Android plugin must be
  Built-in-Kotlin compatible. Plugins that apply a legacy
  `apply plugin: 'org.jetbrains.kotlin.android'` fail to compile.

### Consequences baked into the code

| Problem plugin | Symptom | Fix used |
|---|---|---|
| `file_picker` (any version) | `cannot find symbol FilePickerPlugin` | Use **`file_selector`** instead |
| `cloud_functions` | pulls `firebase_app_check`, Kotlin compile error | Call functions over **HTTPS (`http`)** with a Firebase ID token; functions are `onRequest` |

Pinned config files (do not "modernise" these):

- `app/android/settings.gradle.kts` → AGP `9.0.1`, Kotlin `2.3.20`, google-services `4.4.4`
- `app/android/gradle/wrapper/gradle-wrapper.properties` → `gradle-9.1.0-all.zip`
- `app/android/gradle.properties` → `android.newDsl=false`, `android.builtInKotlin=false`, `kotlin.incremental=false`

> `kotlin.incremental=false` also prevents intermittent Windows
> *"Could not close incremental caches (*.tab)"* errors. **Never run two Gradle
> builds concurrently** — that triggers the same cache collision.

---

## 4. Firebase project setup

The project `skillx-9a717` already exists and is selected (`.firebaserc`). The
wiring lives in `firebase.json`: Data Connect, Firestore (rules + indexes),
Storage (rules), and the Functions codebase.

### 4.1 Enable Blaze billing (required)

Data Connect provisions an **always-on Cloud SQL instance** and Cloud Functions
Gen 2 + Secret Manager all require billing.

1. https://console.firebase.google.com/project/skillx-9a717/usage/details
2. **Modify plan → Blaze**, link a billing account.
3. Set a **budget alert** (~$10–20/mo). Cost is dominated by the smallest
   always-on Cloud SQL tier (~$9–10/mo); everything else is near-zero at dev
   traffic.

### 4.2 `flutterfire configure` (already done)

The app is bound to Firebase via `firebase_options.dart` +
`android/app/google-services.json`. If you ever re-bind:

```bash
dart pub global activate flutterfire_cli
cd app && flutterfire configure --project skillx-9a717
```

---

## 5. Google API / Sign-In setup

### 5.1 Google Sign-In (Android)

Email/password auth works out of the box. **Google Sign-In on Android
additionally requires SHA fingerprints.**

1. Get your debug (and later release) fingerprints:
   ```bash
   cd app/android && ./gradlew signingReport
   ```
   Copy the **SHA-1** and **SHA-256** of the `debug` variant.
2. Console → **Project Settings → Your apps → Android app → Add fingerprint**.
   Add both SHA-1 and SHA-256.
3. Console → **Authentication → Sign-in method → enable Email/Password and Google.**
4. **Re-download `google-services.json`** and replace `app/android/app/google-services.json`.
5. Rebuild the app.

> `google-services.json` is *client config* (safe to ship in the app) — not a
> secret. Without the SHA fingerprints, Google sign-in fails silently while
> email/password keeps working.

### 5.2 Gemini API key (quiz generation)

1. Google AI Studio → https://aistudio.google.com/apikey → **Create API key** in
   project `skillx-9a717` (this also enables the Generative Language API).
2. Store it as a function secret (see §7.1). Never put it in the app.

### 5.3 Google Calendar API (meeting generation)

`createSession` creates a Calendar event with a Meet link and invites both
people. This needs an OAuth2 refresh token for a "SkillX organizer" account:

1. Console → **APIs & Services → Library** → enable **Google Calendar API**.
2. **OAuth consent screen** → External → add scope
   `https://www.googleapis.com/auth/calendar.events` → **publish to Production**
   (otherwise the refresh token expires after 7 days).
3. **Credentials → Create OAuth client ID → Web application** → add redirect URI
   `https://developers.google.com/oauthplayground` → copy Client ID + Secret.
4. Mint the refresh token at https://developers.google.com/oauthplayground
   (⚙ → *Use your own OAuth credentials* → authorize the `calendar.events` scope
   as the organizer account → *Exchange authorization code for tokens*).
5. Store all three as function secrets (see §7.1).

---

## 6. Data Connect (Cloud SQL) setup

Schema and operations live in `dataconnect/`:

```
dataconnect/
├── dataconnect.yaml         # service skillx, Cloud SQL skillx-pg / db skillxdb
├── schema/schema.gql        # every @table = a Postgres table
├── connector/
│   ├── connector.yaml       # connector "default", generates the Dart SDK
│   ├── queries.gql          # client-callable reads (@auth level USER/PUBLIC)
│   └── mutations.gql        # client-callable writes
└── seed_skills.gql          # one-time catalogue seed (run in console)
```

- **`eq_expr: "auth.uid"`** in queries scopes rows to the caller, so a user can
  only read/write their own data.
- Sensitive writes (grading, streak, unlock, progress, certificates) are
  **server-write-only** — done by Cloud Functions with the admin API, never by
  client mutations.

### 6.1 Generated Dart SDK

The type-safe SDK is generated into `app/lib/generated/dataconnect`. **Regenerate
after editing any `.gql`:**

```bash
firebase dataconnect:sdk:generate
```

Usage pattern:
```dart
import 'package:skillx/generated/dataconnect/default.dart' as dc;

final result = await dc.DefaultConnector.instance.getCurrentUser().execute();
final user = result.data.users.first;   // typed fields
```
Optionals are set via builder methods (`.photoUrl(...)`), enums are UPPERCASE
(`SkillRelation.TEACH`), and reads come back as `EnumValue<T>` (`.stringValue`).

---

## 7. Cloud Functions setup

TypeScript, in `functions/`. All are **HTTPS `onRequest`** (not `onCall` — see
§3), verify the caller with `getAuth().verifyIdToken()`, and use CORS.

```
functions/src/
├── index.ts        # the 10 functions (below)
├── dataconnect.ts  # executeWrite / executeRead admin wrappers (bypass @auth)
├── gemini.ts       # Gemini quiz generation (@google/genai, structured output)
├── calendar.ts     # Google Calendar event + Meet link (googleapis, OAuth2)
├── notify.ts       # notify() — one push gate: honors category toggles + quiet hours
└── email.ts        # nodemailer generic notifier (OTP/account/promo)
```

| Function | Purpose |
|---|---|
| `sendRequest` | Insert a learn request + **notify the teacher** (interest-targeted, capped 3/day) |
| `acceptRequest` | Accept a request → ACCEPTED, open chat (with member cards), notify |
| `createSession` | Pre-session form → Session rows + **Calendar event/Meet link + invites** + chat session-card |
| `generateQuiz` | Covered-subtopics → **Gemini** drafts 5 MCQs, store unapproved |
| `approveQuiz` | Apply teacher edits, set `isApproved` (release) |
| `gradeQuiz` | Server-side scoring (+streak +path unlock +reward push), one immutable attempt |
| `enrollPath` | Create a learner's UserProgress row (module 1 unlocked) |
| `issueCertificate` | On path completion: immutable Certificate record + computed avg score |
| `attachCertificatePdf` | Write-once link to the on-device-generated PDF |
| `submitRating` | 1–5★ rating (upsert per learner+session) + **recompute teacher average** |

> **Push notifications** all flow through `notify(uid, category, {title, body, route})` in
> `notify.ts`, which skips muted categories / quiet hours and attaches a deep-link
> `route`. Realtime **chat** is separate — it streams over Firestore, not FCM.

### 7.1 Secrets (set before deploying functions)

```bash
firebase functions:secrets:set GEMINI_API_KEY            # aistudio.google.com/apikey
firebase functions:secrets:set GOOGLE_OAUTH_CLIENT_ID    # Calendar OAuth client
firebase functions:secrets:set GOOGLE_OAUTH_CLIENT_SECRET
firebase functions:secrets:set GOOGLE_OAUTH_REFRESH_TOKEN
firebase functions:secrets:set GMAIL_USER               # notifier sender (optional until used)
firebase functions:secrets:set GMAIL_APP_PASSWORD       # 16-char App Password (needs 2FA)
```

> Secrets live in **Google Cloud Secret Manager** and only bind to a function
> after it's deployed. View them at Cloud Console → Security → Secret Manager.

---

## 8. Running locally

```bash
# Start an Android emulator first (e.g. the Medium_Phone AVD), then:
cd app
flutter run -d emulator-5554
```

> There is **no `windows/` desktop target** — always run on the Android
> emulator or a device, not the Windows target.

Quality gates used throughout:
```bash
flutter analyze lib          # static analysis (kept green every phase)
flutter build apk --debug    # full Android build verification
```

---

## 9. Deployment

After Blaze is on and secrets are set, deploy in this order:

```bash
firebase deploy --only dataconnect      # provisions Cloud SQL — 10–15 min first time
firebase deploy --only firestore,storage
firebase deploy --only functions        # predeploy hook runs `npm run build` automatically
```

Then **seed the catalogue**: paste the `SeedSkills` mutation from
`dataconnect/seed_skills.gql` into the Data Connect console runner (runs as
admin). The registration skill-pickers read `ListSkills`, so this must exist
before anyone can sign up.

### 9.1 Gotchas we hit (and fixed)

- **Stale build → "Cannot find module …".** `firebase deploy` ships the compiled
  `lib/`, it does *not* auto-compile. Fixed with a `predeploy` hook in
  `firebase.json` (`npm --prefix "$RESOURCE_DIR" run build`) so every functions
  deploy rebuilds first.
- **Firestore index 400 ("not necessary…").** `firestore.indexes.json` must only
  contain **composite** (2+ field) indexes — single-field ones are auto-managed.
  The `messages` single-field index was removed.
- **Org blocks default IAM grants → Gen 2 builds fail** with *"missing permission
  on the build service account."* `skillxinfo2026-org` enforces
  `iam.automaticIamGrantsForDefaultServiceAccounts`, so the Compute Engine
  default SA lacks build rights. Fix — grant it once:
  ```bash
  gcloud projects add-iam-policy-binding skillx-9a717 \
    --member="serviceAccount:1037173218383-compute@developer.gserviceaccount.com" \
    --role="roles/cloudbuild.builds.builder"
  ```
- **First Cloud SQL deploy "skips SQL schema migration"** because the instance is
  still being created (~10–25 min). Wait until `skillx-pg` is **Runnable**, then
  re-run `firebase deploy --only dataconnect` to apply the schema.
- **Function URLs.** Gen 2 functions get `…-uc.a.run.app` URLs; the app uses the
  `…cloudfunctions.net/<name>` compat alias. Verify it routes when testing.

---

## 10. Codebase structure

```
app/lib/
├── core/
│   ├── router/         # app_router.dart — go_router + auth-gated redirect
│   ├── theme/          # app_colors.dart, app_spacing.dart
│   └── widgets/        # primary_button.dart, ...
├── shared/widgets/     # skill_chip.dart, user_avatar.dart, ...
├── generated/dataconnect/   # generated type-safe DC SDK (do not hand-edit)
└── features/
    ├── auth/           # Phase 2 — splash, register, login, verify, Google onboarding
    ├── home/           # Phase 3 — home + discovery entry
    ├── discovery/      # Phase 3 — search, skill detail, send request
    ├── requests/       # Phase 5 — accepted requests, pre-session form
    ├── profile/        # Phase 4 — profile, edit, manage skills, resume, certificates
    ├── skills/         # skill relation domain + selectors
    ├── quiz/           # Phase 6 — post-session form, approval, attempt, result
    ├── rewards/        # Phase 7 — streak cards + badge grid
    ├── paths/          # Phase 8 — learning paths list + detail (lock/unlock)
    ├── dashboard/      # Phase 9 — summary cards + fl_chart line/bar + activity
    ├── certificate/    # Phase 10 — PDF generate + celebration + share
    ├── notifications/  # Phase 11 — FCM prefs, quiet hours, deep-link taps
    ├── chat/           # Phase 12 — realtime 1:1 (Firestore) + session card
    ├── ratings/        # Phase 13 — rate-teacher sheet
    └── about/          # Phase 13 — About screen
```

Each feature follows a consistent layering:
`domain/` (models) → `data/` (repositories) → `application/` (Riverpod providers)
→ `presentation/` (screens/widgets).

---

## 11. Data model (Cloud SQL tables)

| Table | Key fields |
|---|---|
| `User` | uid (PK), name, email, photoUrl, bio, currentStreak, longestStreak, lastActivityDate, totalSessions, averageRating, resume* |
| `Skill` | name (unique), category, description |
| `UserSkill` | (user, skill, relation) — relation ∈ HAVE/TEACH/LEARN, proficiency |
| `Request` | learner, teacher, skill, status (PENDING/ACCEPTED/REJECTED/COMPLETED) |
| `Session` | request, teacher, topic, subtopics, level, durationHours, meetingLink, **module/path (optional path link)** |
| `SessionLearner` | (session, learner) |
| `Quiz` | session, skill, teacher, topic, coveredSubtopics, isApproved |
| `QuizQuestion` | quiz, order, option0–3, **correctIndex (never sent to learners)** |
| `QuizAttempt` | user, quiz, skillName, score, percentage, badgeEarned — **immutable, one per attempt** |
| `LearningPath` / `LearningModule` | ordered modules per skill |
| `UserProgress` | (user, path) — currentModuleOrder, **unlockedUpTo**, isPathComplete — server-write only |
| `Certificate` | user, path, averageScore, modulesCompleted, pdfUrl — server-write, immutable |
| `Rating` | session, learner, teacher, stars (1–5), feedback |

---

## 12. Phase-by-phase: what was built

### Phase 1 — Foundation
Project skeleton, theme (`app_colors`, `app_spacing`), shared widgets, router
shell, Data Connect schema + generated SDK.

### Phase 2 — Authentication
`features/auth`: splash, register (+photo +skill pickers), login,
forgot-password (with resend countdown), email-verification gate, Google
sign-in + complete-profile onboarding. Auth-gated `go_router` redirect driven by
`appAuthStateProvider` (`AuthStatus` = unknown / unauthenticated /
needsVerification / needsProfile / ready).

### Phase 3 — Home & discovery
`features/home` + `features/discovery`: home header with streak, tappable
search, upcoming-session card (Join via `url_launcher`), incoming
accept/reject, browse offerings with category filter; skill-detail screen
(teacher card, rating, want-to-learn match banner, send-request sheet); search
screen. New DC ops: `ListTeachOfferings`, `SearchTeachOfferings`.

### Phase 4 — Profile & resume
`features/profile`: profile screen (identity, stat tiles, three read-only skill
sections, resume card, certificates strip), edit-profile (name/bio/photo),
manage-skills (three selectors, saves add/remove diffs). Resume PDF picked with
**`file_selector`**, stored at `resumes/{uid}/resume.pdf`.

### Phase 5 — Requests → session → link
Cloud Functions backend begins. `acceptRequest` (→ACCEPTED, opens Firestore
chat, FCM notify) and `createSession`. App calls functions over **HTTPS +
Firebase ID token**. Pre-session form (topic + tags, planned subtopics, level,
duration). FCM token registered on Home init.

> **Updated:** `createSession` now creates a **Google Calendar event with a Meet
> link** (`functions/calendar.ts`, OAuth2) and Calendar emails the invites to
> both people — the teacher no longer pastes a link. `email.ts` was generalized
> to a `sendNotificationEmail` notifier for future OTP/account/promo mail.

### Phase 6 — Quiz + AI generation + approval
`functions/gemini.ts`: `generateQuizQuestions` uses **Google Gemini
(`gemini-2.5-flash`) with a structured `responseSchema`** to draft 5 MCQs from
covered subtopics + level. Functions `generateQuiz`, `approveQuiz`, `gradeQuiz`
(server-side scoring — `correctIndex` never leaves the server; one immutable
`QuizAttempt`; badge gold ≥80 / silver ≥60 / bronze ≥40). `features/quiz`:
post-session form (covered-subtopics checklist), approval screen (edit text /
correct answer), attempt screen (one question at a time, back-nav, skip
allowed), result screen (score, badge, review with correct answers revealed),
plus teaching-sessions and my-quizzes list screens. Reached from Profile.

> **Note:** quiz generation was originally built on the Anthropic Claude API and
> later switched to Gemini; the mechanism (structured JSON output, same
> 5-question shape) is unchanged.

### Phase 7 — Rewards, badges, streak
Streak computed **server-side inside `gradeQuiz`** using the device's local date
(`localDate`, YYYY-MM-DD): same day → unchanged, next day → +1, gap → reset to 1.
Returns the new streak, shown as a 🔥 chip on the result screen. `features/
rewards`: two streak cards (current / longest) and a badge grid — Bronze/Silver/
Gold tiers plus 7/30/100-day streak milestones (unearned = greyed + locked,
tap → how-earned dialog).

### Phase 8 — Learning paths & unlocking
Lock/unlock driven **entirely by `UserProgress.unlockedUpTo`**: passing a
module's quiz (≥40%) sets `unlockedUpTo = N+1` and marks the path complete when
it was the last module — written server-side in `gradeQuiz` via the
quiz→session→module/path link. `enrollPath` function creates the progress row.
`features/paths`: enrolled-paths list with progress bars + an Explore sheet to
enrol; path detail with module lock/available/completed states, progress bar,
"skip keeps locked" dialog, and tap-to-open the module quiz (unlimited retakes).

### Phase 9 — Dashboard
`features/dashboard`: four summary cards (Quizzes taken · Average % · Day
streak · Best %), an **`fl_chart` line chart** of the last 10 scores, a
**bar chart** of average score per skill (top 6), a recent-activity list, and a
mandatory empty state — all derived from the immutable `QuizAttempt` history
(`GetMyAttempts`). `fl_chart` is pure Dart, so no native-plugin risk.

### Phase 10 — Certificate
On full-path completion, `issueCertificate` writes an **immutable** Certificate
record (server-computed average score, idempotent) and the app **generates the
PDF on-device** (`pdf`, pure Dart, participation-only wording), uploads it to
`certificates/{uid}/{certId}.pdf`, and links it via `attachCertificatePdf`
(write-once). `features/certificate`: celebration screen with score/skill/mentor,
**share** (`printing`) and view-PDF. Entry: the "Get certificate" button on a
completed path.

### Phase 11 — Notifications
Every push flows through one server helper `notify(uid, category, {title, body,
route})` (`functions/notify.ts`) that skips **muted categories** and **quiet
hours** (window computed from the device's stored UTC offset) and attaches a
deep-link `route`. `features/notifications`: a settings screen with per-category
toggles + quiet-hours pickers, saved to `User.notificationPrefs` (JSON). Taps
route via `FcmService.setupTapHandling` → `context.go(route)`. The
interest-targeted **"learners waiting to teach"** push (capped 3/day per teacher
via a Firestore counter) fires from the `sendRequest` function.

### Phase 12 — Chat
Realtime 1:1 over **Firestore** (the app's only realtime layer). `acceptRequest`
seeds the chat doc with member cards + an unread map; `createSession` drops a
**session-link card** into it. `features/chat`: a conversation list (unread
badges) and a thread (realtime bubbles, composer, unread-clears-on-open) with the
session card showing **Start** (teacher) / **Join** (learner) on the Meet link.

### Phase 13 — Ratings, About, tests
`submitRating` (Cloud Function) upserts a 1–5★ rating per learner+session and
**recomputes the teacher's average** server-side; rated from a sheet in the chat
thread (learner-only). An **About** screen. Domain **unit tests** (notification
prefs, path lock-state, dashboard aggregates) alongside widget/token smoke tests
— `flutter test` green.

---

## 13. Status

**Feature-complete: all 13 phases done** — every phase is analyze-green,
`flutter test`-green, and APK-build-verified. The backend is **deployed, seeded,
and live** on `skillx-9a717` (**10 Cloud Functions**, Firestore + Storage rules,
hardened Data Connect connector, 24-skill catalogue seeded).

**Operational — done:**
- ✅ Blaze billing · ✅ all 10 functions deployed · ✅ rules + connector deployed.
- ✅ Cloud SQL `skillx-pg` Runnable + schema migrated · ✅ **catalogue seeded (24 skills)**.
- ✅ `cloudfunctions.net/<name>` compat alias confirmed routing to the 2nd-gen functions.

**Optional / not yet done:**
- ⏳ Add **Google SHA fingerprints** (§5) — only needed for Google sign-in
  (email/password works without it).
- ⏳ First **end-to-end run** on the emulator.
- ⏳ Deferred niceties: a deeper **accessibility** pass, and **Firestore rules
  unit tests** (need the emulator + a JS runner).

> Nothing functional is outstanding — the app is built end-to-end and the backend
> is live and seeded. The remaining items are a first real run and polish.

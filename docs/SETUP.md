# SkillX — Setup & Execution Steps

Run these in order. Steps marked **[you]** need you (accounts/installs/secrets);
the rest I run. Firebase project: **`skillx-9a717`** (Auth: Email/Password + Google already on).

---

## 0. Prerequisites

| Tool | Status on this machine |
|------|------------------------|
| Node 24 / npm 11 | ✅ installed |
| Firebase CLI 15.25 | ✅ installed |
| git 2.54 | ✅ installed |
| **Flutter / Dart** | ❌ **not installed — blocks the app** |

### 0.1 [you] Install Flutter
1. Download the Flutter SDK for Windows: https://docs.flutter.dev/get-started/install/windows
2. Unzip to e.g. `C:\src\flutter`, add `C:\src\flutter\bin` to your PATH.
3. New terminal → `flutter doctor` and resolve what it flags (Android Studio + Android SDK,
   accept licenses via `flutter doctor --android-licenses`).
4. Tell me when `flutter --version` works and I continue.

### 0.2 [you] Confirm Blaze plan
Data Connect (Cloud SQL) and Cloud Functions require the **Blaze** pay-as-you-go plan on
`skillx-9a717`. Set a budget alert. (Cloud SQL is a small always-on paid instance.)

---

## 1. Backend — Data Connect + rules (no Flutter needed)

Scaffolding already committed: `dataconnect/`, `firebase.json`, `.firebaserc`,
`firestore.rules`, `storage.rules`.

```bash
firebase login          # [you] once, if not already
firebase deploy --only dataconnect        # provisions Cloud SQL + creates all tables
firebase deploy --only firestore:rules,storage    # chat + resume/photo rules
```

`firebase deploy --only dataconnect` reads `dataconnect/schema/schema.gql` and creates the
Postgres tables inside the `skillx-pg` instance. Re-run after any schema change.

> Prefer to review first? `firebase dataconnect:sql:diff` shows the SQL migration the schema
> will apply before you deploy.

---

## 2. Flutter app + Firebase wiring (after 0.1)

```bash
flutter create app --org app.skillx --platforms=android,ios
dart pub global activate flutterfire_cli
cd app && flutterfire configure --project=skillx-9a717   # writes firebase_options.dart + platform config
```

Then I add packages (`firebase_core`, `firebase_auth`, `google_sign_in`, `cloud_firestore`,
`firebase_messaging`, `firebase_storage`, `firebase_data_connect`, `flutter_riverpod`,
`go_router`, `fl_chart`, `pdf`, `printing`, `file_picker`) and generate the Data Connect Dart SDK:

```bash
firebase dataconnect:sdk:generate      # emits app/lib/generated/dataconnect
```

### 2.1 [you] Google sign-in fingerprints (Android)
```bash
cd app/android && ./gradlew signingReport
```
Copy the **SHA-1** and **SHA-256** into Firebase console → Project settings → your Android app,
then re-download `google-services.json` (I'll place it). iOS uses the `REVERSED_CLIENT_ID` URL
scheme from `GoogleService-Info.plist` (I wire that in `Info.plist`).

---

## 3. Cloud Functions (Phases 5–12)

```bash
cd functions && npm install
firebase functions:secrets:set GMAIL_USER
firebase functions:secrets:set GMAIL_APP_PASSWORD     # [you] 2FA + App Password
firebase functions:secrets:set ANTHROPIC_API_KEY      # [you] Claude key, spend cap set
firebase deploy --only functions
```

Functions cover: send meeting-link email (Gmail SMTP), accept-request → create session,
AI quiz generation + grading, streak update, module unlock, certificate issuance.

---

## 4. Run locally

```bash
firebase emulators:start        # auth + firestore + functions + dataconnect + storage
cd app && flutter run           # against emulators or live project
```

---

## Quick reference — what I still need from you

- [ ] Flutter installed (`flutter doctor` green)  ← **current blocker**
- [ ] Blaze plan confirmed on `skillx-9a717`
- [ ] `firebase login` done on this machine
- [ ] Android SHA-1/SHA-256 added + `google-services.json` re-downloaded (Phase 2)
- [ ] Gmail `USER` + App Password (Phase 5)
- [ ] Anthropic API key (Phase 6)
- [ ] Apple Developer account for iOS push (Phase 11)
- [ ] Content: logo/splash, About-Us details, seed skill catalogue, certificate wording

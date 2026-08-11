# SkillX — Development Plan (in-repo)

Peer-to-peer skill-swapping mobile app. Flutter + Firebase. Full v1.0 (all PRD **Must**).
Canonical source: `SkillX_PRD.md` (design tokens in the handoff `CLAUDE.md`).

## Architecture (locked)

- **App:** Flutter (Android 8+, iOS 13+), Riverpod state, `go_router` 5-tab shell
  (Home · Chat · Rewards · Dashboard · Profile).
- **Auth:** Firebase Auth — Email/Password **+ Google**. First Google login → "Complete your
  profile" (≥1 teach + ≥1 learn skill) before Home.
- **Structured data:** **Firebase Data Connect → Cloud SQL for PostgreSQL** (`dataconnect/`).
- **Realtime (hybrid):** **Firestore** for chat messages + presence; **FCM** for all push
  notifications (requests, session start, quiz ready). Data Connect has no realtime subscriptions.
- **Server logic:** Cloud Functions (TypeScript) — accept-request→session, meeting-link email
  (**Gmail SMTP**), **AI quiz generation (Claude API)** + grading, streak, module unlock,
  certificate PDF issuance. These do the writes clients are forbidden to make.
- **Charts** `fl_chart`; **certificate PDF** `pdf`+`printing` client-side.

## Data model

Data Connect schema: `dataconnect/schema/schema.gql` (User, Skill, UserSkill, LearningPath,
LearningModule, UserProgress, CompletedModule, Request, Session, SessionLearner, Quiz,
QuizQuestion, QuizAttempt, Certificate, Rating). Operations: `dataconnect/connector/*.gql`.
Chat (`chats/{id}` + `messages`) is in Firestore. Security highlights:
- `QuizQuestion.correctIndex` never returned by learner queries; grading is server-side.
- `UserProgress` + `Certificate` writable only by Cloud Functions (no self-unlock / forgery).
- Chat limited to the 2 participants (`firestore.rules`); resumes owner-write, PDF ≤5 MB.

## Phases (PRD roadmap order; each ends with screens on live data + smoke test)

1. **Foundation** — Flutter project, FlutterFire wiring, `ThemeData` from tokens, shared widget
   kit, `go_router` shell, generated Data Connect SDK. *(Deploy backend from `docs/SETUP.md` §1.)*
2. **Auth** — Splash, Register (+skill chips +photo), Login, Forgot-password; email verification,
   session persistence, Google sign-in + onboarding, inline errors, trust-model copy.
3. **Home & discovery** — header/streak, search, browse+rating, category filter, skill detail,
   send request, incoming accept/reject, upcoming card, "New teacher" label.
4. **Profile & resume** — identity, 3 skill sections, teaching stats, PDF upload (≤5 MB, progress,
   replace/delete, visibility), certificates strip, edit vs read-only.
5. **Requests → Pre-session form → link** — mandatory 4-question form, link locked until complete,
   accept-request Cloud Function → session + email + notify, live-session + start dialog.
6. **Quiz + AI generation + approval** — wrap-up: covered-subtopics checklist → Claude drafts 5
   MCQs → teacher edits/approves → release. Learner: attempt/skip, one-Q, back-nav, score, review.
7. **Rewards, badges, streak** — Bronze/Silver/Gold, streak Cloud Function (local-date rules),
   rewards grid + streak cards + milestones.
8. **Learning path & unlocking** — ordered modules, locks, 40% pass unlocks next (server write),
   progress bar, unlimited retakes, skip-keeps-locked dialog.
9. **Dashboard** — 4 summary cards, `fl_chart` line (last 10) + bar (per skill), recent activity,
   mandatory empty state; charts from attempt history.
10. **Certificate** — client PDF on full-path completion → Storage, celebration, immutable,
    participation-only wording, share sheet.
11. **Notifications** — FCM, deep-links, per-category toggles, quiet hours, "waiting to teach"
    cap 3/day, interest-targeted.
12. **Chat** (last) — Firestore realtime 1:1 (unlocks after accept), list, unread, session-link
    card, teacher "Start Session" / learner "Join" states.
13. **About, Ratings, polish, tests** — About Us, 1–5★ rating→avg, empty states, accessibility,
    widget/integration + rules tests.

## Required from you
See the checklist at the bottom of `docs/SETUP.md`. Current blocker: **install Flutter**.

## AI quiz note
At Phase 6 I load the `claude-api` skill first (current model IDs / JSON patterns), then write the
generation function: `{topic, coveredSubtopics[], level}` → 5 MCQs, difficulty per level (QUIZ-15),
inserted **unapproved**; nothing reaches learners until the teacher approves (QUIZ-18). Manual
authoring shares the same approval screen (QUIZ-14).

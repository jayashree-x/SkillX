# SkillX — System Architecture

Peer skill-swapping app on a **hybrid Firebase backend**: structured data in Cloud SQL
through Firebase Data Connect, the realtime layer in Firestore, and privileged writes
reserved for Cloud Functions. Client is Flutter (Android / iOS), state via Riverpod +
`go_router`.

```mermaid
flowchart TB
  classDef client fill:#EFF6FF,stroke:#2563EB,color:#1E3A8A;
  classDef fb fill:#F0FDFA,stroke:#0D9488,color:#0F766E;
  classDef fn fill:#FFF7ED,stroke:#D97706,color:#92400E;
  classDef store fill:#F1F5F9,stroke:#64748B,color:#334155;
  classDef ext fill:#FFF7ED,stroke:#F59E0B,color:#9A3412;

  subgraph CLIENT["Flutter app · Android / iOS"]
    direction TB
    UI["Presentation<br/>auth screens · 5-tab shell"]
    STATE["State & routing<br/>Riverpod · go_router auth gate"]
    REPO["Repositories<br/>auth · profile · skills · photo"]
    DCSDK["Generated Data Connect SDK"]
    UI --> STATE --> REPO --> DCSDK
  end

  subgraph FB["Firebase"]
    direction LR
    AUTH["Authentication<br/>email/password · Google"]
    DC["Data Connect<br/>GraphQL connector"]
    FS["Cloud Firestore<br/>chat · presence"]
    ST["Cloud Storage<br/>photos · resumes · certs"]
    FCM["Cloud Messaging<br/>push"]
    CF["Cloud Functions · TS<br/>server logic — Phase 5+"]
  end

  subgraph STORES["Data stores"]
    direction LR
    SQL[("Cloud SQL · Postgres<br/>users · skills · sessions · quizzes")]
    FSDB[("Firestore DB")]
    BUCK[("Storage buckets")]
  end

  subgraph EXT["External services"]
    direction LR
    CLAUDE["Claude API<br/>AI quiz generation"]
    GMAIL["Gmail SMTP<br/>meeting-link email"]
    MEET["Google Meet / Zoom<br/>live session"]
  end

  REPO -->|identity| AUTH
  DCSDK -->|queries · mutations| DC
  REPO -->|realtime| FS
  REPO -->|upload · download| ST
  FCM -.push.-> UI
  UI -.join link.-> MEET

  DC --> SQL
  FS --> FSDB
  ST --> BUCK

  CF -->|privileged writes| SQL
  CF --> CLAUDE
  CF --> GMAIL
  CF --> FCM
  CF --> ST

  class UI,STATE,REPO,DCSDK client
  class AUTH,DC,FS,ST,FCM fb
  class CF fn
  class SQL,FSDB,BUCK store
  class CLAUDE,GMAIL,MEET ext
```

## How data flows

- **Structured data** — the app calls the generated Data Connect SDK; auth-scoped GraphQL
  operations (`dataconnect/connector/*.gql`) resolve to **Cloud SQL Postgres**.
- **Chat & presence** — Firestore realtime listeners (the one part that needs live updates;
  Data Connect has no subscriptions).
- **Files** — profile photos, resume PDFs and certificates in Cloud Storage.
- **Push** — FCM delivers request, session-start and quiz-ready alerts.
- **Server logic** — Cloud Functions run accept-request → session, meeting-link email
  (Gmail SMTP), AI quiz generation (Claude API) + grading, streak, module unlock, and
  certificate PDF issuance.

## Security model

- Data Connect operations are **auth-scoped** — a user only reads their own rows via
  `eq_expr: "auth.uid"`.
- `UserProgress` and `Certificate` are **server-write only** — no self-unlock or forgery.
- `QuizQuestion.correctIndex` is never returned to learner-facing queries; grading is server-side.
- Firestore chat is limited to the two participants (`firestore.rules`); Storage is owner-write
  (`storage.rules`).

## Component map

| Layer | Where it lives |
|-------|----------------|
| Flutter client | `app/lib/` — `core/` (router, theme, widgets), `features/*/` (presentation · application · data), `shared/` |
| Generated DC SDK | `app/lib/generated/dataconnect/` (from `firebase dataconnect:sdk:generate`) |
| Data Connect schema & ops | `dataconnect/schema/schema.gql`, `dataconnect/connector/{queries,mutations}.gql` |
| Firestore / Storage rules | `firestore.rules`, `firestore.indexes.json`, `storage.rules` |
| Cloud Functions | `functions/` — **not yet created** (arrives Phase 5) |

> Phase status: foundation + authentication are built. Requests, sessions, quizzes, rewards,
> dashboard, certificates and chat follow the roadmap in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md).

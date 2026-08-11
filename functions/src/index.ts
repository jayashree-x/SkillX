import type { Request } from "firebase-functions/v2/https";
import { onRequest } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import type { Response } from "express";

import { CALENDAR_SECRETS, createMeeting } from "./calendar";
import { executeRead, executeWrite } from "./dataconnect";
import { GEMINI_API_KEY, generateQuizQuestions } from "./gemini";
import { notify } from "./notify";

initializeApp();

const REGION = "us-central1";

class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
  }
}

/** Verifies the caller's Firebase ID token (sent as `Authorization: Bearer`). */
async function requireUid(req: Request): Promise<string> {
  const header = req.headers.authorization;
  const match = typeof header === "string" ? header.match(/^Bearer (.+)$/) : null;
  if (!match) throw new ApiError(401, "Missing authentication token.");
  const decoded = await getAuth().verifyIdToken(match[1]);
  return decoded.uid;
}

function fail(res: Response, e: unknown): void {
  const err = e as ApiError;
  res.status(err.status ?? 500).json({ error: err.message ?? "Internal error" });
}

/**
 * Streak rules (RWD-01..05) using the device's local date (YYYY-MM-DD):
 * same day → unchanged, next day → +1, any bigger gap → reset to 1.
 */
function computeStreak(last: string | null, today: string, current: number): number {
  if (!last) return 1;
  if (last === today) return current > 0 ? current : 1;
  const d = new Date(`${today}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() - 1);
  const yesterday = d.toISOString().slice(0, 10);
  return last === yesterday ? current + 1 : 1;
}

interface RequestRow {
  id: string;
  status: string;
  teacher: { uid: string; name: string; photoUrl?: string | null };
  learner: { uid: string; name: string; photoUrl?: string | null; fcmToken?: string | null };
  skill: { name: string };
}

interface CreateSessionInput {
  requestId: string;
  learnerUids: string[];
  topic: string;
  topicTags?: string[];
  plannedSubtopics?: string[];
  level: string; // BASIC | BEGINNER | INTERMEDIATE | ADVANCED
  durationHours: number;
  scheduledAt?: string | null; // ISO 8601 start time
  timeZone?: string; // IANA tz for the calendar event (e.g. Asia/Kolkata)
}

interface LearnerContact {
  uid: string;
  name: string;
  email: string;
  fcmToken?: string | null;
}

interface QuizEdit {
  order: number;
  questionText: string;
  options: string[];
  correctIndex: number;
}

/**
 * HOME-06 / CHAT-02: a teacher accepts a request. Flips it to ACCEPTED, opens
 * the 1:1 chat, and notifies the learner.
 */
export const acceptRequest = onRequest({ region: REGION, cors: true }, async (req, res) => {
  try {
    if (req.method !== "POST") throw new ApiError(405, "Use POST.");
    const uid = await requireUid(req);
    const requestId = req.body?.requestId as string | undefined;
    if (!requestId) throw new ApiError(400, "requestId is required.");

    const { request } = await executeRead<{ request: RequestRow | null }>(
      `query($id: UUID!) {
        request(id: $id) {
          id status
          teacher { uid name photoUrl }
          learner { uid name photoUrl fcmToken }
          skill { name }
        }
      }`,
      { id: requestId },
    );
    if (!request) throw new ApiError(404, "Request not found.");
    if (request.teacher.uid !== uid) {
      throw new ApiError(403, "This request is not yours to accept.");
    }

    await executeWrite(
      `mutation($id: UUID!) { request_update(id: $id, data: { status: ACCEPTED }) }`,
      { id: requestId },
    );

    const { teacher, learner } = request;
    const chatId = [teacher.uid, learner.uid].sort().join("_");
    await getFirestore().doc(`chats/${chatId}`).set(
      {
        participants: [teacher.uid, learner.uid],
        // Denormalised member cards so the chat list renders without extra reads.
        members: {
          [teacher.uid]: { name: teacher.name, photoUrl: teacher.photoUrl ?? null },
          [learner.uid]: { name: learner.name, photoUrl: learner.photoUrl ?? null },
        },
        unread: { [teacher.uid]: 0, [learner.uid]: 0 },
        lastMessage: "Request accepted — say hello!",
        lastMessageAt: FieldValue.serverTimestamp(),
        createdAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    await notify(request.learner.uid, "requests", {
      title: "Request accepted",
      body: `Your request to learn ${request.skill.name} was accepted.`,
      route: "/home",
    });

    res.json({ ok: true, chatId });
  } catch (e) {
    fail(res, e);
  }
});

/**
 * Pre-Session Form submit (PRE-01..09): the teacher creates the session,
 * links learners, emails the meeting link, and notifies.
 */
export const createSession = onRequest(
  { region: REGION, cors: true, secrets: CALENDAR_SECRETS },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const d = req.body as CreateSessionInput | undefined;
      if (
        !d?.requestId || !d.topic || !d.level || !d.durationHours ||
        !d.learnerUids?.length
      ) {
        throw new ApiError(400, "Missing required session fields.");
      }

      // Verify ownership and get the teacher's contact (added as an attendee).
      const { request } = await executeRead<{
        request: { teacher: { uid: string; name: string; email: string } } | null;
      }>(
        `query($id: UUID!) { request(id: $id) { teacher { uid name email } } }`,
        { id: d.requestId },
      );
      if (!request) throw new ApiError(404, "Request not found.");
      if (request.teacher.uid !== uid) throw new ApiError(403, "This request is not yours.");

      // Learner contacts (attendees + FCM targets).
      const { users: learners } = await executeRead<{ users: LearnerContact[] }>(
        `query($ids: [String!]!) {
           users(where: { uid: { in: $ids } }) { uid name email fcmToken }
         }`,
        { ids: d.learnerUids },
      );

      // Create the Google Calendar event + Meet link; Calendar emails invites
      // to the teacher and every learner (replaces the old nodemailer email).
      const startIso = d.scheduledAt ?? new Date().toISOString();
      const meeting = await createMeeting({
        summary: `SkillX: ${d.topic}`,
        description:
          `${d.level.toLowerCase()} session (~${d.durationHours}h) on ${d.topic}.`,
        startIso,
        durationHours: d.durationHours,
        attendees: [
          request.teacher.email,
          ...learners.map((l) => l.email),
        ],
        timeZone: d.timeZone,
      });

      const created = await executeWrite<{ session_insert: { id: string } }>(
        `mutation(
           $requestId: UUID!, $teacherUid: String!, $topic: String!,
           $topicTags: [String!], $planned: [String!], $level: SessionLevel!,
           $duration: Int!, $link: String!, $scheduledAt: Timestamp
         ) {
           session_insert(data: {
             requestId: $requestId, teacherUid: $teacherUid, topic: $topic,
             topicTags: $topicTags, plannedSubtopics: $planned, level: $level,
             durationHours: $duration, meetingLink: $link, scheduledAt: $scheduledAt,
             status: SCHEDULED
           })
         }`,
        {
          requestId: d.requestId,
          teacherUid: uid,
          topic: d.topic,
          topicTags: d.topicTags ?? [],
          planned: d.plannedSubtopics ?? [],
          level: d.level,
          duration: d.durationHours,
          link: meeting.meetLink,
          scheduledAt: d.scheduledAt ?? null,
        },
      );
      const sessionId = created.session_insert.id;

      for (const learnerUid of d.learnerUids) {
        await executeWrite(
          `mutation($s: UUID!, $u: String!) {
             sessionLearner_insert(data: { sessionId: $s, learnerUid: $u })
           }`,
          { s: sessionId, u: learnerUid },
        );
      }

      // Push notification (the calendar invite is the email side) + drop a
      // session-link card into each 1:1 chat (CHAT-05).
      for (const learner of learners) {
        await notify(learner.uid, "sessions", {
          title: "Session confirmed",
          body: `Your ${d.topic} session is scheduled. Check your calendar.`,
          route: "/home",
        });
        const chatId = [uid, learner.uid].sort().join("_");
        await getFirestore().doc(`chats/${chatId}`).set(
          {
            session: {
              id: sessionId,
              teacherUid: uid,
              topic: d.topic,
              meetingLink: meeting.meetLink,
              scheduledAt: d.scheduledAt ?? null,
            },
            lastMessage: "Session scheduled — see the meeting card.",
            lastMessageAt: FieldValue.serverTimestamp(),
          },
          { merge: true },
        );
      }

      res.json({
        sessionId,
        meetingLink: meeting.meetLink,
        eventLink: meeting.eventLink,
      });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * QUIZ-13 / POST-05: from the confirmed covered subtopics, Claude drafts 5 MCQs
 * (inserted UNAPPROVED — QUIZ-18). Stores coveredSubtopics on the session (POST-08).
 */
export const generateQuiz = onRequest(
  { region: REGION, cors: true, secrets: [GEMINI_API_KEY], timeoutSeconds: 120 },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const sessionId = req.body?.sessionId as string | undefined;
      const coveredSubtopics = req.body?.coveredSubtopics as string[] | undefined;
      if (!sessionId || !coveredSubtopics?.length) {
        throw new ApiError(400, "sessionId and coveredSubtopics are required.");
      }

      const { session } = await executeRead<{
        session: {
          id: string;
          topic: string;
          level: string;
          teacher: { uid: string };
          skill: { id: string };
        } | null;
      }>(
        `query($id: UUID!) {
           session(id: $id) { id topic level teacher { uid } skill { id } }
         }`,
        { id: sessionId },
      );
      if (!session) throw new ApiError(404, "Session not found.");
      if (session.teacher.uid !== uid) throw new ApiError(403, "Not your session.");

      // POST-08: record covered subtopics and close the session.
      await executeWrite(
        `mutation($id: UUID!, $subs: [String!]) {
           session_update(id: $id, data: { coveredSubtopics: $subs, status: COMPLETED })
         }`,
        { id: sessionId, subs: coveredSubtopics },
      );

      const questions = await generateQuizQuestions({
        topic: session.topic,
        coveredSubtopics,
        level: session.level,
      });

      const created = await executeWrite<{ quiz_insert: { id: string } }>(
        `mutation(
           $sessionId: UUID!, $skillId: UUID!, $teacherUid: String!,
           $topic: String!, $subs: [String!], $level: SessionLevel!
         ) {
           quiz_insert(data: {
             sessionId: $sessionId, skillId: $skillId, teacherUid: $teacherUid,
             topic: $topic, coveredSubtopics: $subs, level: $level,
             generationMethod: AUTO, isApproved: false
           })
         }`,
        {
          sessionId,
          skillId: session.skill.id,
          teacherUid: uid,
          topic: session.topic,
          subs: coveredSubtopics,
          level: session.level,
        },
      );
      const quizId = created.quiz_insert.id;

      let order = 1;
      for (const q of questions) {
        await executeWrite(
          `mutation(
             $quiz: UUID!, $order: Int!, $qt: String!,
             $o0: String!, $o1: String!, $o2: String!, $o3: String!, $ci: Int!
           ) {
             quizQuestion_insert(data: {
               quizId: $quiz, order: $order, questionText: $qt,
               option0: $o0, option1: $o1, option2: $o2, option3: $o3, correctIndex: $ci
             })
           }`,
          {
            quiz: quizId,
            order: order++,
            qt: q.questionText,
            o0: q.options[0],
            o1: q.options[1],
            o2: q.options[2],
            o3: q.options[3],
            ci: q.correctIndex,
          },
        );
      }

      // Return the draft for the teacher to review (includes correct answers —
      // this is the teacher-facing approval screen, not a learner query).
      res.json({ quizId, questions });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * QUIZ-13/18: teacher applies optional edits and releases the quiz to learners.
 */
export const approveQuiz = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const quizId = req.body?.quizId as string | undefined;
      const edits = req.body?.edits as QuizEdit[] | undefined;
      if (!quizId) throw new ApiError(400, "quizId is required.");

      const { quiz } = await executeRead<{ quiz: { teacher: { uid: string } } | null }>(
        `query($id: UUID!) { quiz(id: $id) { teacher { uid } } }`,
        { id: quizId },
      );
      if (!quiz) throw new ApiError(404, "Quiz not found.");
      if (quiz.teacher.uid !== uid) throw new ApiError(403, "Not your quiz.");

      if (Array.isArray(edits)) {
        for (const e of edits) {
          await executeWrite(
            `mutation(
               $quiz: UUID!, $order: Int!, $qt: String!,
               $o0: String!, $o1: String!, $o2: String!, $o3: String!, $ci: Int!
             ) {
               quizQuestion_updateMany(
                 where: { quizId: { eq: $quiz }, order: { eq: $order } },
                 data: {
                   questionText: $qt, option0: $o0, option1: $o1,
                   option2: $o2, option3: $o3, correctIndex: $ci
                 }
               )
             }`,
            {
              quiz: quizId,
              order: e.order,
              qt: e.questionText,
              o0: e.options[0],
              o1: e.options[1],
              o2: e.options[2],
              o3: e.options[3],
              ci: e.correctIndex,
            },
          );
        }
      }

      await executeWrite(
        `mutation($id: UUID!, $now: Timestamp!) {
           quiz_update(id: $id, data: { isApproved: true, approvedAt: $now })
         }`,
        { id: quizId, now: new Date().toISOString() },
      );

      res.json({ ok: true });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * QUIZ-07/11: server-side grading. correctIndex never leaves the server; one
 * immutable attempt row is written per submission.
 */
export const gradeQuiz = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const quizId = req.body?.quizId as string | undefined;
      const answers = req.body?.answers as number[] | undefined;
      if (!quizId || !Array.isArray(answers)) {
        throw new ApiError(400, "quizId and answers are required.");
      }

      const { quiz } = await executeRead<{
        quiz: {
          isApproved: boolean;
          skill: { name: string };
          session: {
            module: { id: string; order: number } | null;
            path: { id: string } | null;
          };
          questions: { order: number; correctIndex: number }[];
        } | null;
      }>(
        `query($id: UUID!) {
           quiz(id: $id) {
             isApproved
             skill { name }
             session {
               module { id order }
               path { id }
             }
             questions: quizQuestions_on_quiz(orderBy: { order: ASC }) {
               order correctIndex
             }
           }
         }`,
        { id: quizId },
      );
      if (!quiz) throw new ApiError(404, "Quiz not found.");
      if (!quiz.isApproved) throw new ApiError(403, "This quiz has not been released yet.");

      const total = quiz.questions.length;
      const correctIndexes: number[] = [];
      let score = 0;
      quiz.questions.forEach((q, i) => {
        correctIndexes.push(q.correctIndex);
        if (answers[i] === q.correctIndex) score++;
      });
      const percentage = total > 0 ? (score / total) * 100 : 0;
      const badge =
        percentage >= 80 ? "gold" :
        percentage >= 60 ? "silver" :
        percentage >= 40 ? "bronze" : "none";

      await executeWrite(
        `mutation(
           $uid: String!, $quiz: UUID!, $skill: String!,
           $score: Int!, $total: Int!, $pct: Float!, $badge: String
         ) {
           quizAttempt_insert(data: {
             userUid: $uid, quizId: $quiz, skillName: $skill,
             score: $score, totalQuestions: $total, percentage: $pct, badgeEarned: $badge
           })
         }`,
        { uid, quiz: quizId, skill: quiz.skill.name, score, total, pct: percentage, badge },
      );

      // Completing a quiz earns a streak day (RWD-01). The client sends its
      // local date so the calendar-day rules follow the device (RWD-05).
      let currentStreak: number | undefined;
      const localDate = req.body?.localDate as string | undefined;
      if (typeof localDate === "string" && /^\d{4}-\d{2}-\d{2}$/.test(localDate)) {
        const { users } = await executeRead<{
          users: {
            currentStreak: number;
            longestStreak: number;
            lastActivityDate: string | null;
          }[];
        }>(
          `query($uid: String!) {
             users(where: { uid: { eq: $uid } }, limit: 1) {
               currentStreak longestStreak lastActivityDate
             }
           }`,
          { uid },
        );
        const u = users[0];
        if (u) {
          currentStreak = computeStreak(u.lastActivityDate, localDate, u.currentStreak);
          const longestStreak = Math.max(u.longestStreak, currentStreak);
          await executeWrite(
            `mutation($uid: String!, $s: Int!, $l: Int!, $d: Date!) {
               user_update(key: { uid: $uid }, data: {
                 currentStreak: $s, longestStreak: $l, lastActivityDate: $d
               })
             }`,
            { uid, s: currentStreak, l: longestStreak, d: localDate },
          );
        }
      }

      // PATH-03: passing (>=40%) a module quiz unlocks the next module. This is
      // a server-only write; progress is driven by unlockedUpTo alone.
      let pathAdvanced = false;
      let pathComplete = false;
      const module = quiz.session.module;
      const path = quiz.session.path;
      if (module && path && percentage >= 40) {
        const pathId = path.id;
        const moduleOrder = module.order;

        const { userProgresses } = await executeRead<{
          userProgresses: { unlockedUpTo: number; isPathComplete: boolean }[];
        }>(
          `query($uid: String!, $path: UUID!) {
             userProgresses(
               where: { user: { uid: { eq: $uid } }, path: { id: { eq: $path } } }
               limit: 1
             ) { unlockedUpTo isPathComplete }
           }`,
          { uid, path: pathId },
        );
        if (userProgresses.length === 0) {
          await executeWrite(
            `mutation($uid: String!, $path: UUID!) {
               userProgress_insert(data: { userUid: $uid, pathId: $path })
             }`,
            { uid, path: pathId },
          );
        }
        const prevUnlocked = userProgresses[0]?.unlockedUpTo ?? 1;

        const { learningModules } = await executeRead<{
          learningModules: { order: number }[];
        }>(
          `query($path: UUID!) {
             learningModules(where: { path: { id: { eq: $path } } }) { order }
           }`,
          { path: pathId },
        );
        const totalModules = learningModules.length;

        const newUnlocked = Math.max(
          prevUnlocked,
          Math.min(moduleOrder + 1, Math.max(totalModules, 1)),
        );
        pathComplete = totalModules > 0 && moduleOrder >= totalModules;
        if (newUnlocked !== prevUnlocked || pathComplete) {
          await executeWrite(
            `mutation($uid: String!, $path: UUID!, $u: Int!, $c: Boolean!) {
               userProgress_update(
                 key: { userUid: $uid, pathId: $path }
                 data: { unlockedUpTo: $u, currentModuleOrder: $u, isPathComplete: $c }
               )
             }`,
            { uid, path: pathId, u: newUnlocked, c: pathComplete },
          );
          pathAdvanced = true;
        }
      }

      if (badge !== "none") {
        await notify(uid, "rewards", {
          title: "Badge earned!",
          body: `You earned a ${badge} badge on ${quiz.skill.name}.`,
          route: "/rewards",
        });
      }

      res.json({
        score, total, percentage, badge, correctIndexes,
        currentStreak, pathAdvanced, pathComplete,
      });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * PATH-01/02: enrol the caller in a learning path. Creates a UserProgress row
 * (server-write only) with module 1 unlocked. Idempotent — re-enrolling is a
 * no-op that leaves existing progress untouched.
 */
export const enrollPath = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const pathId = req.body?.pathId as string | undefined;
      if (!pathId) throw new ApiError(400, "pathId is required.");

      const { userProgresses } = await executeRead<{
        userProgresses: { unlockedUpTo: number }[];
      }>(
        `query($uid: String!, $path: UUID!) {
           userProgresses(
             where: { user: { uid: { eq: $uid } }, path: { id: { eq: $path } } }
             limit: 1
           ) { unlockedUpTo }
         }`,
        { uid, path: pathId },
      );
      if (userProgresses.length === 0) {
        await executeWrite(
          `mutation($uid: String!, $path: UUID!) {
             userProgress_insert(data: { userUid: $uid, pathId: $path })
           }`,
          { uid, path: pathId },
        );
      }
      res.json({ ok: true });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * CERT-01/09: issue a participation certificate once a path is complete. The
 * record is server-written and immutable; this is idempotent (re-issuing
 * returns the existing certificate). The PDF is generated + uploaded on-device,
 * then linked via `attachCertificatePdf`.
 */
export const issueCertificate = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const pathId = req.body?.pathId as string | undefined;
      if (!pathId) throw new ApiError(400, "pathId is required.");

      // Must have completed the path.
      const { userProgresses } = await executeRead<{
        userProgresses: { isPathComplete: boolean }[];
      }>(
        `query($uid: String!, $path: UUID!) {
           userProgresses(
             where: { user: { uid: { eq: $uid } }, path: { id: { eq: $path } } }
             limit: 1
           ) { isPathComplete }
         }`,
        { uid, path: pathId },
      );
      if (!userProgresses[0]?.isPathComplete) {
        throw new ApiError(403, "This path is not complete yet.");
      }

      const { users } = await executeRead<{ users: { name: string }[] }>(
        `query($uid: String!) {
           users(where: { uid: { eq: $uid } }, limit: 1) { name }
         }`,
        { uid },
      );
      const userName = users[0]?.name ?? "SkillX learner";

      // Already issued? Return it unchanged (immutable).
      const { certificates } = await executeRead<{
        certificates: {
          id: string; skillName: string; teacherName: string;
          averageScore: number; modulesCompleted: number;
          pdfUrl: string | null; issuedAt: string;
        }[];
      }>(
        `query($uid: String!, $path: UUID!) {
           certificates(
             where: { user: { uid: { eq: $uid } }, path: { id: { eq: $path } } }
             limit: 1
           ) { id skillName teacherName averageScore modulesCompleted pdfUrl issuedAt }
         }`,
        { uid, path: pathId },
      );
      if (certificates[0]) {
        const c = certificates[0];
        res.json({
          certificateId: c.id, userName, skillName: c.skillName,
          teacherName: c.teacherName, averageScore: c.averageScore,
          modulesCompleted: c.modulesCompleted, issuedAt: c.issuedAt,
          pdfUrl: c.pdfUrl,
        });
        return;
      }

      // Path facts.
      const { learningPath } = await executeRead<{
        learningPath: {
          skill: { name: string };
          teacher: { name: string };
          modules: { id: string }[];
        } | null;
      }>(
        `query($path: UUID!) {
           learningPath(id: $path) {
             skill { name }
             teacher { name }
             modules: learningModules_on_path { id }
           }
         }`,
        { path: pathId },
      );
      if (!learningPath) throw new ApiError(404, "Path not found.");
      const skillName = learningPath.skill.name;
      const teacherName = learningPath.teacher.name;
      const modulesCompleted = learningPath.modules.length;

      // Average score across this learner's attempts for the path's skill.
      const { quizAttempts } = await executeRead<{
        quizAttempts: { percentage: number }[];
      }>(
        `query($uid: String!, $skill: String!) {
           quizAttempts(
             where: { user: { uid: { eq: $uid } }, skillName: { eq: $skill } }
           ) { percentage }
         }`,
        { uid, skill: skillName },
      );
      const averageScore = quizAttempts.length === 0
        ? 0
        : quizAttempts.reduce((s, a) => s + a.percentage, 0) / quizAttempts.length;

      const inserted = await executeWrite<{ certificate_insert: { id: string } }>(
        `mutation(
           $uid: String!, $path: UUID!, $skill: String!,
           $teacher: String!, $avg: Float!, $mods: Int!
         ) {
           certificate_insert(data: {
             userUid: $uid, pathId: $path, skillName: $skill,
             teacherName: $teacher, averageScore: $avg, modulesCompleted: $mods
           }) { id }
         }`,
        { uid, path: pathId, skill: skillName, teacher: teacherName, avg: averageScore, mods: modulesCompleted },
      );
      const certificateId = inserted.certificate_insert.id;

      await executeWrite(
        `mutation($uid: String!, $path: UUID!, $cid: UUID!) {
           userProgress_update(
             key: { userUid: $uid, pathId: $path }
             data: { certificateId: $cid }
           )
         }`,
        { uid, path: pathId, cid: certificateId },
      );

      res.json({
        certificateId, userName, skillName, teacherName,
        averageScore, modulesCompleted,
        issuedAt: new Date().toISOString(), pdfUrl: null,
      });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * Links the on-device-generated PDF URL to the certificate. Write-once — if a
 * URL is already set, it is preserved (CERT-09 immutability).
 */
export const attachCertificatePdf = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const certificateId = req.body?.certificateId as string | undefined;
      const pdfUrl = req.body?.pdfUrl as string | undefined;
      if (!certificateId || !pdfUrl) {
        throw new ApiError(400, "certificateId and pdfUrl are required.");
      }

      const { certificate } = await executeRead<{
        certificate: { user: { uid: string }; pdfUrl: string | null } | null;
      }>(
        `query($id: UUID!) {
           certificate(id: $id) { user { uid } pdfUrl }
         }`,
        { id: certificateId },
      );
      if (!certificate) throw new ApiError(404, "Certificate not found.");
      if (certificate.user.uid !== uid) throw new ApiError(403, "Not your certificate.");
      if (certificate.pdfUrl) {
        res.json({ ok: true, pdfUrl: certificate.pdfUrl });
        return;
      }

      await executeWrite(
        `mutation($id: UUID!, $url: String!) {
           certificate_update(id: $id, data: { pdfUrl: $url })
         }`,
        { id: certificateId, url: pdfUrl },
      );
      res.json({ ok: true, pdfUrl });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * RATE-01: a learner rates a session's teacher (1–5). One rating per
 * learner+session (re-submitting updates it), then the teacher's averageRating
 * is recomputed server-side — the field is a server-owned aggregate.
 */
export const submitRating = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const sessionId = req.body?.sessionId as string | undefined;
      const teacherUid = req.body?.teacherUid as string | undefined;
      const stars = req.body?.stars as number | undefined;
      const feedback = (req.body?.feedback as string | undefined) ?? null;
      if (!sessionId || !teacherUid || typeof stars !== "number" ||
          stars < 1 || stars > 5) {
        throw new ApiError(400, "sessionId, teacherUid and stars (1–5) are required.");
      }
      if (teacherUid === uid) {
        throw new ApiError(403, "You can't rate your own session.");
      }

      const { ratings } = await executeRead<{ ratings: { id: string }[] }>(
        `query($s: UUID!, $uid: String!) {
           ratings(
             where: { session: { id: { eq: $s } }, learner: { uid: { eq: $uid } } }
             limit: 1
           ) { id }
         }`,
        { s: sessionId, uid },
      );

      if (ratings[0]) {
        await executeWrite(
          `mutation($id: UUID!, $stars: Int!, $fb: String) {
             rating_update(id: $id, data: { stars: $stars, feedback: $fb })
           }`,
          { id: ratings[0].id, stars, fb: feedback },
        );
      } else {
        await executeWrite(
          `mutation($s: UUID!, $l: String!, $t: String!, $stars: Int!, $fb: String) {
             rating_insert(data: {
               sessionId: $s, learnerUid: $l, teacherUid: $t, stars: $stars, feedback: $fb
             })
           }`,
          { s: sessionId, l: uid, t: teacherUid, stars, fb: feedback },
        );
      }

      // Recompute the teacher's average from all their ratings.
      const { ratings: all } = await executeRead<{ ratings: { stars: number }[] }>(
        `query($t: String!) {
           ratings(where: { teacher: { uid: { eq: $t } } }) { stars }
         }`,
        { t: teacherUid },
      );
      const averageRating = all.length === 0
        ? 0
        : all.reduce((sum, r) => sum + r.stars, 0) / all.length;

      await executeWrite(
        `mutation($t: String!, $avg: Float!) {
           user_update(key: { uid: $t }, data: { averageRating: $avg })
         }`,
        { t: teacherUid, avg: averageRating },
      );

      res.json({ ok: true, averageRating });
    } catch (e) {
      fail(res, e);
    }
  },
);

/**
 * HOME-05 + NOTIF (interest-targeted, capped): a learner sends a request to a
 * teacher. Inserts the request, then notifies that teacher that a learner is
 * waiting — capped at 3 such pushes per teacher per (UTC) day so an in-demand
 * teacher isn't spammed. The daily counter lives in Firestore.
 */
export const sendRequest = onRequest(
  { region: REGION, cors: true },
  async (req, res) => {
    try {
      if (req.method !== "POST") throw new ApiError(405, "Use POST.");
      const uid = await requireUid(req);
      const teacherUid = req.body?.teacherUid as string | undefined;
      const skillId = req.body?.skillId as string | undefined;
      const when = (req.body?.preferredDateTime as string | undefined) ?? null;
      const message = (req.body?.message as string | undefined) ?? null;
      if (!teacherUid || !skillId) {
        throw new ApiError(400, "teacherUid and skillId are required.");
      }
      if (teacherUid === uid) {
        throw new ApiError(403, "You can't send a request to yourself.");
      }

      const created = await executeWrite<{ request_insert: { id: string } }>(
        `mutation($l: String!, $t: String!, $s: UUID!, $when: Timestamp, $msg: String) {
           request_insert(data: {
             learnerUid: $l, teacherUid: $t, skillId: $s,
             preferredDateTime: $when, message: $msg
           }) { id }
         }`,
        { l: uid, t: teacherUid, s: skillId, when, msg: message },
      );
      const requestId = created.request_insert.id;

      // "Learner waiting to teach" push, capped at 3/day per teacher.
      const [{ users }, { skill }] = await Promise.all([
        executeRead<{ users: { name: string }[] }>(
          `query($uid: String!) { users(where: { uid: { eq: $uid } }, limit: 1) { name } }`,
          { uid },
        ),
        executeRead<{ skill: { name: string } | null }>(
          `query($id: UUID!) { skill(id: $id) { name } }`,
          { id: skillId },
        ),
      ]);
      const learnerName = users[0]?.name ?? "A learner";
      const skillName = skill?.name ?? "a skill";

      const today = new Date().toISOString().slice(0, 10);
      const counterRef = getFirestore().doc(`notifCounters/${teacherUid}`);
      const snap = await counterRef.get();
      const data = snap.data() ?? {};
      const count = data.date === today ? (data.teachCount as number) ?? 0 : 0;

      if (count < 3) {
        const sent = await notify(teacherUid, "teaching", {
          title: "New learning request",
          body: `${learnerName} wants to learn ${skillName} from you.`,
          route: "/home",
        });
        if (sent) {
          await counterRef.set({ date: today, teachCount: count + 1 }, { merge: true });
        }
      }

      res.json({ ok: true, requestId });
    } catch (e) {
      fail(res, e);
    }
  },
);

import { getMessaging } from "firebase-admin/messaging";

import { executeRead, executeWrite } from "./dataconnect";

export type NotifyCategory =
  | "requests"
  | "sessions"
  | "quizzes"
  | "rewards"
  | "teaching"
  | "messages";

interface Prefs {
  requests?: boolean;
  sessions?: boolean;
  quizzes?: boolean;
  rewards?: boolean;
  teaching?: boolean;
  messages?: boolean;
  quietStart?: number | null; // local hour 0–23, null = disabled
  quietEnd?: number | null;
  utcOffsetMinutes?: number | null; // device offset captured at save time
}

/** True if the user's local time is inside their quiet-hours window (may wrap midnight). */
function inQuietHours(prefs: Prefs): boolean {
  const { quietStart, quietEnd } = prefs;
  if (quietStart == null || quietEnd == null || quietStart === quietEnd) {
    return false;
  }
  const offset = prefs.utcOffsetMinutes ?? 0;
  const localHour = new Date(Date.now() + offset * 60_000).getUTCHours();
  return quietStart < quietEnd
    ? localHour >= quietStart && localHour < quietEnd
    : localHour >= quietStart || localHour < quietEnd; // wraps past midnight
}

/**
 * Sends a push notification to one user, honoring their per-category toggles
 * and quiet hours (NOTIF-03/04). Returns whether a push was actually sent —
 * false if the user has no token, has muted the category, or is in quiet hours.
 * `route` rides in the data payload for deep-linking on tap (NOTIF-02).
 */
export async function notify(
  uid: string,
  category: NotifyCategory,
  msg: { title: string; body: string; route?: string },
): Promise<boolean> {
  const { users } = await executeRead<{
    users: { fcmToken: string | null; notificationPrefs: Prefs | null }[];
  }>(
    `query($uid: String!) {
       users(where: { uid: { eq: $uid } }, limit: 1) { fcmToken notificationPrefs }
     }`,
    { uid },
  );
  const user = users[0];
  if (!user?.fcmToken) return false;

  const prefs = user.notificationPrefs ?? {};
  if (prefs[category] === false) return false; // category muted
  if (inQuietHours(prefs)) return false;

  // Push is best-effort: a delivery failure must never fail the caller's
  // action (e.g. sendRequest). A stale token (app reinstalled) throws
  // `messaging/registration-token-not-registered`; we clear it so we stop
  // retrying a dead token, and swallow every other send error too.
  try {
    await getMessaging().send({
      token: user.fcmToken,
      notification: { title: msg.title, body: msg.body },
      data: msg.route ? { route: msg.route } : {},
    });
    return true;
  } catch (err: unknown) {
    const code = (err as { code?: string })?.code ?? "";
    const dead =
      code === "messaging/registration-token-not-registered" ||
      code === "messaging/invalid-registration-token" ||
      code === "messaging/invalid-argument";
    if (dead) {
      try {
        await executeWrite(
          `mutation($uid: String!) { user_update(key: { uid: $uid }, data: { fcmToken: null }) }`,
          { uid },
        );
      } catch {
        /* best-effort cleanup */
      }
    }
    console.error("notify: push failed (ignored):", code || err);
    return false;
  }
}

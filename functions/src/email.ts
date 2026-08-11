import { defineSecret } from "firebase-functions/params";
import * as nodemailer from "nodemailer";

// Set with: firebase functions:secrets:set GMAIL_USER / GMAIL_APP_PASSWORD
// (the app password is a 16-char Google App Password, not the account password).
export const GMAIL_USER = defineSecret("GMAIL_USER");
export const GMAIL_APP_PASSWORD = defineSecret("GMAIL_APP_PASSWORD");

/** Every function that sends email must declare these so the secrets bind. */
export const EMAIL_SECRETS = [GMAIL_USER, GMAIL_APP_PASSWORD];

export interface NotificationEmail {
  to: string;
  subject: string;
  html: string;
}

/**
 * Generic transactional email over Gmail SMTP — for account/OTP/promotional and
 * other notifications. Meeting scheduling does NOT use this: it uses the Google
 * Calendar API (see calendar.ts), which sends its own invites.
 */
export async function sendNotificationEmail(mail: NotificationEmail): Promise<void> {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: { user: GMAIL_USER.value(), pass: GMAIL_APP_PASSWORD.value() },
  });

  await transporter.sendMail({
    from: `SkillX <${GMAIL_USER.value()}>`,
    to: mail.to,
    subject: mail.subject,
    html: mail.html,
  });
}

/** Convenience wrapper that applies the SkillX shell to arbitrary body HTML. */
export function skillxEmailShell(headline: string, bodyHtml: string): string {
  return `
    <div style="font-family:system-ui,sans-serif;max-width:520px">
      <h2 style="color:#2563EB;margin-bottom:4px">${headline}</h2>
      ${bodyHtml}
      <p style="color:#94A3B8;font-size:12px">Sent by SkillX — a peer-learning platform.</p>
    </div>`;
}

import { defineSecret } from "firebase-functions/params";
import { google } from "googleapis";

// OAuth2 credentials for the SkillX "organizer" Google account. Set with:
//   firebase functions:secrets:set GOOGLE_OAUTH_CLIENT_ID
//   firebase functions:secrets:set GOOGLE_OAUTH_CLIENT_SECRET
//   firebase functions:secrets:set GOOGLE_OAUTH_REFRESH_TOKEN
// The refresh token is minted once via the consent flow (see backend setup docs)
// with scope https://www.googleapis.com/auth/calendar.events.
export const GOOGLE_OAUTH_CLIENT_ID = defineSecret("GOOGLE_OAUTH_CLIENT_ID");
export const GOOGLE_OAUTH_CLIENT_SECRET = defineSecret("GOOGLE_OAUTH_CLIENT_SECRET");
export const GOOGLE_OAUTH_REFRESH_TOKEN = defineSecret("GOOGLE_OAUTH_REFRESH_TOKEN");

/** Every Calendar function must declare these so the secrets are bound at runtime. */
export const CALENDAR_SECRETS = [
  GOOGLE_OAUTH_CLIENT_ID,
  GOOGLE_OAUTH_CLIENT_SECRET,
  GOOGLE_OAUTH_REFRESH_TOKEN,
];

export interface MeetingRequest {
  summary: string;
  description?: string;
  startIso: string; // ISO 8601 start time
  durationHours: number;
  attendees: string[]; // emails — Calendar sends the invites
  timeZone?: string; // IANA tz, defaults to Asia/Kolkata
}

export interface MeetingResult {
  meetLink: string; // Google Meet video link
  eventLink: string; // Calendar event (htmlLink)
  eventId: string;
}

/**
 * Creates a Google Calendar event with a Google Meet link and invites the
 * attendees (they receive a calendar invite email automatically). Runs as the
 * organizer account authorised by the stored refresh token.
 */
export async function createMeeting(req: MeetingRequest): Promise<MeetingResult> {
  const auth = new google.auth.OAuth2(
    GOOGLE_OAUTH_CLIENT_ID.value(),
    GOOGLE_OAUTH_CLIENT_SECRET.value(),
  );
  auth.setCredentials({ refresh_token: GOOGLE_OAUTH_REFRESH_TOKEN.value() });
  const calendar = google.calendar({ version: "v3", auth });

  const start = new Date(req.startIso);
  const end = new Date(start.getTime() + req.durationHours * 3600 * 1000);
  const timeZone = req.timeZone ?? "Asia/Kolkata";

  const { data: event } = await calendar.events.insert({
    calendarId: "primary",
    conferenceDataVersion: 1, // required to generate a Meet link
    sendUpdates: "all", // email invites to every attendee
    requestBody: {
      summary: req.summary,
      description: req.description,
      start: { dateTime: start.toISOString(), timeZone },
      end: { dateTime: end.toISOString(), timeZone },
      attendees: req.attendees.filter(Boolean).map((email) => ({ email })),
      conferenceData: {
        createRequest: {
          requestId: `skillx-${Date.now()}`,
          conferenceSolutionKey: { type: "hangoutsMeet" },
        },
      },
    },
  });

  const meetLink =
    event.hangoutLink ??
    event.conferenceData?.entryPoints?.find(
      (e) => e.entryPointType === "video",
    )?.uri ??
    "";

  return {
    meetLink,
    eventLink: event.htmlLink ?? "",
    eventId: event.id ?? "",
  };
}

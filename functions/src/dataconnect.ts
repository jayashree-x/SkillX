import { getDataConnect } from "firebase-admin/data-connect";

// Matches dataconnect/dataconnect.yaml (serviceId + location).
const CONNECTOR = { serviceId: "skillx", location: "us-central1" };

/**
 * Runs a privileged GraphQL mutation against Data Connect (Cloud SQL). Admin
 * access bypasses @auth, so these perform the writes clients are forbidden to
 * make (sessions, progress, certificates, quiz grading).
 */
export async function executeWrite<T = unknown>(
  mutation: string,
  variables: Record<string, unknown>,
): Promise<T> {
  const res = await getDataConnect(CONNECTOR).executeGraphql<T, Record<string, unknown>>(
    mutation,
    { variables },
  );
  return res.data;
}

/** Read-only GraphQL (cannot modify data). */
export async function executeRead<T = unknown>(
  query: string,
  variables: Record<string, unknown>,
): Promise<T> {
  const res = await getDataConnect(CONNECTOR).executeGraphqlRead<T, Record<string, unknown>>(
    query,
    { variables },
  );
  return res.data;
}

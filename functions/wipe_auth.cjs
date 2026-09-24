// One-off: delete ALL Firebase Authentication accounts.
// Run:  cd functions && node wipe_auth.cjs
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

initializeApp({ projectId: "skillx-9a717" });

async function main() {
  const auth = getAuth();
  let deleted = 0;
  let pageToken;
  do {
    const res = await auth.listUsers(1000, pageToken);
    const uids = res.users.map((u) => u.uid);
    if (uids.length) {
      const r = await auth.deleteUsers(uids);
      deleted += r.successCount;
      if (r.failureCount) {
        console.error("Some deletions failed:", r.errors.map((e) => e.error.message));
      }
    }
    pageToken = res.pageToken;
  } while (pageToken);
  console.log("Deleted Firebase Auth accounts:", deleted);
}

main().catch((e) => {
  console.error("Auth wipe failed:", e.message || e);
  process.exit(1);
});

// One-off data reset — deletes ALL user data (keeps the Skill catalogue).
// Run:  gcloud auth application-default login   (once, if not already)
//       cd functions && node wipe_users.cjs
const { initializeApp } = require("firebase-admin/app");
const { getDataConnect } = require("firebase-admin/data-connect");

initializeApp({ projectId: "skillx-9a717" });
const dc = getDataConnect({ serviceId: "skillx", location: "us-central1" });

// Child rows first, parents last (respects foreign keys). Skill is intentionally
// NOT here — the catalogue stays.
const order = [
  "rating", "certificate", "completedModule", "userProgress",
  "quizAttempt", "quizQuestion", "quiz", "sessionLearner", "session",
  "request", "userSkill", "learningModule", "learningPath", "user",
];

async function main() {
  for (const t of order) {
    try {
      const res = await dc.executeGraphql(`mutation { ${t}_deleteMany(all: true) }`);
      console.log(`  ${t.padEnd(16)} deleted:`, JSON.stringify(res.data[`${t}_deleteMany`]));
    } catch (e) {
      console.error(`  ${t.padEnd(16)} FAILED:`, e.message || e);
      throw e;
    }
  }
  console.log("Done. Skill catalogue kept.");
}

main().catch((e) => {
  console.error("Wipe failed:", e.message || e);
  process.exit(1);
});

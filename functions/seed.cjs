// One-off catalogue seeder — run from cmd:
//   1) gcloud auth application-default login   (sign in as a project owner)
//   2) cd functions
//   3) node seed.cjs
//
// Uses the same admin Data Connect API as the Cloud Functions, so it bypasses
// @auth and runs the SeedSkills mutation against production Cloud SQL.
const { readFileSync } = require("node:fs");
const path = require("node:path");
const { initializeApp } = require("firebase-admin/app");
const { getDataConnect } = require("firebase-admin/data-connect");

async function main() {
  initializeApp({ projectId: "skillx-9a717" });
  const dc = getDataConnect({ serviceId: "skillx", location: "us-central1" });

  const mutation = readFileSync(
    path.join(__dirname, "..", "dataconnect", "seed_skills.gql"),
    "utf8",
  );

  const res = await dc.executeGraphql(mutation);
  console.log("✅ Seeded catalogue:", JSON.stringify(res.data));
}

main().catch((err) => {
  console.error("❌ Seed failed:", err.message || err);
  process.exit(1);
});

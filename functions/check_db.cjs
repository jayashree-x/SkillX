const { initializeApp } = require("firebase-admin/app");
const { getDataConnect } = require("firebase-admin/data-connect");
initializeApp({ projectId: "skillx-9a717" });
const dc = getDataConnect({ serviceId: "skillx", location: "us-central1" });
dc.executeGraphqlRead(
  `query {
     users(limit: 30) { uid name email }
     userSkills(where: { relation: { eq: TEACH } }, limit: 30) {
       skill { name } user { name }
     }
   }`
).then((r) => {
  const d = r.data;
  console.log("USERS:", d.users.length);
  d.users.forEach((u) => console.log("  -", u.name, u.email, u.uid));
  console.log("TEACH offerings:", d.userSkills.length);
  d.userSkills.forEach((s) => console.log("  -", s.user.name, "teaches", s.skill.name));
}).catch((e) => { console.error("ERR:", e.message); process.exit(1); });

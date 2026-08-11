// ===========================================================================
// Data Connect surface. This file and skills_repository.dart are the only two
// that import the generated SDK (app/lib/generated/dataconnect). Regenerate
// with `firebase dataconnect:sdk:generate` after changing the .gql operations.
// ===========================================================================
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../../skills/domain/skill_option.dart';
import '../../skills/domain/skill_relation.dart';

/// One skill attached to the current user, with its relation (HAVE/TEACH/LEARN).
class UserSkill {
  const UserSkill({required this.relation, required this.skill});
  final SkillRelation relation;
  final SkillOption skill;
}

/// Reads/writes the signed-in user's Postgres row + skills via Data Connect.
/// Uses the operations in dataconnect/connector/{mutations,queries}.gql.
class ProfileRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  /// UpsertCurrentUser — creates the user row on first email signup or first
  /// Google login (idempotent). `uid` and `authProvider` are injected
  /// server-side from the auth token.
  Future<void> upsertCurrentUser({
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    final builder = _connector.upsertCurrentUser(name: name, email: email);
    if (photoUrl != null) builder.photoUrl(photoUrl);
    await builder.execute();
  }

  /// AddMySkill — attaches a catalogue skill under a relation (REG-05/06).
  Future<void> addSkill({
    required String skillId,
    required SkillRelation relation,
    String? proficiency,
  }) async {
    final builder =
        _connector.addMySkill(skillId: skillId, relation: _toDc(relation));
    if (proficiency != null) builder.proficiency(proficiency);
    await builder.execute();
  }

  /// SetMyFcmToken — stores the device push token (Module 13).
  Future<void> setFcmToken(String token) async {
    await _connector.setMyFcmToken(token: token).execute();
  }

  /// RemoveMySkill — detaches a skill under a relation (profile editing, PROF-02/03/04).
  Future<void> removeSkill({
    required String skillId,
    required SkillRelation relation,
  }) async {
    await _connector
        .removeMySkill(skillId: skillId, relation: _toDc(relation))
        .execute();
  }

  /// GetMySkills — the current user's skill list.
  Future<List<UserSkill>> getMySkills() async {
    final res = await _connector.getMySkills().execute();
    return res.data.userSkills
        .map(
          (r) => UserSkill(
            relation: _fromDc(r.relation.stringValue),
            skill: SkillOption(
              id: r.skill.id,
              name: r.skill.name,
              category: r.skill.category,
            ),
          ),
        )
        .toList();
  }

  /// Profile is "complete" once the user has ≥1 teachable and ≥1 learnable
  /// skill — the gate before the app shell (REG-05/06, Google onboarding).
  Future<bool> hasMinimumSkills() async {
    final skills = await getMySkills();
    final canTeach = skills.any((s) => s.relation == SkillRelation.teach);
    final wantsLearn = skills.any((s) => s.relation == SkillRelation.learn);
    return canTeach && wantsLearn;
  }

  dc.SkillRelation _toDc(SkillRelation r) => switch (r) {
        SkillRelation.have => dc.SkillRelation.HAVE,
        SkillRelation.teach => dc.SkillRelation.TEACH,
        SkillRelation.learn => dc.SkillRelation.LEARN,
      };

  SkillRelation _fromDc(String gqlName) => switch (gqlName.toUpperCase()) {
        'TEACH' => SkillRelation.teach,
        'LEARN' => SkillRelation.learn,
        _ => SkillRelation.have,
      };
}

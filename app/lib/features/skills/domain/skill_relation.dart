/// How a user relates to a skill (maps to the Data Connect `SkillRelation` enum:
/// HAVE / TEACH / LEARN). TRUST-01 keeps "have" separate from "teach".
enum SkillRelation {
  have,
  teach,
  learn;

  /// Matches the enum value name in the generated SDK / GraphQL schema.
  String get gqlName => switch (this) {
        SkillRelation.have => 'HAVE',
        SkillRelation.teach => 'TEACH',
        SkillRelation.learn => 'LEARN',
      };
}

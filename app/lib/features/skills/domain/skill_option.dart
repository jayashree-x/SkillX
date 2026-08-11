/// A selectable skill from the shared catalogue (Data Connect `Skill` row).
/// Plain model so the UI never depends on the generated Data Connect types.
class SkillOption {
  const SkillOption({
    required this.id,
    required this.name,
    required this.category,
  });

  final String id; // Skill.id (UUID)
  final String name;
  final String category;

  @override
  bool operator ==(Object other) =>
      other is SkillOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

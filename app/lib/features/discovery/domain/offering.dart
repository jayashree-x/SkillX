/// A teachable offering shown in Home browse / search and skill detail: a
/// skill paired with the teacher who offers it, plus trust signals (TRUST-02/03).
class Offering {
  const Offering({
    required this.skillId,
    required this.skillName,
    required this.category,
    required this.teacherUid,
    required this.teacherName,
    required this.teacherRating,
    required this.teacherSessions,
    this.description,
    this.teacherPhotoUrl,
    this.proficiency,
  });

  final String skillId;
  final String skillName;
  final String category;
  final String? description;

  final String teacherUid;
  final String teacherName;
  final String? teacherPhotoUrl;
  final double teacherRating;
  final int teacherSessions;
  final String? proficiency;

  /// TRUST-03: a teacher with no completed sessions is labelled "New teacher".
  bool get isNewTeacher => teacherSessions == 0;
}

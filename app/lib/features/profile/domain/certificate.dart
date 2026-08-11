/// A certificate earned on completing a full learning path (PROF-07 / CERT-*).
class Certificate {
  const Certificate({
    required this.id,
    required this.skillName,
    required this.teacherName,
    required this.averageScore,
    required this.modulesCompleted,
    required this.issuedAt,
    this.pdfUrl,
  });

  final String id;
  final String skillName;
  final String teacherName;
  final double averageScore;
  final int modulesCompleted;
  final String? pdfUrl;
  final DateTime issuedAt;
}

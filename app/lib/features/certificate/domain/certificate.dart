/// A participation certificate issued on completing a learning path (Module 10).
class CertificateData {
  const CertificateData({
    required this.id,
    required this.userName,
    required this.skillName,
    required this.teacherName,
    required this.averageScore,
    required this.modulesCompleted,
    required this.issuedAt,
    this.pdfUrl,
  });

  final String id;
  final String userName;
  final String skillName;
  final String teacherName;
  final double averageScore;
  final int modulesCompleted;
  final DateTime issuedAt;
  final String? pdfUrl;

  factory CertificateData.fromJson(Map<String, dynamic> json) => CertificateData(
        id: json['certificateId'] as String,
        userName: json['userName'] as String,
        skillName: json['skillName'] as String,
        teacherName: json['teacherName'] as String,
        averageScore: (json['averageScore'] as num).toDouble(),
        modulesCompleted: json['modulesCompleted'] as int,
        issuedAt:
            DateTime.tryParse(json['issuedAt'] as String? ?? '') ?? DateTime.now(),
        pdfUrl: json['pdfUrl'] as String?,
      );

  CertificateData copyWith({String? pdfUrl}) => CertificateData(
        id: id,
        userName: userName,
        skillName: skillName,
        teacherName: teacherName,
        averageScore: averageScore,
        modulesCompleted: modulesCompleted,
        issuedAt: issuedAt,
        pdfUrl: pdfUrl ?? this.pdfUrl,
      );
}

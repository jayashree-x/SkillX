/// A pending skill request the signed-in user (as teacher) can accept or
/// reject (HOME-06).
class IncomingRequest {
  const IncomingRequest({
    required this.id,
    required this.learnerName,
    required this.skillName,
    required this.createdAt,
    this.learnerPhotoUrl,
    this.message,
    this.preferredDateTime,
  });

  final String id;
  final String learnerName;
  final String? learnerPhotoUrl;
  final String skillName;
  final String? message;
  final DateTime? preferredDateTime;
  final DateTime createdAt;
}

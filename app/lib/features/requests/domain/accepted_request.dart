/// An accepted request the teacher can now turn into a session via the
/// Pre-Session Form (Phase 5).
class AcceptedTeachingRequest {
  const AcceptedTeachingRequest({
    required this.id,
    required this.learnerUid,
    required this.learnerName,
    required this.skillName,
    this.learnerPhotoUrl,
  });

  final String id; // requestId
  final String learnerUid;
  final String learnerName;
  final String? learnerPhotoUrl;
  final String skillName;
}

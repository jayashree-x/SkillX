/// A confirmed session shown on the Home "Upcoming Sessions" card (HOME-09).
/// This is a view/join surface only — sessions are launched from chat (HOME-07b).
class UpcomingSession {
  const UpcomingSession({
    required this.id,
    required this.topic,
    required this.teacherName,
    required this.level,
    required this.durationHours,
    required this.status,
    this.teacherPhotoUrl,
    this.meetingLink,
    this.scheduledAt,
  });

  final String id;
  final String topic;
  final String teacherName;
  final String? teacherPhotoUrl;

  /// Raw enum name (BASIC / BEGINNER / INTERMEDIATE / ADVANCED).
  final String level;
  final int durationHours;

  /// Raw enum name (SCHEDULED / ONGOING / COMPLETED / CANCELLED).
  final String status;
  final String? meetingLink;
  final DateTime? scheduledAt;

  bool get canJoin => meetingLink != null && meetingLink!.isNotEmpty;
}

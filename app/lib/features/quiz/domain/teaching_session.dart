/// A session the signed-in user teaches — the entry point to the post-session
/// form + quiz generation (Phase 6).
class TeachingSession {
  const TeachingSession({
    required this.id,
    required this.topic,
    required this.level,
    required this.status,
    required this.plannedSubtopics,
    required this.coveredSubtopics,
  });

  final String id;
  final String topic;
  final String level; // enum name
  final String status; // SCHEDULED / ONGOING / COMPLETED / CANCELLED
  final List<String> plannedSubtopics;
  final List<String> coveredSubtopics;

  /// The quiz can still be generated when the session hasn't been wrapped up.
  bool get canRunQuiz => status == 'SCHEDULED' || status == 'ONGOING';
  bool get hasQuiz => status == 'COMPLETED';
}

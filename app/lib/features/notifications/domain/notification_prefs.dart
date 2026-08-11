/// Per-category push toggles + quiet hours (Module 8, NOTIF-03/04). Persisted
/// as JSON on User.notificationPrefs; the server reads it before each push.
class NotificationPrefs {
  const NotificationPrefs({
    this.requests = true,
    this.sessions = true,
    this.quizzes = true,
    this.rewards = true,
    this.teaching = true,
    this.quietStart,
    this.quietEnd,
    this.utcOffsetMinutes = 0,
  });

  final bool requests; // request accepted
  final bool sessions; // session confirmed
  final bool quizzes; // quiz released
  final bool rewards; // badges / streaks
  final bool teaching; // "learners waiting for your skill"

  final int? quietStart; // local hour 0–23, null = quiet hours off
  final int? quietEnd;
  final int utcOffsetMinutes; // device offset, so the server can apply the window

  bool get quietEnabled => quietStart != null && quietEnd != null;

  factory NotificationPrefs.fromMap(Map<dynamic, dynamic>? m) {
    if (m == null) return const NotificationPrefs();
    bool flag(String k) => m[k] is bool ? m[k] as bool : true;
    int? intOrNull(String k) => (m[k] as num?)?.toInt();
    return NotificationPrefs(
      requests: flag('requests'),
      sessions: flag('sessions'),
      quizzes: flag('quizzes'),
      rewards: flag('rewards'),
      teaching: flag('teaching'),
      quietStart: intOrNull('quietStart'),
      quietEnd: intOrNull('quietEnd'),
      utcOffsetMinutes: intOrNull('utcOffsetMinutes') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'requests': requests,
        'sessions': sessions,
        'quizzes': quizzes,
        'rewards': rewards,
        'teaching': teaching,
        'quietStart': quietStart,
        'quietEnd': quietEnd,
        'utcOffsetMinutes': utcOffsetMinutes,
      };
}

/// The graded result returned by the server (QUIZ-07/08).
class QuizResult {
  const QuizResult({
    required this.score,
    required this.total,
    required this.percentage,
    required this.badge,
    required this.correctIndexes,
    this.currentStreak,
  });

  final int score;
  final int total;
  final double percentage;
  final String badge; // gold | silver | bronze | none
  final List<int> correctIndexes;

  /// The learner's day-streak after this attempt (RWD-01); null if the server
  /// didn't update it.
  final int? currentStreak;
}

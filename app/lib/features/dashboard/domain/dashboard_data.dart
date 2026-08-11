import 'dart:math' as math;

/// One graded attempt, shaped for the dashboard charts + activity list.
class DashboardAttempt {
  const DashboardAttempt({
    required this.skillName,
    required this.percentage,
    required this.completedAt,
    this.badge,
  });

  final String skillName;
  final double percentage;
  final DateTime completedAt;
  final String? badge;
}

/// Everything the dashboard shows (Module 7), aggregated from attempt history
/// plus the user's streak.
class DashboardData {
  const DashboardData({
    required this.attempts,
    required this.currentStreak,
  });

  /// Newest first (query orders by completedAt DESC).
  final List<DashboardAttempt> attempts;
  final int currentStreak;

  bool get isEmpty => attempts.isEmpty;

  int get totalQuizzes => attempts.length;

  double get averageScore => attempts.isEmpty
      ? 0
      : attempts.map((a) => a.percentage).reduce((a, b) => a + b) /
          attempts.length;

  double get bestScore => attempts.isEmpty
      ? 0
      : attempts.map((a) => a.percentage).reduce(math.max);

  /// Last 10 scores in chronological order (oldest → newest) for the line chart.
  List<double> get recentScores {
    final recent = attempts.take(10).toList().reversed;
    return [for (final a in recent) a.percentage];
  }

  /// Average percentage per skill, highest first (bar chart). Capped at 6 bars.
  List<({String skill, double average})> get averageBySkill {
    final sums = <String, double>{};
    final counts = <String, int>{};
    for (final a in attempts) {
      sums[a.skillName] = (sums[a.skillName] ?? 0) + a.percentage;
      counts[a.skillName] = (counts[a.skillName] ?? 0) + 1;
    }
    final rows = [
      for (final skill in sums.keys)
        (skill: skill, average: sums[skill]! / counts[skill]!),
    ]..sort((a, b) => b.average.compareTo(a.average));
    return rows.take(6).toList();
  }
}

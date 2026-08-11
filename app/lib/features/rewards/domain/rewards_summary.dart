/// Aggregates everything the Rewards screen shows (Module 6): the streak
/// counters plus which badge tiers the learner has earned.
class RewardsSummary {
  const RewardsSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.earnedTiers,
    required this.totalQuizzes,
  });

  final int currentStreak;
  final int longestStreak;

  /// Lower-cased tiers the learner has earned at least once: gold/silver/bronze.
  final Set<String> earnedTiers;

  final int totalQuizzes;

  static const empty = RewardsSummary(
    currentStreak: 0,
    longestStreak: 0,
    earnedTiers: {},
    totalQuizzes: 0,
  );
}

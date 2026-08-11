import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/rewards_summary.dart';

/// Reads the streak counters (GetCurrentUser) and the badges earned across all
/// quiz attempts (GetMyAttempts) for the Rewards screen.
class RewardsRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<RewardsSummary> fetch() async {
    final userResult = await _connector.getCurrentUser().execute();
    final attemptsResult = await _connector.getMyAttempts(limit: 200).execute();

    final users = userResult.data.users;
    final user = users.isNotEmpty ? users.first : null;
    final attempts = attemptsResult.data.quizAttempts;

    const tiers = {'gold', 'silver', 'bronze'};
    final earned = attempts
        .map((a) => a.badgeEarned?.toLowerCase())
        .where((b) => b != null && tiers.contains(b))
        .cast<String>()
        .toSet();

    return RewardsSummary(
      currentStreak: user?.currentStreak ?? 0,
      longestStreak: user?.longestStreak ?? 0,
      earnedTiers: earned,
      totalQuizzes: attempts.length,
    );
  }
}

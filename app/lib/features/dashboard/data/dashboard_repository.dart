import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/dashboard_data.dart';

/// Reads attempt history (GetMyAttempts) + streak (GetCurrentUser) for the
/// dashboard. Charts are derived entirely from the immutable attempt rows.
class DashboardRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<DashboardData> fetch() async {
    final attemptsResult =
        await _connector.getMyAttempts(limit: 100).execute();
    final userResult = await _connector.getCurrentUser().execute();

    final attempts = attemptsResult.data.quizAttempts
        .map((a) => DashboardAttempt(
              skillName: a.skillName,
              percentage: a.percentage,
              completedAt: a.completedAt.toDateTime(),
              badge: a.badgeEarned,
            ))
        .toList();

    final users = userResult.data.users;
    final currentStreak = users.isNotEmpty ? users.first.currentStreak : 0;

    return DashboardData(attempts: attempts, currentStreak: currentStreak);
  }
}

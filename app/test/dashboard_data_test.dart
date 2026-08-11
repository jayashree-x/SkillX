import 'package:flutter_test/flutter_test.dart';
import 'package:skillx/features/dashboard/domain/dashboard_data.dart';

void main() {
  DashboardAttempt a(String skill, double pct, int daysAgo) => DashboardAttempt(
        skillName: skill,
        percentage: pct,
        completedAt: DateTime(2026, 1, 1).subtract(Duration(days: daysAgo)),
      );

  test('empty data reports zeros', () {
    const d = DashboardData(attempts: [], currentStreak: 0);
    expect(d.isEmpty, isTrue);
    expect(d.averageScore, 0);
    expect(d.bestScore, 0);
    expect(d.recentScores, isEmpty);
  });

  test('average and best score', () {
    final d = DashboardData(
      attempts: [a('Py', 80, 0), a('Py', 60, 1), a('JS', 40, 2)],
      currentStreak: 3,
    );
    expect(d.totalQuizzes, 3);
    expect(d.averageScore, closeTo(60, 1e-9));
    expect(d.bestScore, 80);
  });

  test('recentScores = last 10 in chronological order', () {
    // attempts are newest-first (index 0 = newest, pct 0).
    final attempts = [for (var i = 0; i < 12; i++) a('S', i.toDouble(), i)];
    final d = DashboardData(attempts: attempts, currentStreak: 0);
    expect(d.recentScores.length, 10);
    expect(d.recentScores.first, 9); // oldest of the recent 10
    expect(d.recentScores.last, 0); // newest
  });

  test('averageBySkill is sorted high-to-low', () {
    final d = DashboardData(
      attempts: [a('A', 100, 0), a('A', 50, 1), a('B', 90, 2)],
      currentStreak: 0,
    );
    final rows = d.averageBySkill;
    expect(rows.first.skill, 'B'); // 90 > A's 75
    expect(rows.first.average, closeTo(90, 1e-9));
    expect(rows[1].skill, 'A');
    expect(rows[1].average, closeTo(75, 1e-9));
  });
}

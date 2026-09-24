import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/rewards_providers.dart';
import '../domain/rewards_summary.dart';

/// Module 6 — Rewards: current/longest streak (RWD-10) and a badge grid with
/// earned badges highlighted and unearned ones greyed (RWD-09). Tapping a badge
/// explains how it's earned (RWD-11).
class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rewardsSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load rewards.')),
        data: (summary) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(rewardsSummaryProvider),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StreakCard(
                      icon: Icons.local_fire_department,
                      color: AppColors.reward,
                      value: summary.currentStreak,
                      label: 'Current streak',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StreakCard(
                      icon: Icons.emoji_events,
                      color: AppColors.gold,
                      value: summary.longestStreak,
                      label: 'Longest streak',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Badges',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
                children: [
                  for (final badge in _badges(summary))
                    _BadgeTile(
                      badge: badge,
                      onTap: () => _showBadge(context, badge),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Text(
                  '${summary.totalQuizzes} quizzes completed',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_Badge> _badges(RewardsSummary s) => [
        _Badge(
          label: 'Bronze',
          icon: Icons.workspace_premium,
          color: AppColors.bronze,
          earned: s.earnedTiers.contains('bronze'),
          how: 'Score 40% or higher on a quiz.',
        ),
        _Badge(
          label: 'Silver',
          icon: Icons.workspace_premium,
          color: AppColors.silver,
          earned: s.earnedTiers.contains('silver'),
          how: 'Score 60% or higher on a quiz.',
        ),
        _Badge(
          label: 'Gold',
          icon: Icons.workspace_premium,
          color: AppColors.gold,
          earned: s.earnedTiers.contains('gold'),
          how: 'Score 80% or higher on a quiz.',
        ),
        _Badge(
          label: '7-day',
          icon: Icons.local_fire_department,
          color: AppColors.reward,
          earned: s.longestStreak >= 7,
          how: 'Stay active 7 days in a row.',
        ),
        _Badge(
          label: '30-day',
          icon: Icons.local_fire_department,
          color: AppColors.primary,
          earned: s.longestStreak >= 30,
          how: 'Stay active 30 days in a row.',
        ),
        _Badge(
          label: '100-day',
          icon: Icons.local_fire_department,
          color: AppColors.teal,
          earned: s.longestStreak >= 100,
          how: 'Stay active 100 days in a row.',
        ),
      ];

  void _showBadge(BuildContext context, _Badge badge) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          badge.icon,
          size: 40,
          color: badge.earned ? badge.color : AppColors.textTertiary,
        ),
        title: Text('${badge.label} badge'),
        content: Text(
          badge.earned ? 'Earned! ${badge.how}' : 'Not yet earned. ${badge.how}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Badge {
  const _Badge({
    required this.label,
    required this.icon,
    required this.color,
    required this.earned,
    required this.how,
  });
  final String label;
  final IconData icon;
  final Color color;
  final bool earned;
  final String how;
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.onTap});

  final _Badge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = badge.earned ? badge.color : AppColors.textTertiary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: badge.earned ? 1 : 0.35,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(badge.icon, size: 26, color: color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: badge.earned
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
            if (!badge.earned)
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.lock_outline,
                    size: 12, color: AppColors.textTertiary),
              ),
          ],
        ),
      ),
    );
  }
}

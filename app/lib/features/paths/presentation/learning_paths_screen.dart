import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/paths_providers.dart';

/// Module 11 (reworked) - "Skills in progress": the skills the learner is
/// actively building, derived from their quiz attempts. Each skill shows the
/// subtopics the teacher covered, with a green tick once that topic is passed.
class LearningPathsScreen extends ConsumerWidget {
  const LearningPathsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(skillProgressProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My learning')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Could not load your progress.')),
        data: (skills) {
          if (skills.isEmpty) return const _EmptyProgress();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(skillProgressProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screen),
              itemCount: skills.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _SkillProgressCard(data: skills[i]),
            ),
          );
        },
      ),
    );
  }
}

class _SkillProgressCard extends StatelessWidget {
  const _SkillProgressCard({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final skill = data['skill'] as String? ?? 'Skill';
    final best = (data['bestPercentage'] as num?)?.toInt() ?? 0;
    final passed = data['passed'] as bool? ?? false;
    final attempts = (data['attempts'] as num?)?.toInt() ?? 0;
    final topics = ((data['topics'] as List?) ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
              ),
              if (passed)
                const Icon(Icons.check_circle,
                    size: 22, color: AppColors.success)
              else
                Text('Best $best%',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$attempts quiz attempt${attempts == 1 ? '' : 's'}'
            '${passed ? ' - passed' : ''}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          if (topics.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Topics covered',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...topics.map((t) {
              final done = t['done'] as bool? ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      done
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 18,
                      color: done ? AppColors.success : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t['name'] as String? ?? '',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: done
                                ? AppColors.textPrimary
                                : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _EmptyProgress extends StatelessWidget {
  const _EmptyProgress();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_up_rounded,
                size: 40, color: AppColors.textTertiary),
            SizedBox(height: 12),
            Text('No learning activity yet.',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text(
              'Take a session and complete its quiz to start\n'
              'building your skill progress.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

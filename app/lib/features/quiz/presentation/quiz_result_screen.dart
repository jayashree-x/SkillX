import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../rewards/application/rewards_providers.dart';
import '../application/quiz_providers.dart';
import '../domain/learner_quiz.dart';
import '../domain/quiz_result.dart';

class QuizResultArgs {
  const QuizResultArgs({
    required this.result,
    required this.quiz,
    required this.answers,
  });
  final QuizResult result;
  final LearnerQuiz quiz;
  final List<int?> answers;
}

/// Result + review (QUIZ-07/08/10): score, badge, and the correct answers
/// revealed for each question.
class QuizResultScreen extends ConsumerWidget {
  const QuizResultScreen({super.key, required this.args});

  final QuizResultArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = args.result;
    final (badgeColor, badgeLabel) = _badge(r.badge);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Result')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Text(
                  '${r.score}/${r.total}',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${r.percentage.round()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium, size: 18, color: badgeColor),
                      const SizedBox(width: 6),
                      Text(
                        badgeLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (r.currentStreak != null && r.currentStreak! > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department,
                          size: 18, color: AppColors.reward),
                      const SizedBox(width: 6),
                      Text(
                        '${r.currentStreak}-day streak',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.reward,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < args.quiz.questions.length; i++)
            _ReviewCard(
              index: i,
              question: args.quiz.questions[i],
              chosen: args.answers[i],
              correct: i < r.correctIndexes.length ? r.correctIndexes[i] : -1,
            ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ref
                  ..invalidate(myQuizzesProvider)
                  ..invalidate(rewardsSummaryProvider);
                context.pop();
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _badge(String badge) => switch (badge) {
        'gold' => (AppColors.gold, 'Gold'),
        'silver' => (AppColors.silver, 'Silver'),
        'bronze' => (AppColors.bronze, 'Bronze'),
        _ => (AppColors.textTertiary, 'Keep practising'),
      };
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.index,
    required this.question,
    required this.chosen,
    required this.correct,
  });

  final int index;
  final LearnerQuestion question;
  final int? chosen;
  final int correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${question.questionText}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          for (var o = 0; o < question.options.length; o++)
            _reviewOption(o),
        ],
      ),
    );
  }

  Widget _reviewOption(int o) {
    final isCorrect = o == correct;
    final isWrongChoice = o == chosen && chosen != correct;
    final color = isCorrect
        ? AppColors.success
        : isWrongChoice
            ? AppColors.error
            : AppColors.border;
    final icon = isCorrect
        ? Icons.check_circle
        : isWrongChoice
            ? Icons.cancel
            : Icons.circle_outlined;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question.options[o],
              style: TextStyle(
                fontSize: 13.5,
                color: isCorrect || isWrongChoice
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight:
                    isCorrect ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

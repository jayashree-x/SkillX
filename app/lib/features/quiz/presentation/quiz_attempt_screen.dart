import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/quiz_providers.dart';
import '../domain/learner_quiz.dart';
import 'quiz_result_screen.dart';

/// Learner attempt (QUIZ-05/06): one question at a time with a progress bar and
/// back navigation. Grading is server-side; streak never shown here (QUIZ-09).
class QuizAttemptScreen extends ConsumerStatefulWidget {
  const QuizAttemptScreen({super.key, required this.quizId});

  final String quizId;

  @override
  ConsumerState<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends ConsumerState<QuizAttemptScreen> {
  int _index = 0;
  List<int?> _answers = const [];
  bool _seeded = false;
  bool _busy = false;

  Future<void> _submit(LearnerQuiz quiz) async {
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final localDate = '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      final result = await ref.read(quizFunctionsRepositoryProvider).gradeQuiz(
            quizId: quiz.id,
            answers: [for (final a in _answers) a ?? -1],
            localDate: localDate,
          );
      if (!mounted) return;
      context.pushReplacement(
        '/quiz-result',
        extra: QuizResultArgs(result: result, quiz: quiz, answers: _answers),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not submit. Try again.')),
        );
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(learnerQuizProvider(widget.quizId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(), // QUIZ-04: skipping is allowed
        ),
        title: const Text('Quiz'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load the quiz.')),
        data: (quiz) {
          if (quiz == null || quiz.questions.isEmpty) {
            return const Center(child: Text('This quiz is not available.'));
          }
          if (!_seeded) {
            _answers = List<int?>.filled(quiz.questions.length, null);
            _seeded = true;
          }
          return _buildQuestion(quiz);
        },
      ),
    );
  }

  Widget _buildQuestion(LearnerQuiz quiz) {
    final total = quiz.questions.length;
    final q = quiz.questions[_index];
    final isLast = _index == total - 1;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${_index + 1} of $total',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (_index + 1) / total,
              minHeight: 8,
              backgroundColor: AppColors.fill,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            q.questionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          for (var o = 0; o < q.options.length; o++)
            _AnswerOption(
              letter: String.fromCharCode(65 + o),
              label: q.options[o],
              selected: _answers[_index] == o,
              onTap: () => setState(() => _answers[_index] = o),
            ),
          const Spacer(),
          Row(
            children: [
              if (_index > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _index--),
                    child: const Text('Back'),
                  ),
                ),
              if (_index > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _busy
                        ? null
                        : isLast
                            ? () => _submit(quiz)
                            : () => setState(() => _index++),
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.4, color: Colors.white),
                          )
                        : Text(isLast ? 'Submit' : 'Next'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.letter,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String letter;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.blueTint : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.borderStrong,
                  width: 1.5,
                ),
              ),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

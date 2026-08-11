import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/quiz_providers.dart';
import '../domain/quiz_draft.dart';

class QuizApprovalArgs {
  const QuizApprovalArgs({required this.quizId, required this.questions});
  final String quizId;
  final List<DraftQuestion> questions;
}

/// Teacher approval (QUIZ-13/18): review the generated questions, optionally
/// edit the wording or correct answer, then release to learners.
class QuizApprovalScreen extends ConsumerStatefulWidget {
  const QuizApprovalScreen({super.key, required this.args});

  final QuizApprovalArgs args;

  @override
  ConsumerState<QuizApprovalScreen> createState() => _QuizApprovalScreenState();
}

class _QuizApprovalScreenState extends ConsumerState<QuizApprovalScreen> {
  late final List<TextEditingController> _controllers = widget.args.questions
      .map((q) => TextEditingController(text: q.questionText))
      .toList();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _busy = true);
    for (var i = 0; i < widget.args.questions.length; i++) {
      widget.args.questions[i].questionText = _controllers[i].text.trim();
    }
    try {
      await ref.read(quizFunctionsRepositoryProvider).approveQuiz(
            quizId: widget.args.quizId,
            questions: widget.args.questions,
          );
      if (!mounted) return;
      ref.invalidate(myTeachingSessionsProvider);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz released to learners.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not release the quiz. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.args.questions;
    return Scaffold(
      appBar: AppBar(title: const Text('Review quiz')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          const Text(
            'Tap an option to set the correct answer. Edit the wording if needed.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < questions.length; i++) ...[
            Container(
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
                    'Question ${i + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _controllers[i],
                    maxLines: null,
                    decoration: const InputDecoration(isDense: true),
                  ),
                  const SizedBox(height: 10),
                  for (var o = 0; o < questions[i].options.length; o++)
                    _OptionRow(
                      label: questions[i].options[o],
                      correct: questions[i].correctIndex == o,
                      onTap: () => setState(() => questions[i].correctIndex = o),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _busy ? null : _approve,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white),
                    )
                  : const Text('Approve & Release Quiz'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: correct ? const Color(0xFFF0FDF4) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: correct ? AppColors.success : AppColors.border,
            width: correct ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              correct ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: correct ? AppColors.success : AppColors.textTertiary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: correct ? FontWeight.w600 : FontWeight.w400,
                  color: correct
                      ? const Color(0xFF166534)
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/quiz_providers.dart';
import '../domain/teaching_session.dart';
import 'quiz_approval_screen.dart';

/// Post-Session wrap-up: ask whether anything was taught; if yes, collect the
/// topics covered and generate a 10-question quiz from them.
class PostSessionFormScreen extends ConsumerStatefulWidget {
  const PostSessionFormScreen({super.key, required this.session});

  final TeachingSession session;

  @override
  ConsumerState<PostSessionFormScreen> createState() =>
      _PostSessionFormScreenState();
}

class _PostSessionFormScreenState extends ConsumerState<PostSessionFormScreen> {
  final _topics = TextEditingController();
  bool _taught = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _topics.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _topics.dispose();
    super.dispose();
  }

  List<String> get _parsedTopics => _topics.text
      .split(RegExp(r'[,\n]'))
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  bool get _canGenerate => _taught && _parsedTopics.isNotEmpty;

  Future<void> _generate() async {
    final topics = _parsedTopics;
    if (topics.isEmpty) return;
    setState(() => _busy = true);
    try {
      final result = await ref.read(quizFunctionsRepositoryProvider).generateQuiz(
            sessionId: widget.session.id,
            coveredSubtopics: topics,
          );
      if (!mounted) return;
      context.pushReplacement(
        '/quiz-approval',
        extra: QuizApprovalArgs(
          quizId: result.quizId,
          questions: result.questions,
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not generate the quiz. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wrap up session')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Text(
            widget.session.topic,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SwitchListTile(
                value: _taught,
                onChanged: (v) => setState(() => _taught = v),
                title: const Text(
                  'Did you teach anything to the learner?',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Turn on to create a quiz on what you covered.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textTertiary),
                ),
                activeThumbColor: AppColors.primary,
              ),
            ),
          ),

          if (_taught) ...[
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'What topics did you cover?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topics,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText:
                    'e.g.\nVariables and data types\nFor and while loops\nFunctions',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'One topic per line, or comma-separated.',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Generate Quiz',
              loading: _busy,
              onPressed: _canGenerate ? _generate : null,
            ),
            const SizedBox(height: 8),
            const Text(
              'AI drafts 10 questions from these topics; you review and release '
              'them next.',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}

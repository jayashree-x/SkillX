import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/quiz_providers.dart';
import '../domain/teaching_session.dart';
import 'quiz_approval_screen.dart';

/// Post-Session Form (5.1, POST-01..05): confirm which planned subtopics were
/// actually covered, then generate the quiz from only those.
class PostSessionFormScreen extends ConsumerStatefulWidget {
  const PostSessionFormScreen({super.key, required this.session});

  final TeachingSession session;

  @override
  ConsumerState<PostSessionFormScreen> createState() =>
      _PostSessionFormScreenState();
}

class _PostSessionFormScreenState extends ConsumerState<PostSessionFormScreen> {
  late final List<String> _subtopics = [...widget.session.plannedSubtopics];
  late final Set<String> _covered = {...widget.session.plannedSubtopics};
  final _extra = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _extra.dispose();
    super.dispose();
  }

  void _addExtra(String raw) {
    final value = raw.trim();
    if (value.isEmpty || _subtopics.contains(value)) {
      _extra.clear();
      return;
    }
    setState(() {
      _subtopics.add(value);
      _covered.add(value);
      _extra.clear();
    });
  }

  Future<void> _generate() async {
    if (_covered.isEmpty) return; // POST-04
    setState(() => _busy = true);
    try {
      final result = await ref.read(quizFunctionsRepositoryProvider).generateQuiz(
            sessionId: widget.session.id,
            coveredSubtopics: _covered.toList(),
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
          const Text(
            'Which subtopics did you cover?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Only ticked subtopics will be tested (POST-05).',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final s in _subtopics)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: _covered.contains(s),
                onChanged: (v) => setState(
                  () => v == true ? _covered.add(s) : _covered.remove(s),
                ),
                title: Text(s),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primary,
              ),
            ),
          const SizedBox(height: 4),
          TextField(
            controller: _extra,
            textInputAction: TextInputAction.done,
            onSubmitted: _addExtra,
            decoration: InputDecoration(
              hintText: 'Add a subtopic you covered…',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addExtra(_extra.text),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Generate Quiz',
            loading: _busy,
            onPressed: _covered.isEmpty ? null : _generate,
          ),
          const SizedBox(height: 8),
          const Text(
            'Claude drafts 5 questions from the covered subtopics; you review and '
            'release them next.',
            style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

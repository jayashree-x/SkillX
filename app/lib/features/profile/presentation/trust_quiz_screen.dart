import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/data/profile_repository.dart' show UserSkill;
import '../../requests/application/requests_controller.dart';
import '../../skills/domain/skill_relation.dart';
import '../application/profile_providers.dart';

/// TRUST badge (optional "Upgrade profile"): a teacher picks a skill they teach,
/// takes an AI quiz, and on >= 80% earns a per-skill Trusted badge. Grading and
/// the answer key stay on the server (startTrustQuiz / submitTrustQuiz).
class TrustQuizScreen extends ConsumerStatefulWidget {
  const TrustQuizScreen({super.key});

  @override
  ConsumerState<TrustQuizScreen> createState() => _TrustQuizScreenState();
}

class _TrustQuizScreenState extends ConsumerState<TrustQuizScreen> {
  String? _skillId;
  String _skillName = '';
  List<Map<String, dynamic>> _questions = const [];
  List<int?> _answers = [];
  bool _loading = false;
  Map<String, dynamic>? _result;

  Future<void> _start(String skillId, String name) async {
    setState(() {
      _loading = true;
      _skillId = skillId;
      _skillName = name;
    });
    try {
      final data =
          await ref.read(functionsRepositoryProvider).startTrustQuiz(skillId);
      final qs = (((data['questions'] as List?) ?? const []))
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList();
      setState(() {
        _questions = qs;
        _answers = List<int?>.filled(qs.length, null);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not start the quiz. $e')));
      }
    }
  }

  Future<void> _submit() async {
    if (_answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please answer every question first.')));
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ref
          .read(functionsRepositoryProvider)
          .submitTrustQuiz(_skillId!, _answers.cast<int>());
      if (!mounted) return;
      setState(() {
        _result = res;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not submit. $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _result != null
              ? _ResultView(
                  result: _result!,
                  skillName: _skillName,
                  onDone: () => Navigator.of(context).pop(),
                )
              : _questions.isEmpty
                  ? _SkillPicker(onPick: _start)
                  : _QuizView(
                      skillName: _skillName,
                      questions: _questions,
                      answers: _answers,
                      onChanged: (i, v) => setState(() => _answers[i] = v),
                      onSubmit: _submit,
                    ),
    );
  }
}

class _SkillPicker extends ConsumerWidget {
  const _SkillPicker({required this.onPick});
  final void Function(String skillId, String name) onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(myProfileSkillsProvider).valueOrNull ??
        const <UserSkill>[];
    final teach =
        skills.where((s) => s.relation == SkillRelation.teach).toList();

    if (teach.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Add a skill you teach first, then come back to earn a\n'
            'Trusted badge for it.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        const Text('Earn a Trusted badge',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text(
          'Pick a skill you teach and pass a short quiz (80%+). The badge shows '
          'on your offerings so learners can trust your expertise.',
          style: TextStyle(fontSize: 13.5, height: 1.5, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final s in teach)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              title: Text(s.skill.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              subtitle: Text(s.skill.category,
                  style: const TextStyle(color: AppColors.textSecondary)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              onTap: () => onPick(s.skill.id, s.skill.name),
            ),
          ),
      ],
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView({
    required this.skillName,
    required this.questions,
    required this.answers,
    required this.onChanged,
    required this.onSubmit,
  });

  final String skillName;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;
  final void Function(int index, int value) onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Text('Trusted quiz: $skillName',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('Score 80% or more to earn the badge.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        for (int q = 0; q < questions.length; q++)
          _QuestionCard(
            index: q,
            question: questions[q],
            selected: answers[q],
            onChanged: (v) => onChanged(q, v),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text('Submit quiz'),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selected,
    required this.onChanged,
  });

  final int index;
  final Map<String, dynamic> question;
  final int? selected;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final options =
        ((question['options'] as List?) ?? const []).cast<dynamic>();
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
          Text('${index + 1}. ${question['questionText'] ?? ''}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          for (int i = 0; i < options.length; i++)
            InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      selected == i
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 20,
                      color: selected == i
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${options[i]}',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textPrimary)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.result,
    required this.skillName,
    required this.onDone,
  });

  final Map<String, dynamic> result;
  final String skillName;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final passed = result['passed'] as bool? ?? false;
    final pct = (result['percentage'] as num?)?.toInt() ?? 0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(passed ? Icons.verified_rounded : Icons.sentiment_neutral_rounded,
                size: 64,
                color: passed ? AppColors.teal : AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              passed ? "You're now Trusted in $skillName!" : 'Not quite yet',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              passed
                  ? 'You scored $pct%. The Trusted badge now shows on your '
                      '$skillName offerings.'
                  : 'You scored $pct%. You need 80% to earn the badge — '
                      'review the topic and try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, height: 1.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onDone, child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}

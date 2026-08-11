import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../application/requests_controller.dart';
import '../domain/accepted_request.dart';

enum _Level {
  basic('Basic'),
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const _Level(this.label);
  final String label;
  String get gql => name.toUpperCase();
}

/// Pre-Session Form (3.3.1, PRE-01..09): topic, subtopics, level, duration.
/// On submit the createSession Cloud Function creates a Google Calendar event
/// with a Meet link and invites both people — the teacher no longer pastes a
/// link. Submit unlocks once every question is answered (HOME-07a).
class PreSessionFormScreen extends ConsumerStatefulWidget {
  const PreSessionFormScreen({super.key, required this.request});

  final AcceptedTeachingRequest request;

  @override
  ConsumerState<PreSessionFormScreen> createState() =>
      _PreSessionFormScreenState();
}

class _PreSessionFormScreenState extends ConsumerState<PreSessionFormScreen> {
  final _topic = TextEditingController();
  final _tags = <String>[];
  final _subtopics = <String>[];
  _Level? _level;
  int? _duration;

  @override
  void initState() {
    super.initState();
    _topic.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  bool get _formComplete =>
      _topic.text.trim().length >= 3 &&
      _tags.isNotEmpty &&
      _subtopics.isNotEmpty &&
      _level != null &&
      _duration != null;

  Future<void> _submit() async {
    final ok = await ref.read(requestsControllerProvider.notifier).createSession(
          requestId: widget.request.id,
          learnerUids: [widget.request.learnerUid],
          topic: _topic.text.trim(),
          topicTags: _tags,
          plannedSubtopics: _subtopics,
          level: _level!.gql,
          durationHours: _duration!,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session created — a Meet invite was sent to the learner.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create the session. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(requestsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Set up session')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Text(
            'Session details',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Teaching ${widget.request.learnerName} · ${widget.request.skillName}',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          _label('Topic / subject'),
          TextField(
            controller: _topic,
            decoration: const InputDecoration(hintText: 'e.g. Intro to Python'),
          ),
          const SizedBox(height: AppSpacing.md),

          _label('Topic tags'),
          _ChipInput(
            hint: 'Add a tag…',
            values: _tags,
            variant: SkillChipVariant.teach,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),

          _label('Planned subtopics'),
          _ChipInput(
            hint: 'e.g. variables, loops…',
            values: _subtopics,
            variant: SkillChipVariant.learn,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),

          _label('Level'),
          Wrap(
            spacing: 8,
            children: [
              for (final l in _Level.values)
                ChoiceChip(
                  label: Text(l.label),
                  selected: _level == l,
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    color: _level == l ? Colors.white : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: _level == l ? AppColors.primary : AppColors.borderStrong,
                  ),
                  onSelected: (_) => setState(() => _level = l),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          _label('Duration'),
          Row(
            children: [
              for (final h in const [1, 2, 3]) ...[
                Expanded(
                  child: _DurationChip(
                    hours: h,
                    selected: _duration == h,
                    onTap: () => setState(() => _duration = h),
                  ),
                ),
                if (h != 3) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.blueTint,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: const Row(
              children: [
                Icon(Icons.videocam_outlined, size: 20, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'A Google Meet link is created automatically and a calendar '
                    'invite is emailed to you and the learner.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            label: 'Create session',
            loading: busy,
            onPressed: _formComplete ? _submit : null,
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.hours,
    required this.selected,
    required this.onTap,
  });

  final int hours;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.blueTint : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Text(
          '${hours}h',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// A text field that turns entries into removable chips on submit.
class _ChipInput extends StatefulWidget {
  const _ChipInput({
    required this.hint,
    required this.values,
    required this.variant,
    required this.onChanged,
  });

  final String hint;
  final List<String> values;
  final SkillChipVariant variant;
  final VoidCallback onChanged;

  @override
  State<_ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<_ChipInput> {
  final _controller = TextEditingController();

  void _add(String raw) {
    final value = raw.trim();
    if (value.isEmpty || widget.values.contains(value)) {
      _controller.clear();
      return;
    }
    setState(() {
      widget.values.add(value);
      _controller.clear();
    });
    widget.onChanged();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.values.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in widget.values)
                SkillChip(
                  label: v,
                  variant: widget.variant,
                  onRemove: () {
                    setState(() => widget.values.remove(v));
                    widget.onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onSubmitted: _add,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => _add(_controller.text),
            ),
          ),
        ),
      ],
    );
  }
}

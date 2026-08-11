import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/notification_providers.dart';
import '../domain/notification_prefs.dart';

/// Module 8 — notification settings: per-category toggles + quiet hours.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Could not load notification settings.')),
        data: (prefs) => _Form(initial: prefs),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.initial});
  final NotificationPrefs initial;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late bool _requests = widget.initial.requests;
  late bool _sessions = widget.initial.sessions;
  late bool _quizzes = widget.initial.quizzes;
  late bool _rewards = widget.initial.rewards;
  late bool _teaching = widget.initial.teaching;
  late bool _quiet = widget.initial.quietEnabled;
  late int _quietStart = widget.initial.quietStart ?? 22;
  late int _quietEnd = widget.initial.quietEnd ?? 7;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = NotificationPrefs(
      requests: _requests,
      sessions: _sessions,
      quizzes: _quizzes,
      rewards: _rewards,
      teaching: _teaching,
      quietStart: _quiet ? _quietStart : null,
      quietEnd: _quiet ? _quietEnd : null,
      utcOffsetMinutes: DateTime.now().timeZoneOffset.inMinutes,
    );
    try {
      await ref.read(notificationPrefsRepositoryProvider).save(prefs);
      ref.invalidate(notificationPrefsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification settings saved.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        const _SectionLabel('Push notifications'),
        _toggle('Request updates', 'When a teacher accepts your request', _requests,
            (v) => setState(() => _requests = v)),
        _toggle('Sessions', 'Confirmations and reminders', _sessions,
            (v) => setState(() => _sessions = v)),
        _toggle('Quizzes', 'When a quiz is released to you', _quizzes,
            (v) => setState(() => _quizzes = v)),
        _toggle('Rewards', 'Badges and streak milestones', _rewards,
            (v) => setState(() => _rewards = v)),
        _toggle('Teaching opportunities', 'Learners waiting for a skill you teach',
            _teaching, (v) => setState(() => _teaching = v)),

        const SizedBox(height: 8),
        const _SectionLabel('Quiet hours'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Silence notifications overnight'),
          subtitle: Text(_quiet
              ? 'No pushes from ${_fmtHour(_quietStart)} to ${_fmtHour(_quietEnd)}'
              : 'Off'),
          value: _quiet,
          onChanged: (v) => setState(() => _quiet = v),
        ),
        if (_quiet)
          Row(
            children: [
              Expanded(
                child: _HourPicker(
                  label: 'From',
                  value: _quietStart,
                  onChanged: (h) => setState(() => _quietStart = h),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HourPicker(
                  label: 'To',
                  value: _quietEnd,
                  onChanged: (h) => setState(() => _quietEnd = h),
                ),
              ),
            ],
          ),

        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(label: 'Save', loading: _saving, onPressed: _save),
      ],
    );
  }

  Widget _toggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textTertiary)),
        value: value,
        onChanged: onChanged,
      );
}

String _fmtHour(int h) {
  final period = h < 12 ? 'AM' : 'PM';
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  return '$hour12:00 $period';
}

class _HourPicker extends StatelessWidget {
  const _HourPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: [
                for (var h = 0; h < 24; h++)
                  DropdownMenuItem(value: h, child: Text(_fmtHour(h))),
              ],
              onChanged: (h) => h == null ? null : onChanged(h),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AppColors.textTertiary,
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../requests/application/requests_controller.dart';
import '../../domain/offering.dart';

/// HOME-05: bottom sheet to send a request with an optional preferred time and
/// message. Returns true from the sheet when the request was sent.
Future<bool?> showSendRequestSheet(BuildContext context, Offering offering) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _SendRequestSheet(offering: offering),
  );
}

class _SendRequestSheet extends ConsumerStatefulWidget {
  const _SendRequestSheet({required this.offering});

  final Offering offering;

  @override
  ConsumerState<_SendRequestSheet> createState() => _SendRequestSheetState();
}

class _SendRequestSheetState extends ConsumerState<_SendRequestSheet> {
  final _message = TextEditingController();
  DateTime? _when;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );
    if (!mounted) return;
    setState(() {
      _when = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );
    });
  }

  Future<void> _send() async {
    final ok = await ref.read(requestsControllerProvider.notifier).sendRequest(
          teacherUid: widget.offering.teacherUid,
          skillId: widget.offering.skillId,
          preferredDateTime: _when,
          message: _message.text,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send request. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(requestsControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request ${widget.offering.skillName}',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'to ${widget.offering.teacherName}',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Preferred date & time (optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDateTime,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_outlined,
                      size: 18, color: AppColors.textTertiary),
                  const SizedBox(width: 10),
                  Text(
                    _when == null
                        ? 'Pick a time'
                        : DateFormat('EEE, MMM d · h:mm a').format(_when!),
                    style: TextStyle(
                      fontSize: 15,
                      color: _when == null
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          const Text(
            'Message (optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _message,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add a note for the teacher…',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            label: 'Send Request',
            loading: busy,
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}

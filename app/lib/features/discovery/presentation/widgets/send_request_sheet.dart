import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../requests/application/requests_controller.dart';
import '../../../requests/data/functions_repository.dart';
import '../../domain/offering.dart';

/// HOME-05: bottom sheet to send a request with an optional message.
/// Returns true from the sheet when the request was sent.
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

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final ok = await ref.read(requestsControllerProvider.notifier).sendRequest(
          teacherUid: widget.offering.teacherUid,
          skillId: widget.offering.skillId,
          message: _message.text,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      final err = ref.read(requestsControllerProvider).error;
      final msg = err is FunctionFailure
          ? err.message
          : 'Could not send request. Try again.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

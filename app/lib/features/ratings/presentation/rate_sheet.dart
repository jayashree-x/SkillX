import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../data/rating_repository.dart';

/// Opens the rate-your-teacher sheet (RATE-01). 1–5 stars + optional feedback.
Future<void> showRateSheet(
  BuildContext context, {
  required String sessionId,
  required String teacherUid,
  required String teacherName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RateSheet(
      sessionId: sessionId,
      teacherUid: teacherUid,
      teacherName: teacherName,
    ),
  );
}

class _RateSheet extends ConsumerStatefulWidget {
  const _RateSheet({
    required this.sessionId,
    required this.teacherUid,
    required this.teacherName,
  });

  final String sessionId;
  final String teacherUid;
  final String teacherName;

  @override
  ConsumerState<_RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends ConsumerState<_RateSheet> {
  final _feedback = TextEditingController();
  int _stars = 0;
  bool _busy = false;

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_stars == 0 || _busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(ratingRepositoryProvider).submitRating(
            sessionId: widget.sessionId,
            teacherUid: widget.teacherUid,
            stars: _stars,
            feedback: _feedback.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks for the rating!')),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not submit. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        8,
        AppSpacing.screen,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate ${widget.teacherName}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'How was the session?',
            style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 1; i <= 5; i++)
                  Semantics(
                    button: true,
                    label: '$i star${i == 1 ? '' : 's'}',
                    selected: _stars >= i,
                    child: IconButton(
                      iconSize: 40,
                      onPressed: () => setState(() => _stars = i),
                      icon: Icon(
                        _stars >= i ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: _stars >= i ? AppColors.reward : AppColors.textTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _feedback,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add a note (optional)',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Submit rating',
            loading: _busy,
            onPressed: _stars > 0 ? _submit : null,
          ),
        ],
      ),
    );
  }
}

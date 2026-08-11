import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/upcoming_session.dart';

/// HOME-09: a confirmed session with a Join button (view/join only, HOME-07b).
class UpcomingSessionCard extends StatelessWidget {
  const UpcomingSessionCard({super.key, required this.session, this.onJoin});

  final UpcomingSession session;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.topic,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'with ${session.teacherName}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _Tag(label: 'Learning'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event_outlined,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                _schedule(),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: session.canJoin ? onJoin : null,
              child: Text(session.canJoin ? 'Join Session' : 'Link coming soon'),
            ),
          ),
        ],
      ),
    );
  }

  String _schedule() {
    final at = session.scheduledAt;
    final duration = '${session.durationHours}h';
    if (at == null) return 'Time to be confirmed · $duration';
    return '${DateFormat('EEE, MMM d · h:mm a').format(at)} · $duration';
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.tealTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.teal,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A star + average rating, with an optional "New teacher" fallback for
/// unproven teachers (TRUST-03).
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    required this.isNewTeacher,
    this.sessions,
  });

  final double rating;
  final bool isNewTeacher;
  final int? sessions;

  @override
  Widget build(BuildContext context) {
    if (isNewTeacher) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.blueTint,
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Text(
          'New teacher',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.reward),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (sessions != null) ...[
          const SizedBox(width: 6),
          Text(
            '· $sessions sessions',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/offering.dart';
import 'rating_badge.dart';

/// A browse/search row: a skill, the teacher who offers it, and their rating
/// (HOME-03). Tapping opens the skill detail.
class OfferingCard extends StatelessWidget {
  const OfferingCard({super.key, required this.offering, this.onTap});

  final Offering offering;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offering.skillName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      offering.teacherName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              RatingBadge(
                rating: offering.teacherRating,
                isNewTeacher: offering.isNewTeacher,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

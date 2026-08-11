import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../application/discovery_providers.dart';
import '../domain/offering.dart';
import 'widgets/rating_badge.dart';
import 'widgets/send_request_sheet.dart';

/// Skill detail (Module 3): the offering, its teacher, trust signals, a
/// want-to-learn match indicator, and Send Request.
class SkillDetailScreen extends ConsumerWidget {
  const SkillDetailScreen({super.key, required this.offering});

  final Offering offering;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(myLearnSkillIdsProvider).maybeWhen(
          data: (ids) => ids.contains(offering.skillId),
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Skill'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.xl,
        ),
        children: [
          _CategoryChip(label: offering.category),
          const SizedBox(height: 12),
          Text(
            offering.skillName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          RatingBadge(
            rating: offering.teacherRating,
            isNewTeacher: offering.isNewTeacher,
            sessions: offering.isNewTeacher ? null : offering.teacherSessions,
          ),

          const SizedBox(height: AppSpacing.lg),
          _TeacherCard(offering: offering),

          if (offering.description != null &&
              offering.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'About this skill',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              offering.description!,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ],

          if (matches) ...[
            const SizedBox(height: AppSpacing.lg),
            _MatchBanner(skillName: offering.skillName),
          ],

          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Send Request',
            onPressed: () async {
              final sent = await showSendRequestSheet(context, offering);
              if (sent == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request sent.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.tealTint,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.teal,
          ),
        ),
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.offering});
  final Offering offering;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          UserAvatar(
            name: offering.teacherName,
            photoUrl: offering.teacherPhotoUrl,
            radius: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offering.teacherName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                RatingBadge(
                  rating: offering.teacherRating,
                  isNewTeacher: offering.isNewTeacher,
                  sessions: offering.isNewTeacher ? null : offering.teacherSessions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchBanner extends StatelessWidget {
  const _MatchBanner({required this.skillName});
  final String skillName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'This matches ',
                style: const TextStyle(fontSize: 14, color: AppColors.primaryDark),
                children: [
                  TextSpan(
                    text: skillName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: ' in your want-to-learn list'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

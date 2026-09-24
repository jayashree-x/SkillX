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
    final extrasKey =
        (teacherUid: offering.teacherUid, skillId: offering.skillId);
    final extras = ref.watch(teacherExtrasProvider(extrasKey));

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
          extras.maybeWhen(
            data: (e) {
              final trusted = (e['trustedSkills'] as List?) ?? const [];
              if (trusted.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _TrustedChips(trusted: trusted),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),

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

          extras.maybeWhen(
            data: (e) => _ReviewsSection(
              reviews: (e['reviews'] as List?) ?? const [],
              average: (e['averageRating'] as num?)?.toDouble() ?? 0,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.xl),
          extras.maybeWhen(
            data: (e) => (e['alreadyRequested'] == true)
                ? const _RequestedButton()
                : _SendButton(offering: offering, extrasKey: extrasKey),
            orElse: () =>
                _SendButton(offering: offering, extrasKey: extrasKey),
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


class _TrustedChips extends StatelessWidget {
  const _TrustedChips({required this.trusted});
  final List<dynamic> trusted;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final t in trusted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tealTint,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 15, color: AppColors.teal),
                const SizedBox(width: 5),
                Text('Trusted in ${(t as Map)['skill']}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews, required this.average});
  final List<dynamic> reviews;
  final double average;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const Text('Reviews',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(width: 8),
            if (average > 0)
              Text('${average.toStringAsFixed(1)} \u2605',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.reward)),
          ],
        ),
        const SizedBox(height: 10),
        for (final r in reviews)
          _ReviewTile(data: (r as Map).cast<String, dynamic>()),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final stars = (data['stars'] as num?)?.toInt() ?? 0;
    final name = data['learnerName'] as String? ?? 'SkillX learner';
    final feedback = data['feedback'] as String? ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      i < stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 16,
                      color: AppColors.reward,
                    ),
                ],
              ),
            ],
          ),
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(feedback,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.4, color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }
}


class _SendButton extends ConsumerWidget {
  const _SendButton({required this.offering, required this.extrasKey});
  final Offering offering;
  final ({String teacherUid, String skillId}) extrasKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      label: 'Send Request',
      onPressed: () async {
        final sent = await showSendRequestSheet(context, offering);
        if (sent == true) {
          ref.invalidate(teacherExtrasProvider(extrasKey));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request sent.')),
            );
          }
        }
      },
    );
  }
}

class _RequestedButton extends StatelessWidget {
  const _RequestedButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.fill,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.success),
          SizedBox(width: 8),
          Text('Request already sent',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

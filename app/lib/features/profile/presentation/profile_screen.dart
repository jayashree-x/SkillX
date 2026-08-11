import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/profile_repository.dart' show UserSkill;
import '../../skills/domain/skill_relation.dart';
import '../application/profile_providers.dart';
import '../domain/profile.dart';
import 'widgets/certificate_card.dart';
import 'widgets/resume_card.dart';
import 'widgets/skills_section.dart';
import 'widgets/stat_tile.dart';

/// Module 10 — Profile: identity, teaching stats, resume, the three skill
/// sections, and certificates. This is the signed-in user's own (editable)
/// profile; a read-only view of other users comes with the teacher-profile
/// navigation in a later phase.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    final profile = profileAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (profile != null)
            IconButton(
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/profile/edit', extra: profile),
            ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Could not load your profile.',
              style: TextStyle(color: AppColors.textTertiary)),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(myProfileProvider)
              ..invalidate(myProfileSkillsProvider)
              ..invalidate(myCertificatesProvider);
          },
          child: _Body(profile: profile),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(myProfileSkillsProvider).valueOrNull ?? const [];
    final certificates =
        ref.watch(myCertificatesProvider).valueOrNull ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.lg,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      children: [
        Center(
          child: Column(
            children: [
              UserAvatar(
                  name: profile.name, photoUrl: profile.photoUrl, radius: 44),
              const SizedBox(height: 12),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile.email,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  profile.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, height: 1.5, color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.school_outlined,
                value: '${profile.totalSessions}',
                label: 'Sessions taught',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                icon: Icons.star_outline_rounded,
                value: profile.averageRating.toStringAsFixed(1),
                label: 'Avg rating',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                icon: Icons.local_fire_department_outlined,
                value: '${profile.currentStreak}',
                label: 'Day streak',
              ),
            ),
          ],
        ),

        const _SectionTitle('Resume'),
        ResumeCard(profile: profile),

        _SectionTitle(
          'Skills',
          action: 'Manage',
          onAction: () => context.push('/profile/skills'),
        ),
        SkillsSection(
          heading: 'Skills I have',
          skillNames: _names(skills, SkillRelation.have),
          variant: SkillChipVariant.neutral,
        ),
        const SizedBox(height: AppSpacing.md),
        SkillsSection(
          heading: 'Skills I can teach',
          skillNames: _names(skills, SkillRelation.teach),
          variant: SkillChipVariant.teach,
        ),
        const SizedBox(height: AppSpacing.md),
        SkillsSection(
          heading: 'Skills I want to learn',
          skillNames: _names(skills, SkillRelation.learn),
          variant: SkillChipVariant.learn,
        ),

        const _SectionTitle('Learning & teaching'),
        _LinkTile(
          icon: Icons.route_outlined,
          label: 'Learning paths',
          onTap: () => context.push('/paths'),
        ),
        const SizedBox(height: 8),
        _LinkTile(
          icon: Icons.school_outlined,
          label: 'Teaching sessions',
          onTap: () => context.push('/teaching'),
        ),
        const SizedBox(height: 8),
        _LinkTile(
          icon: Icons.quiz_outlined,
          label: 'My quizzes',
          onTap: () => context.push('/quizzes'),
        ),
        const SizedBox(height: 8),
        _LinkTile(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          onTap: () => context.push('/notifications'),
        ),
        const SizedBox(height: 8),
        _LinkTile(
          icon: Icons.info_outline_rounded,
          label: 'About SkillX',
          onTap: () => context.push('/about'),
        ),

        if (certificates.isNotEmpty) ...[
          const _SectionTitle('Certificates'),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: certificates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) => CertificateCard(
                certificate: certificates[i],
                onTap: () => _openPdf(certificates[i].pdfUrl),
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<String> _names(List<UserSkill> skills, SkillRelation relation) => skills
      .where((s) => s.relation == relation)
      .map((s) => s.skill.name)
      .toList();

  Future<void> _openPdf(String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

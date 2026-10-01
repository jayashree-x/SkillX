import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/presentation/widgets/brand_logo.dart';

/// Module 13 — About Us: what SkillX is, plus version + credits.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                const BrandLogo(size: 84),
                const SizedBox(height: 12),
                const Text(
                  'SkillX',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _Para(
            'SkillX is a peer-to-peer learning community. Find someone who '
            'teaches a skill you want to learn, meet over a video session, then '
            'take a short quiz to earn badges, build a streak, and progress along '
            'a learning path — all the way to a participation certificate.',
          ),
          const _Para(
            "It's entirely peer-to-peer: everyone is both a learner and a "
            'teacher, and there are no paid instructors.',
          ),
          const SizedBox(height: AppSpacing.lg),
          const _Bullet(Icons.swap_horiz_rounded, 'Swap skills with peers'),
          const _Bullet(Icons.videocam_outlined, 'Meet over auto-created video links'),
          const _Bullet(Icons.workspace_premium_outlined,
              'Earn badges, streaks & certificates'),
          const _Bullet(Icons.route_outlined, 'Follow structured learning paths'),
          const SizedBox(height: AppSpacing.xl),
          const Center(
            child: Text(
              'Made with Flutter & Firebase.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Para extends StatelessWidget {
  const _Para(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14.5, height: 1.55, color: AppColors.textSecondary),
        ),
      );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary)),
            ),
          ],
        ),
      );
}

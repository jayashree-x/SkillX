import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/auth_controller.dart';
import '../application/auth_providers.dart';

/// Shown to a password account whose email is not yet verified (REG-04,
/// LOG-05). Polls for verification and offers resend + logout.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // The verification link is followed in the browser; poll so we notice.
    _poll = Timer.periodic(
      const Duration(seconds: 5),
      (_) => ref.read(authControllerProvider.notifier).refreshVerification(),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(firebaseUserProvider).valueOrNull?.email ?? '';
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.mark_email_unread_outlined,
                  size: 72, color: AppColors.primary),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'We sent a verification link to\n',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: "I've verified",
                onPressed: controller.refreshVerification,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    await controller.resendVerificationEmail();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification email sent.')),
                    );
                  },
                  child: const Text('Resend email'),
                ),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: controller.signOut,
                  child: const Text(
                    'Use a different account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

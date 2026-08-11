import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/auth_controller.dart';
import 'validators.dart';

const _resendCooldown = 30;

/// Module 2 — Forgot Password (LOG-07..15). One email field → reset email,
/// then a confirmation screen with a rate-limited resend.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _sent = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(_email.text);
    if (!mounted) return;
    if (!ref.read(authControllerProvider).hasError) {
      setState(() => _sent = true);
      _startCooldown();
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0) return;
    await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(_email.text);
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BackToLogin(onTap: () => context.go('/login')),
              Expanded(
                child: _sent
                    ? _SuccessView(
                        secondsLeft: _secondsLeft,
                        loading: loading,
                        onResend: _resend,
                        onBack: () => context.go('/login'),
                      )
                    : _RequestView(
                        formKey: _formKey,
                        email: _email,
                        loading: loading,
                        onSend: _send,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackToLogin extends StatelessWidget {
  const _BackToLogin({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 18, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                'Back to login',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestView extends StatelessWidget {
  const _RequestView({
    required this.formKey,
    required this.email,
    required this.loading,
    required this.onSend,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final bool loading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Reset your password',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Enter your email and we'll send a reset link.",
            style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Email',
            controller: email,
            hint: 'name@email.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: Validators.email,
            onFieldSubmitted: (_) => onSend(),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: 'Send reset link',
            loading: loading,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.secondsLeft,
    required this.loading,
    required this.onResend,
    required this.onBack,
  });

  final int secondsLeft;
  final bool loading;
  final VoidCallback onResend;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final canResend = secondsLeft == 0 && !loading;
    final countdown =
        '0:${secondsLeft.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 72),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.teal, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.tealTint, blurRadius: 0, spreadRadius: 6),
            ],
          ),
          child: const Icon(Icons.check, size: 40, color: AppColors.teal),
        ),
        const SizedBox(height: 24),
        const Text(
          'Check your email',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'If an account exists for this email, a reset link has been sent. '
          'It expires in 1 hour.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 36),
        const Text(
          "Didn't get it?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: canResend ? onResend : null,
            child: const Text('Resend link'),
          ),
        ),
        if (secondsLeft > 0) ...[
          const SizedBox(height: 8),
          Text(
            'Resend available in $countdown',
            style: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
          ),
        ],
        const SizedBox(height: 32),
        GestureDetector(
          onTap: onBack,
          child: const Text(
            'Back to login',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

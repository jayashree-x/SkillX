import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../application/auth_controller.dart';
import '../application/auth_providers.dart';
import 'validators.dart';
import 'widgets/skill_selector.dart';

/// Module 1 — Register. REG-01..08: name/email/password + email verification,
/// ≥1 teach and ≥1 learn skill, optional photo, duplicate-email inline error.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _teachIds = <String>{};
  final _learnIds = <String>{};

  Uint8List? _photoBytes;
  bool _skillError = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (mounted) setState(() => _photoBytes = bytes);
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState?.validate() ?? false;
    final skillsOk = _teachIds.isNotEmpty && _learnIds.isNotEmpty;
    setState(() => _skillError = !skillsOk);
    if (!formOk || !skillsOk) return;

    await ref.read(authControllerProvider.notifier).register(
          name: _name.text,
          email: _email.text,
          password: _password.text,
          teachSkillIds: _teachIds.toList(),
          learnSkillIds: _learnIds.toList(),
          photoBytes: _photoBytes,
        );
    // On success the router redirects to the verify-email screen.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final catalogue = ref.watch(skillCatalogueProvider);

    ref.listen(authControllerProvider, (_, next) {
      final message = AuthController.errorText(next);
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final skills = catalogue.valueOrNull ?? const [];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Start swapping skills in minutes.',
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),

                Center(child: _PhotoPicker(bytes: _photoBytes, onTap: _pickPhoto)),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Full name',
                  controller: _name,
                  hint: 'Alex Rivera',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                ),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  hint: 'alex@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                ),
                AppTextField(
                  label: 'Password',
                  controller: _password,
                  hint: 'At least 8 characters',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.password,
                ),

                const SizedBox(height: AppSpacing.sm),
                if (catalogue.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  SkillSelector(
                    heading: 'Skills I can teach',
                    options: skills,
                    selectedIds: _teachIds,
                    selectedVariant: SkillChipVariant.teach,
                    onToggle: (id) => setState(() => _toggle(_teachIds, id)),
                    emptyHint:
                        'The skill catalogue is empty — seed it to pick skills.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SkillSelector(
                    heading: 'Skills I want to learn',
                    options: skills,
                    selectedIds: _learnIds,
                    selectedVariant: SkillChipVariant.learn,
                    onToggle: (id) => setState(() => _toggle(_learnIds, id)),
                    emptyHint: '',
                  ),
                ],
                if (_skillError)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'Pick at least one skill to teach and one to learn.',
                      style: TextStyle(fontSize: 13, color: AppColors.error),
                    ),
                  ),

                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Create Account',
                  loading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggle(Set<String> set, String id) {
    if (!set.remove(id)) set.add(id);
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.bytes, required this.onTap});

  final Uint8List? bytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.fill,
            backgroundImage: bytes != null ? MemoryImage(bytes!) : null,
            child: bytes == null
                ? const Icon(Icons.person, size: 36, color: AppColors.textTertiary)
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

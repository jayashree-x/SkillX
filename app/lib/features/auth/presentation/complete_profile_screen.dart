import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../application/auth_controller.dart';
import '../application/auth_providers.dart';
import 'widgets/skill_selector.dart';

/// "Complete your profile" — the gate a first-time Google user hits before the
/// app shell. Requires ≥1 teach + ≥1 learn skill (REG-05/06).
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final _teachIds = <String>{};
  final _learnIds = <String>{};
  bool _skillError = false;

  Future<void> _submit() async {
    final ok = _teachIds.isNotEmpty && _learnIds.isNotEmpty;
    setState(() => _skillError = !ok);
    if (!ok) return;
    await ref.read(authControllerProvider.notifier).completeProfile(
          teachSkillIds: _teachIds.toList(),
          learnSkillIds: _learnIds.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final catalogue = ref.watch(skillCatalogueProvider);
    final user = ref.watch(firebaseUserProvider).valueOrNull;
    final firstName = (user?.displayName ?? '').split(' ').first;

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
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstName.isEmpty
                    ? 'Complete your profile'
                    : 'Welcome, $firstName',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pick at least one skill to teach and one to learn to get started.',
                style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (catalogue.isLoading)
                const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: CircularProgressIndicator(),
                ))
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

              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Continue',
                loading: state.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: GestureDetector(
                  onTap: ref.read(authControllerProvider.notifier).signOut,
                  child: const Text(
                    'Not you? Sign out',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle(Set<String> set, String id) {
    if (!set.remove(id)) set.add(id);
  }
}

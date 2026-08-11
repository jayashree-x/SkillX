import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../shared/widgets/skill_chip.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/data/profile_repository.dart' show UserSkill;
import '../../auth/presentation/widgets/skill_selector.dart';
import '../../skills/domain/skill_relation.dart';
import '../application/profile_controller.dart';
import '../application/profile_providers.dart';

/// Add / remove the user's three skill lists (PROF-02/03/04). Saves as
/// add/remove diffs against the current selection.
class ManageSkillsScreen extends ConsumerStatefulWidget {
  const ManageSkillsScreen({super.key});

  @override
  ConsumerState<ManageSkillsScreen> createState() => _ManageSkillsScreenState();
}

class _ManageSkillsScreenState extends ConsumerState<ManageSkillsScreen> {
  final _have = <String>{};
  final _teach = <String>{};
  final _learn = <String>{};
  bool _seeded = false;
  List<UserSkill> _current = const [];

  void _seed(List<UserSkill> skills) {
    _current = skills;
    for (final s in skills) {
      switch (s.relation) {
        case SkillRelation.have:
          _have.add(s.skill.id);
        case SkillRelation.teach:
          _teach.add(s.skill.id);
        case SkillRelation.learn:
          _learn.add(s.skill.id);
      }
    }
    _seeded = true;
  }

  void _toggle(Set<String> set, String id) =>
      setState(() => set.contains(id) ? set.remove(id) : set.add(id));

  Future<void> _save() async {
    final ok = await ref.read(profileControllerProvider.notifier).saveSkills(
          current: _current,
          have: _have,
          teach: _teach,
          learn: _learn,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save skills. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogue = ref.watch(skillCatalogueProvider);
    final skills = ref.watch(myProfileSkillsProvider);
    final busy = ref.watch(profileControllerProvider).isLoading;

    if (!_seeded && skills.hasValue) _seed(skills.value!);

    final options = catalogue.valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Manage skills')),
      body: catalogue.isLoading || skills.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              children: [
                SkillSelector(
                  heading: 'Skills I have',
                  options: options,
                  selectedIds: _have,
                  selectedVariant: SkillChipVariant.neutral,
                  onToggle: (id) => _toggle(_have, id),
                ),
                const SizedBox(height: AppSpacing.lg),
                SkillSelector(
                  heading: 'Skills I can teach',
                  options: options,
                  selectedIds: _teach,
                  selectedVariant: SkillChipVariant.teach,
                  onToggle: (id) => _toggle(_teach, id),
                ),
                const SizedBox(height: AppSpacing.lg),
                SkillSelector(
                  heading: 'Skills I want to learn',
                  options: options,
                  selectedIds: _learn,
                  selectedVariant: SkillChipVariant.learn,
                  onToggle: (id) => _toggle(_learn, id),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(label: 'Save', loading: busy, onPressed: _save),
              ],
            ),
    );
  }
}

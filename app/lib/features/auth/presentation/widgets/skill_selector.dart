import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/skill_chip.dart';
import '../../../skills/domain/skill_option.dart';

/// A titled section of tappable skill chips (REG-05/06). Selected chips use
/// [selectedVariant]; unselected chips are outlined. Reuses the shared
/// [SkillChip]. Used by the register and complete-profile screens.
class SkillSelector extends StatelessWidget {
  const SkillSelector({
    super.key,
    required this.heading,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
    required this.selectedVariant,
    this.emptyHint = 'No skills in the catalogue yet.',
  });

  final String heading;
  final List<SkillOption> options;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final SkillChipVariant selectedVariant;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        if (options.isEmpty)
          Text(
            emptyHint,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                SkillChip(
                  label: option.name,
                  variant: selectedIds.contains(option.id)
                      ? selectedVariant
                      : SkillChipVariant.unselected,
                  onTap: () => onToggle(option.id),
                ),
            ],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/skill_chip.dart';

/// A read-only, grouped skill section on the profile (PROF-02/03/04, PROF-05).
class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
    required this.heading,
    required this.skillNames,
    required this.variant,
  });

  final String heading;
  final List<String> skillNames;
  final SkillChipVariant variant;

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
        if (skillNames.isEmpty)
          const Text(
            'None yet',
            style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in skillNames)
                SkillChip(label: name, variant: variant),
            ],
          ),
      ],
    );
  }
}

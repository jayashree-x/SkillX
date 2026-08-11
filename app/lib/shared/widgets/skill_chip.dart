import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Chip-style tag for skills. Variants match the design system:
/// - teach  → teal fill, white text
/// - learn  → primary (blue) fill, white text
/// - neutral→ subtle grey fill (read-only display)
/// - unselected → white with border (selectable)
enum SkillChipVariant { teach, learn, neutral, unselected }

class SkillChip extends StatelessWidget {
  const SkillChip({
    super.key,
    required this.label,
    this.variant = SkillChipVariant.unselected,
    this.onTap,
    this.onRemove,
  });

  final String label;
  final SkillChipVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (variant) {
      SkillChipVariant.teach => (AppColors.teal, Colors.white, null),
      SkillChipVariant.learn => (AppColors.primary, Colors.white, null),
      SkillChipVariant.neutral =>
        (AppColors.fillSubtle, const Color(0xFF334155), null),
      SkillChipVariant.unselected =>
        (AppColors.surface, AppColors.textSecondary, AppColors.borderStrong),
    };

    return Material(
      color: bg,
      shape: StadiumBorder(
        side: border == null ? BorderSide.none : BorderSide(color: border),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: fg, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(Icons.close, size: 14, color: fg),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

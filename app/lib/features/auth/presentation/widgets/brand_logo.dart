import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The "SX" wordmark tile from the splash/login mockups: "S" in brand blue,
/// "X" in reward gold, on a rounded surface.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 72,
    this.background = AppColors.primary,
    this.onBackground = Colors.white,
  });

  final double size;
  final Color background;

  /// Colour of the "S" glyph (the "X" is always [AppColors.reward]).
  final Color onBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: size * 0.47,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: onBackground,
          ),
          children: const [
            TextSpan(text: 'S'),
            TextSpan(text: 'X', style: TextStyle(color: AppColors.reward)),
          ],
        ),
      ),
    );
  }
}

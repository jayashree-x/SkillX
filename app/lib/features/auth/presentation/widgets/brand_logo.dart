import 'package:flutter/material.dart';

/// The SkillX brand mark: the graduation-cap "S" with the growth arrow.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/skillx_mark.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

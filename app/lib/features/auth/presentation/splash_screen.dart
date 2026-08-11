import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/brand_logo.dart';

/// Branded splash shown while [appAuthStateProvider] resolves the first auth
/// emission. The router redirects away as soon as the status is known.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandLogo(
                  size: 96,
                  background: Colors.white,
                  onBackground: AppColors.primary,
                ),
                const SizedBox(height: 22),
                const Text(
                  'SkillX',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Swap skills. Grow together.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment(0, 0.82),
            child: _PulsingDots(),
          ),
        ],
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final phase = (_controller.value - i * 0.2) % 1.0;
            final opacity = 0.25 + 0.75 * (phase < 0.4 ? phase / 0.4 : 0.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.5),
              child: Opacity(
                opacity: opacity.clamp(0.25, 1.0),
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// SkillX design tokens — spacing, radii. LOCKED (from design-system CLAUDE.md).
abstract final class AppSpacing {
  // Spacing scale: 4 / 8 / 16 / 24 / 32
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  /// 16px screen padding (iPhone frame 390×844).
  static const screen = 16.0;
}

abstract final class AppRadius {
  static const card = 12.0; // cards
  static const button = 8.0; // buttons / inputs
  static const chip = 999.0; // full-round chips
}

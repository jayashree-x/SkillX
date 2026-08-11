import 'package:flutter/material.dart';

/// SkillX design tokens — colors. LOCKED (from design-system CLAUDE.md).
/// Do not introduce colors outside this palette.
abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF2563EB); // buttons, active states, links
  static const primaryDark = Color(0xFF1E40AF); // pressed states, headers
  static const teal = Color(0xFF0D9488); // accents, "learn" tags
  static const reward = Color(0xFFF59E0B); // streaks, badges, gold highlights

  // Status
  static const success = Color(0xFF16A34A);
  static const error = Color(0xFFDC2626);

  // Surfaces
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF94A3B8);

  // Lines / fills
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);
  static const fill = Color(0xFFF1F5F9);
  static const fillSubtle = Color(0xFFEEF2F7);

  // Tag/section tints
  static const tealTint = Color(0xFFF0FDFA); // teal chip background
  static const blueTint = Color(0xFFEFF6FF); // blue chip / info background

  // Badge tiers
  static const bronze = Color(0xFFCD7F32);
  static const silver = Color(0xFFC0C0C0);
  static const gold = Color(0xFFFFD700);
}

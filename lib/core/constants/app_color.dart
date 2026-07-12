import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/theme/themeController.dart';

class AppColors {
  static bool get _isDark => Get.find<ThemeController>().isDarkMode.value;

  // Primary Colors
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color secondaryColor = Color(0xFF2C5364);

  // Background Colors
  static Color get backgroundColor =>
      _isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB);
  static Color get cardColor =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentGold = Color(0xFFC8A951);

  // Text Colors
  static Color get primaryText =>
      _isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1F2937);
  static Color get secondaryText =>
      _isDark ? const Color(0xFFB0B8C1) : const Color(0xFF6B7280);
  static Color get hintText =>
      _isDark ? const Color(0xFF8C949D) : const Color(0xFF9CA3AF);

  // Border & Divider
  static Color get borderColor =>
      _isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E7EB);
  static Color get dividerColor =>
      _isDark ? const Color(0xFF2A2A2C) : const Color(0xFFF1F5F9);

  // Status Colors
  static const Color successColor = Color(0xFF16A34A);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFDC2626);
}
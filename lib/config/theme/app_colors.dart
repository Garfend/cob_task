import 'package:flutter/material.dart';

/// Modern color palette for the app
class AppColors {
  AppColors._();

  // ==================== Light Theme Colors ====================

  // Primary Colors - Modern Blue
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color primaryDarkLight = Color(0xFF1565C0);
  static const Color primaryLightShade = Color(0xFF42A5F5);

  // Secondary Colors - Accent Orange
  static const Color secondaryLight = Color(0xFFFF6F00);
  static const Color secondaryDarkLight = Color(0xFFE65100);
  static const Color secondaryLightShade = Color(0xFFFF8F00);

  // Accent Colors - Pink for Favorites
  static const Color pinkAccentLight = Color(0xFFF06292);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  // Error Colors
  static const Color errorLight = Color(0xFFDC2626);
  static const Color errorLightShade = Color(0xFFEF4444);

  // Success Colors
  static const Color successLight = Color(0xFF10B981);
  static const Color successLightShade = Color(0xFF34D399);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF3F4F6);

  // ==================== Dark Theme Colors ====================

  // Primary Colors
  static const Color primaryDark = Color(0xFF42A5F5);
  static const Color primaryDarkDark = Color(0xFF1E88E5);
  static const Color primaryDarkShade = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondaryDark = Color(0xFFFF8F00);
  static const Color secondaryDarkDark = Color(0xFFFF6F00);
  static const Color secondaryDarkShade = Color(0xFFFFA726);

  // Accent Colors - Pink for Favorites
  static const Color pinkAccentDark = Color(0xFFFF4081);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);

  // Error Colors
  static const Color errorDark = Color(0xFFEF4444);
  static const Color errorDarkShade = Color(0xFFF87171);

  // Success Colors
  static const Color successDark = Color(0xFF34D399);
  static const Color successDarkShade = Color(0xFF6EE7B7);

  // Border Colors
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF1E293B);

  // ==================== Common Colors ====================

  // Shimmer Colors
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2D3748);
  static const Color shimmerHighlightDark = Color(0xFF4A5568);

  // Category Colors (same for light and dark)
  static const Map<String, Color> categoryColors = {
    'general': Color(0xFF6366F1),
    'business': Color(0xFF10B981),
    'technology': Color(0xFF3B82F6),
    'sports': Color(0xFFEF4444),
    'health': Color(0xFFEC4899),
    'science': Color(0xFF8B5CF6),
    'entertainment': Color(0xFFF59E0B),
  };

  /// Get category color
  static Color getCategoryColor(String category) {
    return categoryColors[category.toLowerCase()] ?? primaryLight;
  }
}

import 'package:flutter/material.dart';

/// A pro-level centralized color management for Flutter app.
/// Use AppColors.primary, AppColors.background, etc., everywhere.

class AppColors {
  // --------------------
  // Brand / Primary Colors
  // --------------------
  static const Color primary = Color(0xFF1A1F2B);        // Deep dark navy for premium feel
  static const Color primaryLight = Color(0xFF2C3545);
  static const Color primaryDark = Color(0xFF0D121A);

  static const Color gold = Color(0xFFC5A35D);           // Premium gold for highlights
  static const Color goldLight = Color(0xFFE5CC91);
  static const Color goldDark = Color(0xFF917336);

  static const Color accent = gold;

  // --------------------
  // Background / Scaffold
  // --------------------
  static const Color scaffoldBackground = Color(0xFFF9FAFB);
  static const Color cardBackground = Colors.white;
  static const Color darkScaffoldBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  static const Color chipBackground = Color(0xFFFFF7E6); // Light beige/cream for chips

  // --------------------
  // Text Colors
  // --------------------
  static const Color textPrimary = Color(0xFF1A1F2B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textLight = Colors.white;

  // --------------------
  // Status Colors
  // --------------------
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // --------------------
  // Grey Shades
  // --------------------
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color grey = Color(0xFFD1D5DB);
  static const Color greyDark = Color(0xFF4B5563);

  // --------------------
  // Optional Semantic / Extra
  // --------------------
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0F000000); 
  static const Color transparent = Colors.transparent;

  // --------------------
  // Dynamic Theme Colors (for AppTheme)
  // --------------------
  static Color background(bool isDark) =>
      isDark ? darkScaffoldBackground : scaffoldBackground;

  static Color card(bool isDark) =>
      isDark ? darkCardBackground : cardBackground;

  static Color textPrimaryColor(bool isDark) =>
      isDark ? Colors.white : textPrimary;

  static Color textSecondaryColor(bool isDark) =>
      isDark ? greyLight : textSecondary;
}

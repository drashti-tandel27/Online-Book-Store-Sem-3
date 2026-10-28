import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF1E3A8A); // Deep Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF172554);
  
  static const Color secondary = Color(0xFFF59E0B); // Warm Amber Gold
  static const Color secondaryLight = Color(0xFFFDE68A);
  static const Color secondaryDark = Color(0xFFD97706);
  
  static const Color accent = Color(0xFF0D9488); // Deep Teal
  static const Color accentLight = Color(0xFFCCFBF1);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Clean Off-white/slate
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  // Card & Container backgrounds
  static const Color cardBg = Colors.white;
  static const Color inputBg = Color(0xFFF8FAFC);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textLight = Colors.white;

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFDBEAFE);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF3B82F6);
  static const Color divider = Color(0xFFEDF2F7);

  // Order Status Colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'confirmed':
        return const Color(0xFF3B82F6);
      case 'processing':
        return const Color(0xFF8B5CF6);
      case 'shipped':
        return const Color(0xFF06B6D4);
      case 'delivered':
        return const Color(0xFF10B981);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return textSecondary;
    }
  }

  static Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'confirmed':
        return const Color(0xFFDBEAFE);
      case 'processing':
        return const Color(0xFFEDE9FE);
      case 'shipped':
        return const Color(0xFFCFFAFE);
      case 'delivered':
        return const Color(0xFFD1FAE5);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return surfaceVariant;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final borderRadius =
    BorderRadius.circular(12);

    return ThemeData(
      useMaterial3: true,

      // =========================================================================
      // COLOR SCHEME
      // =========================================================================

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        surfaceContainerLowest:
        AppColors.surface,
        surfaceContainerLow:
        AppColors.surfaceVariant,
        surfaceContainer:
        AppColors.surfaceVariant,
      ),

      scaffoldBackgroundColor:
      AppColors.background,

      // =========================================================================
      // APP BAR
      // =========================================================================

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor:
        AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,

        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight:
          FontWeight.w700,
          letterSpacing: -0.2,
        ),

        systemOverlayStyle:
        SystemUiOverlayStyle(
          statusBarColor:
          Colors.transparent,
          statusBarIconBrightness:
          Brightness.dark,
        ),
      ),

      // =========================================================================
      // CARD
      // =========================================================================

      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),

      // =========================================================================
      // ELEVATED BUTTON
      // =========================================================================

      elevatedButtonTheme:
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          AppColors.primary,
          foregroundColor:
          Colors.white,
          disabledBackgroundColor:
          AppColors.primary,
          disabledForegroundColor:
          Colors.white,

          elevation: 0,

          minimumSize:
          const Size(
            double.infinity,
            50,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            borderRadius,
          ),

          textStyle:
          const TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // =========================================================================
      // OUTLINED BUTTON
      // =========================================================================

      outlinedButtonTheme:
      OutlinedButtonThemeData(
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          AppColors.primary,

          side: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),

          minimumSize:
          const Size(
            double.infinity,
            50,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            borderRadius,
          ),

          textStyle:
          const TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      // =========================================================================
      // TEXT BUTTON
      // =========================================================================

      textButtonTheme:
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
          AppColors.primary,

          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          textStyle:
          const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      // =========================================================================
      // INPUT FIELDS
      // =========================================================================

      inputDecorationTheme:
      InputDecorationTheme(
        filled: true,
        fillColor:
        AppColors.inputBg,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border:
        OutlineInputBorder(
          borderRadius:
          borderRadius,
          borderSide:
          const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          borderRadius,
          borderSide:
          const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          borderRadius,
          borderSide:
          const BorderSide(
            color: AppColors.borderFocus,
            width: 1.5,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          borderRadius,
          borderSide:
          const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          borderRadius,
          borderSide:
          const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),

        hintStyle:
        const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          fontWeight:
          FontWeight.normal,
        ),

        labelStyle:
        const TextStyle(
          color:
          AppColors.textSecondary,
          fontSize: 14,
        ),

        errorStyle:
        const TextStyle(
          fontSize: 12,
          height: 1.25,
        ),
      ),

      // =========================================================================
      // DIVIDER
      // =========================================================================

      dividerTheme:
      const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // =========================================================================
      // BOTTOM NAVIGATION
      // =========================================================================

      bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(
        backgroundColor:
        Colors.white,

        selectedItemColor:
        AppColors.primary,

        unselectedItemColor:
        AppColors.textMuted,

        selectedLabelStyle:
        TextStyle(
          fontSize: 12,
          fontWeight:
          FontWeight.w600,
        ),

        unselectedLabelStyle:
        TextStyle(
          fontSize: 12,
          fontWeight:
          FontWeight.w500,
        ),

        type:
        BottomNavigationBarType.fixed,

        elevation: 8,
      ),
    );
  }
}
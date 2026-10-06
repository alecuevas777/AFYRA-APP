import 'package:flutter/material.dart';

import 'package:afyra/core/theme/app_colors.dart';
import 'package:afyra/core/theme/app_spacing.dart';
import 'package:afyra/core/theme/app_typography.dart';

ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.ink,
    onPrimary: AppColors.white,
    secondary: AppColors.blushDeep,
    onSecondary: AppColors.ink,
    error: AppColors.rose,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.ink,
    surfaceTint: Colors.transparent,
  );

  final base = Typography.material2021(platform: TargetPlatform.android).black;
  final textTheme = base
      .apply(
        fontFamily: AppTypography.sans,
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      )
      .copyWith(
        headlineMedium: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 34,
          height: 1.05,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          color: AppColors.ink,
        ),
        titleLarge: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.ink,
        ),
        titleMedium: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 16,
          height: 1.25,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        bodyMedium: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
        ),
        bodySmall: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 13,
          height: 1.3,
          fontWeight: FontWeight.w400,
          color: AppColors.muted,
        ),
        labelLarge: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        labelMedium: const TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: AppColors.muted,
        ),
      );

  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,
    iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
    splashFactory: InkRipple.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      indicatorColor: AppColors.blush,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily: AppTypography.sans,
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? AppColors.ink : AppColors.muted,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.white,
        textStyle: textTheme.labelLarge?.copyWith(color: AppColors.white),
        shape: buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ink,
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
      border: _fieldBorder(AppColors.line),
      enabledBorder: _fieldBorder(AppColors.line),
      focusedBorder: _fieldBorder(AppColors.ink, width: 1.3),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.blush,
      side: BorderSide.none,
      labelStyle: textTheme.bodySmall?.copyWith(color: AppColors.ink),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      titleTextStyle: textTheme.titleMedium,
      contentTextStyle: textTheme.bodyMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: buttonShape,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      space: 1,
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.ink),
  );
}

OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    borderSide: BorderSide(color: color, width: width),
  );
}

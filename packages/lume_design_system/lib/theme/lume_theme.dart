import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Light [ThemeData] — sky-blue brand.
///
/// Uses [AppColors.lightColorScheme] and maps tokens to all Material component themes.
ThemeData lumeLightTheme() {
  final cs = AppColors.lightColorScheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    textTheme: _buildTextTheme(cs.onSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: typ.subtitleM.copyWith(color: cs.onSurface),
    ),
    cardTheme: CardThemeData(
      color: cs.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
        side: BorderSide(color: cs.outline, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      hintStyle: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: typ.body1Semibold,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: typ.body1Semibold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        textStyle: typ.body4Medium,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cs.surfaceContainerLow,
      selectedColor: cs.primaryContainer,
      labelStyle: typ.tagRegular.copyWith(color: cs.onSurface),
      side: BorderSide(color: cs.outlineVariant),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: cs.primary,
      linearTrackColor: cs.surfaceContainerHigh,
      linearMinHeight: 8,
    ),
    dividerTheme: DividerThemeData(
      color: cs.outline,
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cs.inverseSurface,
      contentTextStyle: typ.body4Light.copyWith(color: cs.onInverseSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Dark [ThemeData] — navy background with sky-blue accents.
ThemeData lumeDarkTheme() {
  const surface = Color(0xFF0D1B2A);

  final cs = AppColors.lightColorScheme.copyWith(
    brightness: Brightness.dark,
    primary: AppColors.Primary.primary,
    onPrimary: AppColors.Primary.onPrimary,
    primaryContainer: const Color(0xFF1C3B5A),
    onPrimaryContainer: AppColors.Primary.primaryLight,
    secondary: AppColors.Secondary.secondary,
    onSecondary: AppColors.Secondary.onSecondary,
    secondaryContainer: const Color(0xFF163049),
    onSecondaryContainer: AppColors.Secondary.secondary,
    surface: surface,
    onSurface: const Color(0xFFF0F6FB),
    surfaceContainerLowest: const Color(0xFF09131E),
    surfaceContainerLow: const Color(0xFF111F2E),
    surfaceContainer: const Color(0xFF17283A),
    surfaceContainerHigh: const Color(0xFF1E3246),
    surfaceContainerHighest: const Color(0xFF253C52),
    onSurfaceVariant: const Color(0xFF8AAFC8),
    outline: const Color(0xFF234054),
    outlineVariant: const Color(0xFF1B3248),
    inverseSurface: const Color(0xFFF0F6FB),
    onInverseSurface: const Color(0xFF0D1B2A),
    inversePrimary: AppColors.Primary.primary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    scaffoldBackgroundColor: cs.surface,
    textTheme: _buildTextTheme(cs.onSurface),
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: typ.subtitleM.copyWith(color: cs.onSurface),
    ),
    cardTheme: CardThemeData(
      color: cs.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
        side: BorderSide(color: cs.outline, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: typ.body1Semibold,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: cs.primary,
      linearTrackColor: cs.surfaceContainerHigh,
      linearMinHeight: 8,
    ),
    dividerTheme: DividerThemeData(
      color: cs.outline,
      thickness: 1,
      space: 1,
    ),
  );
}

// ---------------------------------------------------------------------------

TextTheme _buildTextTheme(Color defaultColor) => GoogleFonts.interTextTheme(
  TextTheme(
    displayLarge: typ.headlineXl.copyWith(color: defaultColor),
    displayMedium: typ.headlineL.copyWith(color: defaultColor),
    displaySmall: typ.headlineM.copyWith(color: defaultColor),
    headlineLarge: typ.headlineS.copyWith(color: defaultColor),
    headlineMedium: typ.headlineXs.copyWith(color: defaultColor),
    headlineSmall: typ.headline2xs.copyWith(color: defaultColor),
    titleLarge: typ.subtitleXl.copyWith(color: defaultColor),
    titleMedium: typ.subtitleM.copyWith(color: defaultColor),
    titleSmall: typ.subtitleS.copyWith(color: defaultColor),
    bodyLarge: typ.body1Light.copyWith(color: defaultColor),
    bodyMedium: typ.body3Light.copyWith(color: defaultColor),
    bodySmall: typ.body5Light.copyWith(color: defaultColor),
    labelLarge: typ.labelL.copyWith(color: defaultColor),
    labelMedium: typ.labelM.copyWith(color: defaultColor),
    labelSmall: typ.labelS.copyWith(color: defaultColor),
  ),
);

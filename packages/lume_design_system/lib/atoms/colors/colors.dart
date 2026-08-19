// Design system API intentionally uses PascalCase namespaces (e.g. AppColors.Primary.primary)
// to mirror Material role names and read like nested types.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

/// Design system colors for Lume.
///
/// Derived from the HSL CSS vars in `lume-mvp-insights/src/index.css`.
///
/// Hierarchical access: [AppColors.Primary.primary], [AppColors.Extra.sky], etc.
///
/// Naming follows [Material Design 3](https://m3.material.io/styles/color/roles) where applicable.
/// Domain/feature mapping (mastery, rarity, rewards) lives outside this package.
///
/// **Note:** Dart does not allow nested `class` declarations; namespaces are `const` palette objects.
abstract final class AppColors {
  AppColors._();

  static const Primary = _PrimaryPalette();
  static const Secondary = _SecondaryPalette();
  static const Accent = _AccentPalette();
  static const Surface = _SurfacePalette();
  static const Outline = _OutlinePalette();
  static const Error = _ErrorPalette();
  static const Success = _SuccessPalette();
  static const Inverse = _InversePalette();
  static const Text = _TextPalette();

  /// Extra brand / accent tones (visual names only — no domain semantics).
  static const Extra = _ExtraPalette();

  /// Full Material 3 [ColorScheme] for light [ThemeData], mapped from DS tokens.
  static ColorScheme get lightColorScheme => ColorScheme(
    brightness: Brightness.light,
    primary: Primary.primary,
    onPrimary: Primary.onPrimary,
    primaryContainer: Primary.primaryContainer,
    onPrimaryContainer: Primary.onPrimaryContainer,
    secondary: Secondary.secondary,
    onSecondary: Secondary.onSecondary,
    secondaryContainer: Secondary.secondaryContainer,
    onSecondaryContainer: Secondary.onSecondaryContainer,
    tertiary: Accent.accent,
    onTertiary: Accent.onAccent,
    tertiaryContainer: Accent.accentLight,
    onTertiaryContainer: Accent.onAccent,
    error: Error.error,
    onError: Error.onError,
    errorContainer: Error.errorContainer,
    onErrorContainer: Error.onErrorContainer,
    surface: Surface.surface,
    onSurface: Surface.onSurface,
    surfaceContainerLowest: Surface.surfaceContainerLowest,
    surfaceContainerLow: Surface.surfaceContainerLow,
    surfaceContainer: Surface.surfaceContainer,
    surfaceContainerHigh: Surface.surfaceContainerHigh,
    surfaceContainerHighest: Surface.surfaceContainerHighest,
    onSurfaceVariant: Surface.onSurfaceVariant,
    outline: Outline.outline,
    outlineVariant: Outline.outlineVariant,
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    inverseSurface: Inverse.inverseSurface,
    onInverseSurface: Inverse.onInverseSurface,
    inversePrimary: Inverse.inversePrimary,
    surfaceTint: Primary.primary,
  );
}

// --- Brand primary — sky blue (#1B84DA) --------------------------------

@immutable
class _PrimaryPalette {
  const _PrimaryPalette();

  /// Brand anchor: saturated sky blue — `hsl(207 78% 48%)` → #1B84DA
  final Color primary = const Color(0xFF1B84DA);

  /// Text/icons on primary — white for contrast on the stronger blue.
  final Color onPrimary = const Color(0xFFFFFFFF);

  /// Light tinted container — `hsl(207 72% 88%)` → #C5E4F8
  final Color primaryContainer = const Color(0xFFC5E4F8);

  final Color onPrimaryContainer = const Color(0xFF0A3D66);

  /// Very light wash — used for muted surfaces and input backgrounds.
  final Color primaryLight = const Color(0xFFE3F2FB);
}

// --- Secondary — medium blue (#3B7FB0) ---------------------------------

@immutable
class _SecondaryPalette {
  const _SecondaryPalette();

  /// `hsl(205 50% 46%)` → #3B7FB0
  final Color secondary = const Color(0xFF3B7FB0);

  final Color onSecondary = const Color(0xFFFFFFFF);

  /// Muted blue surface
  final Color secondaryContainer = const Color(0xFFD7ECF7);

  final Color onSecondaryContainer = const Color(0xFF14344C);
}

// --- Accent — pastel gold (#E8C87A) ------------------------------------

@immutable
class _AccentPalette {
  const _AccentPalette();

  /// `hsl(43 71% 70%)` → #E8C87A
  final Color accent = const Color(0xFFE8C87A);

  /// `hsl(38 55% 27%)` → #6B5020
  final Color onAccent = const Color(0xFF6B5020);

  /// `hsl(43 100% 96%)` → #FFF9ED
  final Color accentLight = const Color(0xFFFFF9ED);
}

// --- Surfaces & structure -----------------------------------------------

@immutable
class _SurfacePalette {
  const _SurfacePalette();

  /// Page background — `hsl(220 33% 99%)` → #FAFBFD
  final Color surface = const Color(0xFFFAFBFD);

  /// Default text — `hsl(213 30% 24%)` → #2A3A4E
  final Color onSurface = const Color(0xFF2A3A4E);

  /// Cards — white
  final Color surfaceContainerLowest = const Color(0xFFFFFFFF);

  /// Muted tinted surfaces — `hsl(210 65% 95%)` → #EBF3FB
  final Color surfaceContainerLow = const Color(0xFFEBF3FB);

  final Color surfaceContainer = const Color(0xFFE8F0F6);

  final Color surfaceContainerHigh = const Color(0xFFE0EBF4);

  final Color surfaceContainerHighest = const Color(0xFFD4E3EF);

  /// Subdued text — `hsl(206 24% 44%)` → #56748C
  final Color onSurfaceVariant = const Color(0xFF56748C);
}

@immutable
class _OutlinePalette {
  const _OutlinePalette();

  /// Border — `hsl(207 22% 82%)` → #C5D4E0
  final Color outline = const Color(0xFFC5D4E0);

  /// Input border — `hsl(210 18% 78%)` → #BCC9D4
  final Color outlineVariant = const Color(0xFFBCC9D4);
}

@immutable
class _InversePalette {
  const _InversePalette();

  final Color inverseSurface = const Color(0xFF1C2B3A);
  final Color onInverseSurface = const Color(0xFFF0F6FB);
  final Color inversePrimary = const Color(0xFF7EC8F0);
}

// --- Semantic states ----------------------------------------------------

@immutable
class _ErrorPalette {
  const _ErrorPalette();

  /// Pastel peach — `hsl(22 71% 86%)` → #F5D5C0
  final Color error = const Color(0xFFF5D5C0);

  /// Dark warm brown — `hsl(22 39% 39%)` → #8A5A3C
  final Color onError = const Color(0xFF8A5A3C);

  final Color errorContainer = const Color(0xFFFDEDE5);

  final Color onErrorContainer = const Color(0xFF8A5A3C);
}

@immutable
class _SuccessPalette {
  const _SuccessPalette();

  /// Pastel green — `hsl(124 36% 80%)` → #B8DEBB
  final Color success = const Color(0xFFB8DEBB);

  /// Dark forest green — `hsl(128 34% 27%)` → #2E5E34
  final Color onSuccess = const Color(0xFF2E5E34);

  /// Very light success wash — `hsl(128 36% 95%)` → #EDF7EE
  final Color successContainer = const Color(0xFFEDF7EE);

  final Color onSuccessContainer = const Color(0xFF2E5E34);
}

// --- Text ---------------------------------------------------------------

@immutable
class _TextPalette {
  const _TextPalette();

  Color get link => AppColors.Primary.primary;

  final Body = const _TextBodyPalette();
  final Inverse = const _TextInversePalette();
}

@immutable
class _TextBodyPalette {
  const _TextBodyPalette();

  Color get primary => AppColors.Surface.onSurface;
  Color get secondary => AppColors.Surface.onSurfaceVariant;
  Color get disabled => const Color(0x612A3A4E);
}

@immutable
class _TextInversePalette {
  const _TextInversePalette();

  Color get primary => AppColors.Inverse.onInverseSurface;
  Color get secondary => const Color(0xCCF0F6FB);
}

// --- Extra pastel / spectrum tones (visual names only) ------------------

@immutable
class _ExtraPalette {
  const _ExtraPalette();

  /// `hsl(250 45% 82%)` → #C5BBEC
  final Color purple = const Color(0xFFC5BBEC);

  /// `hsl(250 60% 95%)` → #EDEAF8
  final Color purpleLight = const Color(0xFFEDEAF8);

  /// `hsl(240 45% 85%)` → #C8C8EB
  final Color lavender = const Color(0xFFC8C8EB);

  /// `hsl(240 60% 96%)` → #EEEEF9
  final Color lavenderLight = const Color(0xFFEEEEF9);

  /// `hsl(240 30% 55%)` → #6B6BAA
  final Color lavenderDark = const Color(0xFF6B6BAA);

  /// `hsl(340 55% 88%)` → #F0C4D4
  final Color pink = const Color(0xFFF0C4D4);

  /// `hsl(340 70% 96%)` → #FCEEF3
  final Color pinkLight = const Color(0xFFFCEEF3);

  /// `hsl(180 35% 78%)` → #A8D4D4
  final Color teal = const Color(0xFFA8D4D4);

  /// `hsl(180 50% 94%)` → #E0F5F5
  final Color tealLight = const Color(0xFFE0F5F5);

  // --- Spectrum accents (hue names; no product semantics) ---------------

  final Color slate = const Color(0xFF94A3B8);
  final Color mint = const Color(0xFF6EE7B7);
  final Color sky = const Color(0xFF60A5FA);
  final Color violet = const Color(0xFFA78BFA);
  final Color amber = const Color(0xFFF5A623);
  final Color rose = const Color(0xFFE94560);
}

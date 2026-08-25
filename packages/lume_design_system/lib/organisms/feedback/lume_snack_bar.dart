import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

/// Semantic tone for [LumeSnackBar] / [showLumeSnackBar].
enum LumeSnackBarTrait {
  /// Green success tones.
  success,

  /// Yellow / gold caution tones.
  warning,

  /// Red / peach error tones.
  error,

  /// Brand blue informational tones.
  neutral,
}

OverlayEntry? _activeLumeSnackBarEntry;
Timer? _activeLumeSnackBarTimer;

/// Shows a toast-style snack bar anchored to the **top** of the screen.
///
/// Replaces any snack bar currently shown by this API. Auto-dismisses after
/// [duration] unless closed earlier via [hasCloseButton].
void showLumeSnackBar(
  BuildContext context, {
  required IconData icon,
  required String text,
  required LumeSnackBarTrait trait,
  bool hasCloseButton = false,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlayState =
      Overlay.maybeOf(context) ?? Navigator.maybeOf(context)?.overlay;
  if (overlayState == null) {
    return;
  }

  hideLumeSnackBar();

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => Positioned(
      left: AppSpacings.l,
      right: AppSpacings.l,
      top: 0,
      child: SafeArea(
        bottom: false,
        maintainBottomViewPadding: true,
        child: Semantics(
          liveRegion: true,
          child: LumeSnackBar(
            icon: icon,
            text: text,
            trait: trait,
            hasCloseButton: hasCloseButton,
            onClose: hideLumeSnackBar,
          ),
        ),
      ),
    ),
  );

  _activeLumeSnackBarEntry = entry;
  overlayState.insert(entry);

  _activeLumeSnackBarTimer = Timer(duration, () {
    if (_activeLumeSnackBarEntry == entry) {
      hideLumeSnackBar();
    }
  });
}

/// Removes the overlay inserted by [showLumeSnackBar], if any.
void hideLumeSnackBar() {
  _activeLumeSnackBarTimer?.cancel();
  _activeLumeSnackBarTimer = null;
  _activeLumeSnackBarEntry?.remove();
  _activeLumeSnackBarEntry = null;
}

/// Whether [showLumeSnackBar] currently has an active entry.
bool get isLumeSnackBarVisible => _activeLumeSnackBarEntry != null;

/// Clears overlay state — for tests only.
@visibleForTesting
void resetLumeSnackBarForTest() {
  hideLumeSnackBar();
}

/// Inline snack bar surface (icon + text + optional close).
///
/// Prefer [showLumeSnackBar] for toast presentation; use this widget directly
/// for layout previews (e.g. Widgetbook) and tests.
class LumeSnackBar extends StatelessWidget {
  const LumeSnackBar({
    super.key,
    required this.icon,
    required this.text,
    required this.trait,
    this.hasCloseButton = false,
    this.onClose,
  });

  final IconData icon;
  final String text;
  final LumeSnackBarTrait trait;
  final bool hasCloseButton;

  /// Called when the trailing close control is pressed.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final style = LumeSnackBarTraitStyle.resolve(trait);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.l,
          vertical: AppSpacings.m,
        ),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(
            color: style.borderColor,
            width: style.borderWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: style.foregroundColor, size: AppSizes.iconXs),
            const SizedBox(width: AppSpacings.s),
            Expanded(
              child: Text(
                text,
                style: typ.body4Medium.copyWith(
                  color: style.foregroundColor,
                  height: 1.35,
                ),
              ),
            ),
            if (hasCloseButton) ...[
              const SizedBox(width: AppSpacings.s),
              IconButton(
                onPressed: onClose,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  iconSize: AppSizes.iconXs,
                ),
                icon: Icon(Icons.close_rounded, color: style.foregroundColor),
                tooltip: 'Close',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Resolved colors for a [LumeSnackBarTrait].
@immutable
class LumeSnackBarTraitStyle {
  const LumeSnackBarTraitStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    this.borderWidth = 1,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final double borderWidth;

  static LumeSnackBarTraitStyle resolve(LumeSnackBarTrait trait) {
    return switch (trait) {
      LumeSnackBarTrait.success => LumeSnackBarTraitStyle(
        backgroundColor: AppColors.Success.successContainer,
        borderColor: AppColors.Success.success.withValues(alpha: 0.65),
        foregroundColor: AppColors.Success.onSuccess,
        borderWidth: 1.5,
      ),
      LumeSnackBarTrait.warning => LumeSnackBarTraitStyle(
        backgroundColor: AppColors.Accent.accentLight,
        borderColor: AppColors.Accent.accent.withValues(alpha: 0.65),
        foregroundColor: AppColors.Accent.onAccent,
        borderWidth: 1.5,
      ),
      LumeSnackBarTrait.error => LumeSnackBarTraitStyle(
        backgroundColor: AppColors.Error.errorContainer,
        borderColor: AppColors.Error.error.withValues(alpha: 0.7),
        foregroundColor: AppColors.Error.onError,
        borderWidth: 1.5,
      ),
      LumeSnackBarTrait.neutral => LumeSnackBarTraitStyle(
        backgroundColor: AppColors.Primary.primaryLight,
        borderColor: AppColors.Primary.primary.withValues(alpha: 0.45),
        foregroundColor: AppColors.Primary.onPrimaryContainer,
        borderWidth: 1.5,
      ),
    };
  }
}

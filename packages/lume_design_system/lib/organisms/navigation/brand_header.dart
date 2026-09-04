import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

/// Full-bleed brand chrome: primary background, rounded bottom, title + subtitle.
///
/// Applies a light [SystemUiOverlayStyle] so status-bar icons stay readable on
/// the primary surface, and pads the top with the status-bar inset by default.
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.includeStatusBarInset = true,
  });

  final String title;
  final String? subtitle;

  /// When true, top padding includes [MediaQuery] padding so content clears
  /// the status bar / notch.
  final bool includeStatusBarInset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = includeStatusBarInset
        ? MediaQuery.paddingOf(context).top
        : 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSpacings.xl2,
          topInset + AppSpacings.xl2,
          AppSpacings.xl2,
          AppSpacings.xl3,
        ),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppRadius.xl3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: typ.body1Semibold.copyWith(color: cs.onPrimary),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacings.xs),
              Text(
                subtitle!,
                style: typ.body4Light.copyWith(
                  color: cs.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

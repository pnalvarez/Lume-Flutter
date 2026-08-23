import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

/// Tappable chip with an optional top-trailing badge (e.g. pair number).
///
/// Colors are provided by the caller so features can map domain states to UI.
class BadgeChip extends StatelessWidget {
  const BadgeChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    this.badgeLabel,
    this.badgeBackgroundColor,
    this.badgeForegroundColor,
    this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  /// Top-trailing badge text (typically a number). Null hides the badge.
  final String? badgeLabel;
  final Color? badgeBackgroundColor;
  final Color? badgeForegroundColor;
  final VoidCallback? onTap;

  static const double _badgeSize = 22;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.l);
    final hasBadge = badgeLabel != null && badgeLabel!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        top: hasBadge ? AppSpacings.s : 0,
        right: hasBadge ? AppSpacings.s : 0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: borderColor, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.m,
                  vertical: AppSpacings.m,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: typ.body3Medium.copyWith(color: foregroundColor),
                  ),
                ),
              ),
            ),
          ),
          if (hasBadge)
            Positioned(
              top: -AppSpacings.s,
              right: -AppSpacings.s,
              child: Container(
                width: _badgeSize,
                height: _badgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeBackgroundColor ?? cs.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 1.5),
                ),
                child: Text(
                  badgeLabel!,
                  style: typ.tagS.copyWith(
                    color: badgeForegroundColor ?? cs.onSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

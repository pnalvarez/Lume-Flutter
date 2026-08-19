import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:flutter/material.dart';

/// Shows a themed modal dialog. Returns the value passed to [Navigator.pop].
Future<T?> showLumeDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) {
  final cs = Theme.of(context).colorScheme;
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => AlertDialog(
      backgroundColor: cs.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        side: BorderSide(color: cs.outline),
      ),
      title: Text(title, style: typ.subtitleM.copyWith(color: cs.onSurface)),
      content: content,
      actions: actions,
    ),
  );
}

/// Centered celebration / confirm sheet with icon well, copy and CTA.
///
/// All strings and the icon are provided by the caller.
class CelebrationDialog extends StatelessWidget {
  final Widget? hero;
  final IconData? icon;
  final Color? iconBackground;
  final String title;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onClose;
  final Color? accentBorder;

  const CelebrationDialog({
    super.key,
    this.hero,
    this.icon,
    this.iconBackground,
    required this.title,
    this.subtitle,
    required this.actionLabel,
    required this.onAction,
    this.onClose,
    this.accentBorder,
  });

  /// Presents [CelebrationDialog] as a modal barrier dialog.
  static Future<void> show(
    BuildContext context, {
    Widget? hero,
    IconData? icon,
    Color? iconBackground,
    required String title,
    String? subtitle,
    required String actionLabel,
    required VoidCallback onAction,
    VoidCallback? onClose,
    Color? accentBorder,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => CelebrationDialog(
        hero: hero,
        icon: icon,
        iconBackground: iconBackground,
        title: title,
        subtitle: subtitle,
        actionLabel: actionLabel,
        accentBorder: accentBorder,
        onClose: onClose ?? () => Navigator.of(ctx).pop(),
        onAction: () {
          Navigator.of(ctx).pop();
          onAction();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacings.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: Border.all(
            color: accentBorder ?? cs.outline,
            width: accentBorder == null ? 1 : 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hero != null)
                  hero!
                else if (icon != null)
                  Container(
                    width: AppSizes.mediaWellM,
                    height: AppSizes.mediaWellM,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          iconBackground ?? cs.tertiary,
                          cs.secondary,
                        ],
                      ),
                    ),
                    child: Icon(icon, color: cs.onPrimary, size: AppSizes.iconL),
                  ),
                const SizedBox(height: AppSpacings.m),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: typ.headlineXs.copyWith(color: cs.onSurface),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacings.s),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: AppSpacings.xl),
                LumeButton(
                  label: actionLabel,
                  onPressed: onAction,
                  isExpanded: true,
                ),
              ],
            ),
            if (onClose != null)
              Positioned(
                top: 0,
                right: 0,
                child: LumeIconButton(
                  icon: Icons.close_rounded,
                  size: LumeIconButtonSize.sm,
                  onPressed: onClose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

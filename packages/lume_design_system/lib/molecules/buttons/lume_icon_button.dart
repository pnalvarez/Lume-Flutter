import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:flutter/material.dart';

/// Icon button size.
enum LumeIconButtonSize { sm, md, lg }

/// Icon button variant.
enum LumeIconButtonVariant { filled, outline, ghost }

/// Circular icon-only button for toolbars and compact actions.
class LumeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final LumeIconButtonSize size;
  final LumeIconButtonVariant variant;
  final String? tooltip;
  final Color? iconColor;
  final Color? backgroundColor;

  const LumeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = LumeIconButtonSize.md,
    this.variant = LumeIconButtonVariant.ghost,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
  });

  double get _side => switch (size) {
        LumeIconButtonSize.sm => AppSizes.touchMin * 0.75, // 36
        LumeIconButtonSize.md => AppSizes.touchMin, // 48
        LumeIconButtonSize.lg => AppSizes.touchComfort, // 56
      };

  double get _iconSize => switch (size) {
        LumeIconButtonSize.sm => AppSizes.iconS,
        LumeIconButtonSize.md => AppSizes.iconM,
        LumeIconButtonSize.lg => AppSizes.iconL,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.full(_side));

    final (Color bg, Color fg, BorderSide? side) = switch (variant) {
      LumeIconButtonVariant.filled => (
          backgroundColor ?? cs.primary,
          iconColor ?? cs.onPrimary,
          null,
        ),
      LumeIconButtonVariant.outline => (
          Colors.transparent,
          iconColor ?? cs.primary,
          BorderSide(color: cs.primary),
        ),
      LumeIconButtonVariant.ghost => (
          Colors.transparent,
          iconColor ?? cs.onSurface,
          null,
        ),
    };

    final button = Material(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: radius, side: side ?? BorderSide.none),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: SizedBox.square(
          dimension: _side,
          child: Icon(icon, size: _iconSize, color: fg),
        ),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Button variant.
enum LumeButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  link,
}

/// Button size.
enum LumeButtonSize {
  sm,
  md,
  lg,
}

/// Lume design system button.
///
/// Stateless — all state (loading, disabled) is driven from the outside.
/// Mirrors [shadcn/ui Button] variants and the Auror [PrimaryButton] patterns.
///
/// ```dart
/// LumeButton(
///   label: 'Continuar',
///   onPressed: () {},
/// )
/// ```
class LumeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final LumeButtonVariant variant;
  final LumeButtonSize size;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const LumeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = LumeButtonVariant.primary,
    this.size = LumeButtonSize.md,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveOnPressed = (isLoading || onPressed == null) ? null : onPressed;

    final style = _buildStyle(cs);
    final content = _buildContent(cs);

    return switch (variant) {
      LumeButtonVariant.link => TextButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: content,
        ),
      LumeButtonVariant.ghost ||
      LumeButtonVariant.outline =>
        OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: content,
        ),
      _ => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: content,
        ),
    };
  }

  ButtonStyle _buildStyle(ColorScheme cs) {
    final (hPad, vPad) = switch (size) {
      LumeButtonSize.sm => (16.0, 8.0),
      LumeButtonSize.md => (24.0, 14.0),
      LumeButtonSize.lg => (32.0, 18.0),
    };

    final radius = BorderRadius.circular(AppRadius.l);

    return switch (variant) {
      LumeButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.surfaceContainerHighest,
          disabledForegroundColor: cs.onSurfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ),
      LumeButtonVariant.secondary => ElevatedButton.styleFrom(
          backgroundColor: cs.secondaryContainer,
          foregroundColor: cs.onSecondaryContainer,
          disabledBackgroundColor: cs.surfaceContainerHighest,
          disabledForegroundColor: cs.onSurfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ),
      LumeButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.primary),
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ),
      LumeButtonVariant.ghost => OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ),
      LumeButtonVariant.destructive => ElevatedButton.styleFrom(
          backgroundColor: cs.error,
          foregroundColor: cs.onError,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ),
      LumeButtonVariant.link => TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: EdgeInsets.symmetric(horizontal: hPad / 2, vertical: vPad / 2),
          textStyle: _textStyle.copyWith(decoration: TextDecoration.underline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s)),
        ),
    };
  }

  TextStyle get _textStyle => typ.body3Medium;

  Widget _buildContent(ColorScheme cs) {
    if (isLoading) {
      final dim = switch (size) {
        LumeButtonSize.sm => 14.0,
        LumeButtonSize.md => 18.0,
        LumeButtonSize.lg => 22.0,
      };
      return SizedBox.square(
        dimension: dim,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            variant == LumeButtonVariant.outline ||
                    variant == LumeButtonVariant.ghost ||
                    variant == LumeButtonVariant.link
                ? cs.primary
                : cs.onPrimary,
          ),
        ),
      );
    }

    if (leadingIcon == null && trailingIcon == null) return Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
        Text(label),
        if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
      ],
    );
  }
}

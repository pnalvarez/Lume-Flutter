import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Color intent of the button.
enum LumeButtonTrait {
  /// Brand sky blue (`ColorScheme.primary`).
  brand,

  /// Strong companion blue (`ColorScheme.secondary`).
  secondary,

  /// Positive / confirm (`AppColors.Success`).
  success,

  /// Danger / irreversible (`ColorScheme.error`).
  destructive,
}

/// Visual structure of the button, independent of [LumeButtonTrait].
enum LumeButtonType {
  /// Filled, high emphasis.
  elevated,

  /// Stroked, medium emphasis.
  outlined,

  /// Plain label with button padding, no underline.
  text,

  /// Compact hyperlink treatment (underlined).
  link,
}

/// Button size.
enum LumeButtonSize { sm, md, lg }

/// Lume design system button.
///
/// Combine [trait] (what it means) with [type] (how it looks).
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
  final LumeButtonTrait trait;
  final LumeButtonType type;
  final LumeButtonSize size;
  final bool isLoading;
  final bool isEnabled;

  /// When true, the button fills the available width.
  final bool isExpanded;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const LumeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trait = LumeButtonTrait.brand,
    this.type = LumeButtonType.elevated,
    this.size = LumeButtonSize.md,
    this.isLoading = false,
    this.isEnabled = true,
    this.isExpanded = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = _TraitColors.of(cs, trait);
    final visuallyEnabled = isEnabled;
    final effectiveOnPressed = !visuallyEnabled
        ? null
        : isLoading
        ? () {}
        : onPressed;

    final style = _buildStyle(colors);
    final content = _buildContent(colors);

    Widget button = switch (type) {
      LumeButtonType.link || LumeButtonType.text => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      LumeButtonType.outlined => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      LumeButtonType.elevated => ElevatedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
    };

    if (isLoading) {
      button = IgnorePointer(child: button);
    }

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return Align(
      alignment: Alignment.center,
      widthFactor: 1,
      heightFactor: 1,
      child: button,
    );
  }

  ButtonStyle _buildStyle(_TraitColors colors) {
    final (hPad, vPad) = switch (size) {
      LumeButtonSize.sm => (16.0, 8.0),
      LumeButtonSize.md => (24.0, 14.0),
      LumeButtonSize.lg => (32.0, 18.0),
    };

    final radius = BorderRadius.circular(AppRadius.l);
    final compactRadius = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.s),
    );
    final filledRadius = RoundedRectangleBorder(borderRadius: radius);

    return switch (type) {
      LumeButtonType.elevated => ElevatedButton.styleFrom(
        backgroundColor: colors.fill,
        foregroundColor: colors.onFill,
        disabledBackgroundColor: colors.disabledFill,
        disabledForegroundColor: colors.disabledOnFill,
        elevation: 0,
        shape: filledRadius,
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        textStyle: _textStyle,
      ),
      LumeButtonType.outlined =>
        OutlinedButton.styleFrom(
          foregroundColor: colors.accent,
          disabledForegroundColor: colors.disabledAccent,
          shape: filledRadius,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          textStyle: _textStyle,
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.disabled)
                ? colors.disabledBorder
                : colors.accent;
            return BorderSide(color: color);
          }),
        ),
      LumeButtonType.text => TextButton.styleFrom(
        foregroundColor: colors.accent,
        disabledForegroundColor: colors.disabledAccent,
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        textStyle: _textStyle,
        shape: filledRadius,
      ),
      LumeButtonType.link => TextButton.styleFrom(
        foregroundColor: colors.accent,
        disabledForegroundColor: colors.disabledAccent,
        padding: EdgeInsets.symmetric(horizontal: hPad / 2, vertical: vPad / 2),
        textStyle: _textStyle,
        shape: compactRadius,
      ),
    };
  }

  TextStyle get _textStyle {
    if (type == LumeButtonType.link) {
      final base = switch (size) {
        LumeButtonSize.sm => typ.body4Medium,
        LumeButtonSize.md || LumeButtonSize.lg => typ.body3Medium,
      };
      return base.copyWith(decoration: TextDecoration.underline);
    }
    return typ.body3Medium;
  }

  Widget _buildContent(_TraitColors colors) {
    if (isLoading) {
      final dim = switch (size) {
        LumeButtonSize.sm => 14.0,
        LumeButtonSize.md => 18.0,
        LumeButtonSize.lg => 22.0,
      };
      final spinner = SizedBox.square(
        dimension: dim,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            type == LumeButtonType.elevated ? colors.onFill : colors.accent,
          ),
        ),
      );
      if (!isExpanded) return spinner;
      return SizedBox(
        width: double.infinity,
        child: Center(child: spinner),
      );
    }

    if (leadingIcon == null && trailingIcon == null) return Text(label);

    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
        Text(label),
        if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
      ],
    );
  }
}

class _TraitColors {
  final Color fill;
  final Color onFill;
  final Color accent;
  final Color disabledFill;
  final Color disabledOnFill;
  final Color disabledAccent;
  final Color disabledBorder;

  const _TraitColors({
    required this.fill,
    required this.onFill,
    required this.accent,
    required this.disabledFill,
    required this.disabledOnFill,
    required this.disabledAccent,
    required this.disabledBorder,
  });

  factory _TraitColors.of(ColorScheme cs, LumeButtonTrait trait) {
    final muted = cs.onSurface.withValues(alpha: 0.38);
    final disabledFill = cs.surfaceContainerHighest;
    final disabledBorder = cs.outline.withValues(alpha: 0.35);

    return switch (trait) {
      LumeButtonTrait.brand => _TraitColors(
        fill: cs.primary,
        onFill: cs.onPrimary,
        accent: cs.primary,
        disabledFill: disabledFill,
        disabledOnFill: muted,
        disabledAccent: muted,
        disabledBorder: disabledBorder,
      ),
      LumeButtonTrait.secondary => _TraitColors(
        fill: cs.secondary,
        onFill: cs.onSecondary,
        accent: cs.secondary,
        disabledFill: disabledFill,
        disabledOnFill: muted,
        disabledAccent: muted,
        disabledBorder: disabledBorder,
      ),
      LumeButtonTrait.success => _TraitColors(
        fill: AppColors.Success.success,
        onFill: AppColors.Success.onSuccess,
        accent: AppColors.Success.onSuccess,
        disabledFill: disabledFill,
        disabledOnFill: muted,
        disabledAccent: muted,
        disabledBorder: disabledBorder,
      ),
      LumeButtonTrait.destructive => _TraitColors(
        fill: cs.error,
        onFill: cs.onError,
        accent: cs.onError,
        disabledFill: disabledFill,
        disabledOnFill: muted,
        disabledAccent: muted,
        disabledBorder: disabledBorder,
      ),
    };
  }
}

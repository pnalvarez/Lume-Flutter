import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Text field following Lume / shadcn Input patterns.
///
/// Stateless regarding value — [controller] and [onChanged] are owned by the caller.
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final String? errorMessage;
  final bool isEnabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;

  const InputField({
    super.key,
    this.label = '',
    required this.controller,
    required this.onChanged,
    this.placeholder = '',
    this.errorMessage,
    this.isEnabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
  });

  bool get _hasError => errorMessage != null && errorMessage!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final outline = _hasError ? cs.error : cs.outlineVariant;
    final focused = _hasError ? cs.error : cs.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: typ.tagS.copyWith(
              color: _hasError ? cs.error : cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacings.xs),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: isEnabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          onChanged: onChanged,
          style: typ.body4Light.copyWith(
            color: isEnabled
                ? cs.onSurface
                : cs.onSurface.withValues(alpha: 0.38),
          ),
          cursorColor: cs.primary,
          decoration: InputDecoration(
            hintText: placeholder.isEmpty ? null : placeholder,
            hintStyle: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            filled: true,
            fillColor: isEnabled
                ? cs.surfaceContainerLow
                : cs.surfaceContainerLow.withValues(alpha: 0.72),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.m,
            ),
            border: _border(outline),
            enabledBorder: _border(outline),
            focusedBorder: _border(focused, width: 2),
            errorBorder: _border(cs.error),
            focusedErrorBorder: _border(cs.error, width: 2),
            disabledBorder: _border(cs.outline.withValues(alpha: 0.35)),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacings.xs),
          Text(errorMessage!, style: typ.tagXS.copyWith(color: cs.error)),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
        borderSide: BorderSide(color: color, width: width),
      );
}

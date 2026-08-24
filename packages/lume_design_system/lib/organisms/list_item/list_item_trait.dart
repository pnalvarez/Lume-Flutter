import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';

/// Semantic surface for [ListItem]: border, fill, and typography tints.
enum ListItemTrait {
  /// Default list surface — theme container + outline.
  neutral,

  /// Brand / primary emphasis.
  brand,

  /// Soft companion accent.
  secondary,

  /// Positive / completed.
  success,

  /// Caution / attention.
  warning,

  /// Destructive / error / blocked.
  destructive,
}

/// Resolved colors for a [ListItemTrait] on the current [ColorScheme].
@immutable
class ListItemTraitStyle {
  const ListItemTraitStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleTextColor,
    required this.bodyTextColor,
    required this.leadingIconColor,
    required this.trailingIconColor,
    required this.accentColor,
    this.borderWidth = 1,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color titleTextColor;
  final Color bodyTextColor;
  final Color leadingIconColor;
  final Color trailingIconColor;

  /// Left accent bar / status accents inside layouts.
  final Color accentColor;
  final double borderWidth;

  static ListItemTraitStyle resolve(ListItemTrait trait, ColorScheme scheme) {
    return switch (trait) {
      ListItemTrait.neutral => ListItemTraitStyle(
        backgroundColor: scheme.surfaceContainerLowest,
        borderColor: scheme.outline.withValues(alpha: 0.55),
        titleTextColor: scheme.onSurface,
        bodyTextColor: scheme.onSurfaceVariant,
        leadingIconColor: scheme.onSurface,
        trailingIconColor: scheme.onSurfaceVariant,
        accentColor: scheme.primary,
      ),
      ListItemTrait.brand => ListItemTraitStyle(
        backgroundColor: scheme.surfaceContainerLowest,
        borderColor: scheme.primaryContainer,
        titleTextColor: scheme.onSurface,
        bodyTextColor: scheme.secondary,
        leadingIconColor: scheme.primary,
        trailingIconColor: scheme.primary,
        accentColor: scheme.primary,
        borderWidth: 1.5,
      ),
      ListItemTrait.secondary => ListItemTraitStyle(
        backgroundColor: AppColors.Surface.onContainer,
        borderColor: scheme.outline,
        titleTextColor: scheme.onSurface,
        bodyTextColor: scheme.onSurfaceVariant,
        leadingIconColor: scheme.secondary,
        trailingIconColor: scheme.secondary,
        accentColor: scheme.secondary,
      ),
      ListItemTrait.success => ListItemTraitStyle(
        backgroundColor: AppColors.Success.successContainer,
        borderColor: AppColors.Success.success.withValues(alpha: 0.55),
        titleTextColor: AppColors.Success.onSuccess,
        bodyTextColor: AppColors.Success.onSuccessContainer,
        leadingIconColor: AppColors.Success.onSuccess,
        trailingIconColor: AppColors.Success.onSuccess,
        accentColor: AppColors.Success.onSuccess,
        borderWidth: 2,
      ),
      ListItemTrait.warning => ListItemTraitStyle(
        backgroundColor: AppColors.Accent.accentLight,
        borderColor: AppColors.Accent.accent.withValues(alpha: 0.55),
        titleTextColor: AppColors.Accent.onAccent,
        bodyTextColor: AppColors.Accent.onAccent,
        leadingIconColor: AppColors.Accent.onAccent,
        trailingIconColor: AppColors.Accent.onAccent,
        accentColor: AppColors.Accent.onAccent,
        borderWidth: 2,
      ),
      ListItemTrait.destructive => ListItemTraitStyle(
        backgroundColor: AppColors.Error.errorContainer,
        borderColor: AppColors.Error.error.withValues(alpha: 0.55),
        titleTextColor: AppColors.Error.onError,
        bodyTextColor: AppColors.Error.onErrorContainer,
        leadingIconColor: AppColors.Error.onError,
        trailingIconColor: AppColors.Error.onError,
        accentColor: AppColors.Error.onError,
        borderWidth: 2,
      ),
    };
  }
}

/// Provides [ListItemTraitStyle] to [ListItem] content.
class ListItemTraitScope extends InheritedWidget {
  const ListItemTraitScope({
    super.key,
    required this.style,
    required super.child,
  });

  final ListItemTraitStyle style;

  /// Resolves style from an ancestor scope; falls back to [ListItemTrait.neutral].
  static ListItemTraitStyle of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ListItemTraitScope>();
    if (scope != null) {
      return scope.style;
    }
    final scheme = Theme.of(context).colorScheme;
    return ListItemTraitStyle.resolve(ListItemTrait.neutral, scheme);
  }

  @override
  bool updateShouldNotify(ListItemTraitScope oldWidget) =>
      style != oldWidget.style;
}

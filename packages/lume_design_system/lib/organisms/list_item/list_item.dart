import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/list_item/list_item_trait.dart';

export 'list_item_trait.dart';

const double _kListItemDisabledOpacity = 0.5;

/// Input model for [ListItem]: each subtype defines the inner layout; the shell
/// applies padding, surface, border, and tap behavior.
abstract class ListItemInput {
  ListItemInput();

  Widget buildContent(BuildContext context);
}

/// Single text block with optional bold [label] prefix and trailing icon.
class TextInput extends ListItemInput {
  TextInput({required this.text, this.label, this.trailingIcon});

  /// Optional leading label rendered in semibold (e.g. "Dica:").
  final String? label;
  final String text;
  final IconData? trailingIcon;

  @override
  Widget buildContent(BuildContext context) {
    final traitStyle = ListItemTraitScope.of(context);
    final baseStyle = typ.body4Medium.copyWith(
      color: traitStyle.titleTextColor,
    );
    final hasLabel = label != null && label!.trim().isNotEmpty;

    final body = hasLabel
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: typ.body4Semibold.copyWith(
                    color: traitStyle.titleTextColor,
                  ),
                ),
                TextSpan(text: text, style: baseStyle),
              ],
            ),
          )
        : Text(text, style: baseStyle);

    if (trailingIcon == null) {
      return body;
    }
    return Row(
      children: [
        Expanded(child: body),
        const SizedBox(width: AppSpacings.s),
        Icon(
          trailingIcon,
          size: AppSizes.iconS,
          color: traitStyle.trailingIconColor,
        ),
      ],
    );
  }
}

/// Horizontal row: leading icon, title + optional description, optional chevron.
class IconTitleDescriptionInput extends ListItemInput {
  IconTitleDescriptionInput({
    required this.leadingIcon,
    required this.title,
    this.description,
    this.showTrailing = true,
    this.leadingIconColor,
  });

  final IconData leadingIcon;
  final String title;
  final String? description;
  final bool showTrailing;
  final Color? leadingIconColor;

  @override
  Widget buildContent(BuildContext context) {
    final traitStyle = ListItemTraitScope.of(context);
    final hasDescription =
        description != null && description!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          leadingIcon,
          size: AppSizes.iconM,
          color: leadingIconColor ?? traitStyle.leadingIconColor,
        ),
        const SizedBox(width: AppSpacings.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typ.body3Semibold.copyWith(
                  color: traitStyle.titleTextColor,
                  height: 1.2,
                ),
              ),
              if (hasDescription) ...[
                const SizedBox(height: AppSpacings.xs),
                Text(
                  description!.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typ.body4Light.copyWith(
                    color: traitStyle.bodyTextColor,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showTrailing) ...[
          const SizedBox(width: AppSpacings.s),
          Icon(
            Icons.chevron_right_rounded,
            size: 22,
            color: traitStyle.trailingIconColor,
          ),
        ],
      ],
    );
  }
}

/// Leading widget, title, optional caption, optional progress, optional trailing.
class LeadingTitleCaptionInput extends ListItemInput {
  LeadingTitleCaptionInput({
    required this.leading,
    required this.title,
    this.caption,
    this.progress,
    this.showTrailing = true,
    this.trailingIcon,
  });

  final Widget leading;
  final String title;
  final String? caption;

  /// Progress in \[0.0, 1.0\]. When null, no bar is shown.
  final double? progress;
  final bool showTrailing;
  final IconData? trailingIcon;

  @override
  Widget buildContent(BuildContext context) {
    final traitStyle = ListItemTraitScope.of(context);
    final hasCaption = caption != null && caption!.trim().isNotEmpty;

    return Row(
      children: [
        leading,
        const SizedBox(width: AppSpacings.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typ.body3Semibold.copyWith(
                  color: traitStyle.titleTextColor,
                ),
              ),
              if (hasCaption) ...[
                const SizedBox(height: AppSpacings.xs),
                Text(
                  caption!.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typ.tagS.copyWith(
                    color: traitStyle.bodyTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (progress != null) ...[
                const SizedBox(height: AppSpacings.s),
                LumeProgressBar(
                  value: progress!.clamp(0.0, 1.0),
                  height: 4,
                  showPercentage: false,
                  fillColor: traitStyle.accentColor,
                ),
              ],
            ],
          ),
        ),
        if (showTrailing) ...[
          const SizedBox(width: AppSpacings.s),
          Icon(
            trailingIcon ?? Icons.chevron_right_rounded,
            size: 22,
            color: traitStyle.trailingIconColor,
          ),
        ],
      ],
    );
  }
}

/// Title, caption, trailing icon; optional left accent bar.
class TitleCaptionTrailingInput extends ListItemInput {
  TitleCaptionTrailingInput({
    required this.title,
    this.caption,
    this.hint,
    this.hintColor,
    this.trailingIcon,
    this.trailingIconColor,
    this.showAccentBar = false,
    this.accentColor,
  });

  final String title;
  final String? caption;

  /// Optional second line under [caption] (e.g. unlock / retry guidance).
  final String? hint;
  final Color? hintColor;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final bool showAccentBar;
  final Color? accentColor;

  @override
  Widget buildContent(BuildContext context) {
    final traitStyle = ListItemTraitScope.of(context);
    final accent = accentColor ?? traitStyle.accentColor;
    final hasCaption = caption != null && caption!.trim().isNotEmpty;
    final hintText = hint?.trim();
    final hasHint = hintText != null && hintText.isNotEmpty;

    // Owns its own padding so an accent bar can sit flush with the shell edge.
    final body = Padding(
      padding: EdgeInsets.fromLTRB(
        showAccentBar ? AppSpacings.m : AppSpacings.l,
        AppSpacings.m,
        AppSpacings.l,
        AppSpacings.m,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typ.body3Semibold.copyWith(
                    color: traitStyle.titleTextColor,
                  ),
                ),
                if (hasCaption) ...[
                  const SizedBox(height: AppSpacings.xs),
                  Text(
                    caption!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typ.tagS.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (hasHint) ...[
                  const SizedBox(height: AppSpacings.xs),
                  Text(
                    hintText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: typ.tagS.copyWith(
                      color: hintColor ?? accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppSpacings.s),
            Icon(
              trailingIcon,
              size: 22,
              color: trailingIconColor ?? traitStyle.trailingIconColor,
            ),
          ],
        ],
      ),
    );

    if (!showAccentBar) {
      return body;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: AppSizes.connectorWidth,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadius.l),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Leading media, title, description, status, optional progress and CTA.
class LeadingTitleDescriptionStatusCtaInput extends ListItemInput {
  LeadingTitleDescriptionStatusCtaInput({
    this.leading,
    this.leadingBackground,
    this.leadingRing,
    required this.title,
    this.description,
    this.statusLabel,
    this.statusColor,
    this.statusIcon,
    this.progress,
    this.progressCaption,
    this.actionLabel,
    this.onAction,
    this.actionSecondary = false,
  });

  final Widget? leading;
  final Color? leadingBackground;
  final Color? leadingRing;
  final String title;
  final String? description;
  final String? statusLabel;
  final Color? statusColor;
  final IconData? statusIcon;
  final double? progress;
  final String? progressCaption;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionSecondary;

  @override
  Widget buildContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final traitStyle = ListItemTraitScope.of(context);
    final statusFg = statusColor ?? traitStyle.bodyTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              Container(
                width: AppSizes.mediaWellS,
                height: AppSizes.mediaWellS,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: leadingBackground ?? cs.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: leadingRing == null
                      ? null
                      : [
                          BoxShadow(
                            color: leadingRing!.withValues(alpha: 0.4),
                            blurRadius: 0,
                            spreadRadius: 2,
                          ),
                        ],
                ),
                child: leading,
              ),
              const SizedBox(width: AppSpacings.m),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typ.body3Semibold.copyWith(
                      color: traitStyle.titleTextColor,
                    ),
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacings.xs),
                    Text(
                      description!,
                      style: typ.body4Light.copyWith(
                        color: traitStyle.bodyTextColor,
                      ),
                    ),
                  ],
                  if (statusLabel != null) ...[
                    const SizedBox(height: AppSpacings.s),
                    Row(
                      children: [
                        if (statusIcon != null) ...[
                          Icon(statusIcon, size: 12, color: statusFg),
                          const SizedBox(width: AppSpacings.xs2),
                        ],
                        Flexible(
                          child: Text(
                            statusLabel!,
                            style: typ.tagS.copyWith(
                              color: statusFg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (progress != null) ...[
                    const SizedBox(height: AppSpacings.s),
                    LumeProgressBar(
                      value: progress!.clamp(0.0, 1.0),
                      label: progressCaption,
                      height: 6,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: AppSpacings.l),
          LumeButton(
            label: actionLabel!,
            onPressed: onAction,
            isExpanded: true,
            trait: actionSecondary
                ? LumeButtonTrait.secondary
                : LumeButtonTrait.brand,
          ),
        ],
      ],
    );
  }
}

/// Section chrome: full-bleed header band + nested children (often [ListItem]s).
class HeaderChildrenInput extends ListItemInput {
  HeaderChildrenInput({
    required this.title,
    required this.children,
    this.leading,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.childrenPadding = const EdgeInsets.all(AppSpacings.m),
    this.childrenSpacing = AppSpacings.s,
  });

  final String title;
  final Widget? leading;
  final Color? headerBackgroundColor;
  final Color? headerForegroundColor;
  final List<Widget> children;
  final EdgeInsetsGeometry childrenPadding;
  final double childrenSpacing;

  @override
  Widget buildContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final traitStyle = ListItemTraitScope.of(context);
    final headerBg = headerBackgroundColor ?? cs.surfaceContainerHighest;
    final headerFg = headerForegroundColor ?? traitStyle.titleTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ColoredBox(
          color: headerBg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.m,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacings.s),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: typ.body4Semibold.copyWith(color: headerFg),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (children.isNotEmpty)
          Padding(
            padding: childrenPadding,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) SizedBox(height: childrenSpacing),
                  children[i],
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Escape hatch: wrap any [Widget] as a [ListItem] body.
class GenericListItemInput extends ListItemInput {
  GenericListItemInput({required this.child});

  final Widget child;

  @override
  Widget buildContent(BuildContext context) => child;
}

/// Card shell around a [ListItemInput]; dispatches layout via
/// [ListItemInput.buildContent].
class ListItem extends StatelessWidget {
  // Non-const so [ListItemInput] models can evolve without hot-reload failures.
  // ignore: prefer_const_constructors_in_immutables
  ListItem({
    super.key,
    required this.input,
    this.trait = ListItemTrait.neutral,
    this.isExpanded = false,
    this.onTap,
    this.padding,
    this.isSelected = false,
    this.isEnabled = true,
    this.borderRadius,
    this.showShadow = false,
  });

  final ListItemInput input;

  /// Border, background, and default text/icon colors.
  final ListItemTrait trait;

  final bool isExpanded;
  final VoidCallback? onTap;

  /// Defaults to horizontal [AppSpacings.l], vertical [AppSpacings.m].
  /// Use [EdgeInsets.zero] for full-bleed headers ([HeaderChildrenInput]).
  final EdgeInsetsGeometry? padding;

  /// Highlights the card border with [ColorScheme.primary].
  final bool isSelected;

  /// When false, content is drawn at reduced opacity and [onTap] is ignored.
  final bool isEnabled;

  /// Defaults to [AppRadius.l].
  final double? borderRadius;

  /// Soft drop shadow under the shell.
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final traitStyle = ListItemTraitStyle.resolve(trait, scheme);
    final radius = borderRadius ?? AppRadius.l;
    final resolvedPadding =
        padding ??
        const EdgeInsets.symmetric(
          horizontal: AppSpacings.l,
          vertical: AppSpacings.m,
        );

    Widget body(BuildContext rowContext) {
      return Padding(
        padding: resolvedPadding,
        child: input.buildContent(rowContext),
      );
    }

    Widget content = isExpanded
        ? SizedBox(
            width: double.infinity,
            child: Builder(builder: body),
          )
        : Builder(builder: body);

    if (!isEnabled) {
      content = Opacity(opacity: _kListItemDisabledOpacity, child: content);
    }

    return ListItemTraitScope(
      style: traitStyle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: traitStyle.backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isSelected ? scheme.primary : traitStyle.borderColor,
            width: isSelected ? 2 : traitStyle.borderWidth,
          ),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: scheme.onSurface.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(radius),
            child: content,
          ),
        ),
      ),
    );
  }
}

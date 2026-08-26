import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/molecules/badges/amount_badge.dart';
import 'package:lume_design_system/molecules/badges/lume_badge.dart';
import 'package:lume_design_system/molecules/badges/sparkling_badge.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All variants', type: LumeBadge)
Widget lumeBadgeAll(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final v in LumeBadgeVariant.values)
            LumeBadge(
              label: v.name,
              variant: v,
              leadingIcon: Icons.star_rounded,
            ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Custom colors', type: LumeBadge)
Widget lumeBadgeCustomColors(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Aprendendo',
  );
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          LumeBadge(
            label: label,
            leadingIcon: Icons.school_rounded,
            backgroundColor: AppColors.Accent.accentLight,
            foregroundColor: AppColors.Accent.onAccent,
            borderColor: AppColors.Accent.accent.withValues(alpha: 0.35),
          ),
          LumeBadge(
            label: 'Épico',
            leadingIcon: Icons.diamond_rounded,
            backgroundColor: AppColors.Extra.violet.withValues(alpha: 0.15),
            foregroundColor: AppColors.Extra.violet,
            borderColor: AppColors.Extra.violet.withValues(alpha: 0.45),
          ),
          LumeBadge(
            label: 'Revisão',
            leadingIcon: Icons.refresh_rounded,
            backgroundColor: AppColors.Secondary.secondary.withValues(
              alpha: 0.12,
            ),
            foregroundColor: AppColors.Secondary.secondary,
            borderColor: AppColors.Secondary.secondary.withValues(alpha: 0.3),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: AmountBadge)
Widget amountBadgeInteractive(BuildContext context) {
  final text = context.knobs.string(label: 'Text', initialValue: '+15 XP');
  final secondary = context.knobs.string(
    label: 'Secondary',
    initialValue: 'Quiz concluído',
  );

  return Scaffold(
    body: Center(
      child: AmountBadge(
        text: text,
        secondaryText: secondary.isEmpty ? null : secondary,
        icon: Icons.bolt_rounded,
        accentColor: AppColors.Accent.accent,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: SparklingBadge)
Widget sparklingBadgeInteractive(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Dias seguidos',
  );
  final description = context.knobs.string(
    label: 'Description',
    initialValue: '0 dias',
  );
  final variant = context.knobs.object.dropdown(
    label: 'Variant',
    options: SparklingBadgeVariant.values,
    labelBuilder: (v) => v.name,
  );
  final leadingIcon = context.knobs.object.dropdown(
    label: 'Icon',
    options: SparklingBadgeIcon.values,
    initialOption: SparklingBadgeIcon.flame,
    labelBuilder: (v) => v.name,
  );

  return Scaffold(
    body: Center(
      child: SparklingBadge(
        title: title,
        description: description,
        variant: variant,
        leadingIcon: leadingIcon,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All variants', type: SparklingBadge)
Widget sparklingBadgeAllVariants(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final variant in SparklingBadgeVariant.values)
            SparklingBadge(
              title: variant.name,
              description: '0 dias',
              variant: variant,
              leadingIcon: SparklingBadgeIcon.flame,
            ),
          for (final icon in SparklingBadgeIcon.values)
            SparklingBadge(
              title: icon.name,
              description: '1 200',
              variant: SparklingBadgeVariant.accent,
              leadingIcon: icon,
            ),
        ],
      ),
    ),
  );
}

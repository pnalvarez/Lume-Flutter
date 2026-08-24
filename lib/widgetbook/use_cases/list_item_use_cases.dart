import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Layout variance selectable in the Interactive Widgetbook case.
enum _ListItemVariance {
  text,
  iconTitleDescription,
  leadingTitleCaption,
  titleCaptionTrailing,
  statusCta,
  headerChildren,
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemInteractive(BuildContext context) {
  final variance = context.knobs.object.dropdown(
    label: 'Variance',
    options: _ListItemVariance.values,
    labelBuilder: (v) => switch (v) {
      _ListItemVariance.text => 'Text',
      _ListItemVariance.iconTitleDescription => 'Icon title description',
      _ListItemVariance.leadingTitleCaption => 'Leading title caption',
      _ListItemVariance.titleCaptionTrailing => 'Title caption trailing',
      _ListItemVariance.statusCta => 'Status CTA',
      _ListItemVariance.headerChildren => 'Header with children',
    },
    initialOption: _ListItemVariance.iconTitleDescription,
  );
  final trait = context.knobs.object.dropdown(
    label: 'Trait',
    options: ListItemTrait.values,
    labelBuilder: (t) => t.name,
    initialOption: ListItemTrait.brand,
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  final showShadow = context.knobs.boolean(
    label: 'Show shadow',
    initialValue: false,
  );
  final showTrailing = context.knobs.boolean(
    label: 'Show trailing',
    initialValue: true,
  );
  final showAccentBar = context.knobs.boolean(
    label: 'Show accent bar',
    initialValue: true,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'List item title',
  );
  final description = context.knobs.string(
    label: 'Description / caption',
    initialValue: 'Supporting line of copy',
  );
  final progress = context.knobs.double.slider(
    label: 'Progress',
    initialValue: 0.35,
    min: 0,
    max: 1,
  );

  final cs = Theme.of(context).colorScheme;
  final usesZeroPadding =
      variance == _ListItemVariance.titleCaptionTrailing ||
      variance == _ListItemVariance.headerChildren;

  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: [
        ListItem(
          trait: trait,
          isEnabled: enabled,
          isSelected: selected,
          isExpanded: true,
          showShadow: showShadow,
          borderRadius: variance == _ListItemVariance.headerChildren
              ? AppRadius.xl2
              : variance == _ListItemVariance.statusCta ||
                    variance == _ListItemVariance.leadingTitleCaption
              ? AppRadius.xl
              : AppRadius.l,
          padding: usesZeroPadding
              ? EdgeInsets.zero
              : variance == _ListItemVariance.statusCta
              ? const EdgeInsets.all(AppSpacings.xl)
              : null,
          onTap: enabled ? () {} : null,
          input: _inputForVariance(
            variance: variance,
            title: title,
            description: description,
            progress: progress,
            showTrailing: showTrailing,
            showAccentBar: showAccentBar,
            colorScheme: cs,
          ),
        ),
      ],
    ),
  );
}

ListItemInput _inputForVariance({
  required _ListItemVariance variance,
  required String title,
  required String description,
  required double progress,
  required bool showTrailing,
  required bool showAccentBar,
  required ColorScheme colorScheme,
}) {
  return switch (variance) {
    _ListItemVariance.text => TextInput(text: title),
    _ListItemVariance.iconTitleDescription => IconTitleDescriptionInput(
      leadingIcon: Icons.route_rounded,
      title: title,
      description: description,
      showTrailing: showTrailing,
    ),
    _ListItemVariance.leadingTitleCaption => LeadingTitleCaptionInput(
      leading: const Text('🧠', style: TextStyle(fontSize: 22)),
      title: title,
      caption: description,
      progress: progress,
      showTrailing: showTrailing,
    ),
    _ListItemVariance.titleCaptionTrailing => TitleCaptionTrailingInput(
      title: title,
      caption: description,
      trailingIcon: showTrailing ? Icons.chevron_right_rounded : null,
      showAccentBar: showAccentBar,
    ),
    _ListItemVariance.statusCta => LeadingTitleDescriptionStatusCtaInput(
      leading: const Icon(Icons.auto_stories_rounded),
      title: title,
      description: description,
      statusLabel: 'Status',
      statusIcon: Icons.circle,
      progress: progress,
      progressCaption: '${(progress * 100).round()}%',
      actionLabel: 'Continuar',
      onAction: () {},
    ),
    _ListItemVariance.headerChildren => HeaderChildrenInput(
      title: title,
      headerBackgroundColor: colorScheme.secondary,
      headerForegroundColor: colorScheme.onPrimary,
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
      ),
      children: [
        ListItem(
          trait: ListItemTrait.brand,
          padding: EdgeInsets.zero,
          onTap: () {},
          input: TitleCaptionTrailingInput(
            title: description,
            caption: 'Child row A',
            trailingIcon: Icons.chevron_right_rounded,
            showAccentBar: showAccentBar,
          ),
        ),
        ListItem(
          trait: ListItemTrait.success,
          padding: EdgeInsets.zero,
          onTap: () {},
          input: TitleCaptionTrailingInput(
            title: 'Nested child',
            caption: 'Child row B',
            trailingIcon: Icons.check_circle_rounded,
            showAccentBar: showAccentBar,
          ),
        ),
      ],
    ),
  };
}

@widgetbook.UseCase(
  name: 'Icon title description',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemIconTitleDescription(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: [
        for (final trait in ListItemTrait.values) ...[
          ListItem(
            trait: trait,
            onTap: () {},
            input: IconTitleDescriptionInput(
              leadingIcon: Icons.route_rounded,
              title: 'Trait ${trait.name}',
              description: 'Optional description line',
            ),
          ),
          const SizedBox(height: AppSpacings.m),
        ],
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Leading title caption progress',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemLeadingTitleCaptionProgress(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.l),
      child: ListItem(
        trait: ListItemTrait.brand,
        borderRadius: AppRadius.xl,
        showShadow: true,
        onTap: () {},
        input: LeadingTitleCaptionInput(
          leading: const Text('🧠', style: TextStyle(fontSize: 22)),
          title: 'Pensamento crítico',
          caption: '3/12 submódulos · 25%',
          progress: 0.25,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Title caption trailing',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemTitleCaptionTrailing(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: [
        ListItem(
          trait: ListItemTrait.brand,
          padding: EdgeInsets.zero,
          onTap: () {},
          input: TitleCaptionTrailingInput(
            title: 'Em andamento',
            caption: '4 jogos · A fazer',
            trailingIcon: Icons.chevron_right_rounded,
            showAccentBar: true,
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        ListItem(
          trait: ListItemTrait.success,
          padding: EdgeInsets.zero,
          onTap: () {},
          input: TitleCaptionTrailingInput(
            title: 'Concluído',
            caption: '4 jogos · Feito',
            trailingIcon: Icons.check_circle_rounded,
            showAccentBar: true,
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        ListItem(
          trait: ListItemTrait.neutral,
          isEnabled: false,
          padding: EdgeInsets.zero,
          input: TitleCaptionTrailingInput(
            title: 'Bloqueado',
            caption: '4 jogos · Bloqueado',
            trailingIcon: Icons.lock_rounded,
            showAccentBar: true,
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Header with children',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemHeaderChildren(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.l),
      child: ListItem(
        trait: ListItemTrait.secondary,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.xl2,
        showShadow: true,
        input: HeaderChildrenInput(
          title: 'Nível 1',
          headerBackgroundColor: cs.secondary,
          headerForegroundColor: cs.onPrimary,
          leading: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
          ),
          children: [
            ListItem(
              trait: ListItemTrait.brand,
              padding: EdgeInsets.zero,
              onTap: () {},
              input: TitleCaptionTrailingInput(
                title: 'Submódulo A',
                caption: '4 jogos · A fazer',
                trailingIcon: Icons.chevron_right_rounded,
                showAccentBar: true,
              ),
            ),
            ListItem(
              trait: ListItemTrait.success,
              padding: EdgeInsets.zero,
              onTap: () {},
              input: TitleCaptionTrailingInput(
                title: 'Submódulo B',
                caption: '4 jogos · Feito',
                trailingIcon: Icons.check_circle_rounded,
                showAccentBar: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Status CTA',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemStatusCta(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.l),
      child: ListItem(
        trait: ListItemTrait.neutral,
        borderRadius: AppRadius.xl,
        padding: const EdgeInsets.all(AppSpacings.xl),
        input: LeadingTitleDescriptionStatusCtaInput(
          leading: const Icon(Icons.auto_stories_rounded),
          title: 'Módulo introdutório',
          description: 'Comece pela base antes de avançar.',
          statusLabel: 'Disponível',
          statusIcon: Icons.circle,
          progress: 0.4,
          progressCaption: '40%',
          actionLabel: 'Continuar',
          onAction: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled and selected',
  type: ListItem,
  path: '[Lume]/[Organisms]/ListItem',
)
Widget listItemDisabledSelected(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: [
        ListItem(
          trait: ListItemTrait.brand,
          isSelected: true,
          onTap: () {},
          input: IconTitleDescriptionInput(
            leadingIcon: Icons.check_circle_outline,
            title: 'Selected',
            description: 'Primary border highlight',
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        ListItem(
          trait: ListItemTrait.neutral,
          isEnabled: false,
          onTap: () {},
          input: IconTitleDescriptionInput(
            leadingIcon: Icons.lock_rounded,
            title: 'Disabled',
            description: 'Tap is ignored',
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        ListItem(
          input: TextInput(text: 'Plain text input inside a list item shell.'),
        ),
      ],
    ),
  );
}

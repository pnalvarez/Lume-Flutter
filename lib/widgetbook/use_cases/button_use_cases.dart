import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All variants', type: LumeButton)
Widget buttonAllVariants(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Continuar');
  final loading = context.knobs.boolean(label: 'Loading', initialValue: false);
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final expanded = context.knobs.boolean(label: 'Expanded', initialValue: true);
  final size = context.knobs.object.dropdown(
    label: 'Size',
    options: LumeButtonSize.values,
    labelBuilder: (s) => s.name,
    initialOption: LumeButtonSize.md,
  );

  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final type in LumeButtonType.values) ...[
            Text(
              type.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            for (final trait in LumeButtonTrait.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LumeButton(
                  label: '$label · ${trait.name}',
                  trait: trait,
                  type: type,
                  size: size,
                  isLoading: loading,
                  isEnabled: enabled,
                  isExpanded: expanded,
                  onPressed: () {},
                ),
              ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: LumeButton)
Widget buttonInteractive(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LumeButton(
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Continuar',
              ),
              trait: context.knobs.object.dropdown(
                label: 'Trait',
                options: LumeButtonTrait.values,
                labelBuilder: (t) => t.name,
                initialOption: LumeButtonTrait.brand,
              ),
              type: context.knobs.object.dropdown(
                label: 'Type',
                options: LumeButtonType.values,
                labelBuilder: (t) => t.name,
                initialOption: LumeButtonType.elevated,
              ),
              size: context.knobs.object.dropdown(
                label: 'Size',
                options: LumeButtonSize.values,
                labelBuilder: (s) => s.name,
                initialOption: LumeButtonSize.md,
              ),
              isLoading: context.knobs.boolean(
                label: 'Loading',
                initialValue: false,
              ),
              isEnabled: context.knobs.boolean(
                label: 'Enabled',
                initialValue: true,
              ),
              isExpanded: context.knobs.boolean(
                label: 'Expanded',
                initialValue: true,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Success trait', type: LumeButton)
Widget buttonSuccessTrait(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final type in LumeButtonType.values) ...[
            Text(
              type.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            LumeButton(
              label: 'Confirmar · success',
              trait: LumeButtonTrait.success,
              type: type,
              isExpanded: true,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: LumeButton)
Widget buttonDisabled(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final type in LumeButtonType.values) ...[
            Text(
              type.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            for (final trait in LumeButtonTrait.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LumeButton(
                  label: '${trait.name} · disabled',
                  trait: trait,
                  type: type,
                  isEnabled: false,
                  isExpanded: true,
                  onPressed: () {},
                ),
              ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With icons', type: LumeButton)
Widget buttonWithIcons(BuildContext context) {
  final trait = context.knobs.object.dropdown(
    label: 'Trait',
    options: LumeButtonTrait.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeButtonTrait.brand,
  );
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: LumeButtonType.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeButtonType.elevated,
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final expanded = context.knobs.boolean(label: 'Expanded', initialValue: true);

  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LumeButton(
            label: 'Leading icon',
            trait: trait,
            type: type,
            isEnabled: enabled,
            isExpanded: expanded,
            leadingIcon: const Icon(Icons.bolt_rounded, size: 18),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          LumeButton(
            label: 'Trailing icon',
            trait: trait,
            type: type,
            isEnabled: enabled,
            isExpanded: expanded,
            trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          LumeButton(
            label: 'Both icons',
            trait: trait,
            type: type,
            isEnabled: enabled,
            isExpanded: expanded,
            leadingIcon: const Icon(Icons.star_rounded, size: 18),
            trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Sizes', type: LumeButton)
Widget buttonSizes(BuildContext context) {
  final trait = context.knobs.object.dropdown(
    label: 'Trait',
    options: LumeButtonTrait.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeButtonTrait.brand,
  );
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: LumeButtonType.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeButtonType.elevated,
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final expanded = context.knobs.boolean(label: 'Expanded', initialValue: true);

  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: LumeButtonSize.values
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LumeButton(
                  label: s.name.toUpperCase(),
                  trait: trait,
                  type: type,
                  size: s,
                  isEnabled: enabled,
                  isExpanded: expanded,
                  onPressed: () {},
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Expanded', type: LumeButton)
Widget buttonExpanded(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'isExpanded: true',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          LumeButton(label: 'Continuar', isExpanded: true, onPressed: () {}),
          const SizedBox(height: 24),
          const Text(
            'isExpanded: false',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          LumeButton(label: 'Continuar', onPressed: () {}),
        ],
      ),
    ),
  );
}

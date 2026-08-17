import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All variants', type: LumeButton)
Widget buttonAllVariants(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Continuar');
  final loading = context.knobs.boolean(label: 'Loading', initialValue: false);
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
        children: LumeButtonVariant.values
            .map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.name,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    LumeButton(
                      label: label,
                      variant: v,
                      size: size,
                      isLoading: loading,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With icons', type: LumeButton)
Widget buttonWithIcons(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LumeButton(
            label: 'Leading icon',
            leadingIcon: const Icon(Icons.bolt_rounded, size: 18),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          LumeButton(
            label: 'Trailing icon',
            trailingIcon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          LumeButton(
            label: 'Both icons',
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
                  size: s,
                  onPressed: () {},
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

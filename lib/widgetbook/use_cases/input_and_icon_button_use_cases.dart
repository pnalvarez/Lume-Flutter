import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: InputField)
Widget inputFieldDefault(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Email');
  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'voce@email.com',
  );
  final error = context.knobs.string(label: 'Error', initialValue: '');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: InputField(
        label: label,
        controller: TextEditingController(),
        placeholder: placeholder,
        errorMessage: error.isEmpty ? null : error,
        isEnabled: enabled,
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All variants', type: LumeIconButton)
Widget iconButtonAll(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final v in LumeIconButtonVariant.values)
            for (final s in LumeIconButtonSize.values)
              LumeIconButton(
                icon: Icons.bolt_rounded,
                variant: v,
                size: s,
                tooltip: '${v.name} / ${s.name}',
                onPressed: () {},
              ),
        ],
      ),
    ),
  );
}

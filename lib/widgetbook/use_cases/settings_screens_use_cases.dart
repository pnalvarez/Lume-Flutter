import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/settings/settings_body.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noop() {}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Settings',
  name: 'Default',
  type: SettingsBody,
)
Widget settingsBodyDefault(BuildContext context) {
  return SettingsBody(
    onBack: _noop,
    onPersonalInfoPressed: _noop,
    onCategoriesPressed: _noop,
  );
}

import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive', type: LumeProgressBar)
Widget progressBarInteractive(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'Value',
    initialValue: 0.65,
    min: 0,
    max: 1,
  );
  final label = context.knobs.string(label: 'Label', initialValue: 'Progress');

  final showPct = context.knobs.boolean(
    label: 'Show percentage',
    initialValue: true,
  );
  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 10,
    min: 4,
    max: 24,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: LumeProgressBar(
        value: value,
        label: label.isEmpty ? null : label,
        showPercentage: showPct,
        height: height,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Multiple bars', type: LumeProgressBar)
Widget progressBarMultiple(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          LumeProgressBar(value: 0.20, label: 'Step A'),
          SizedBox(height: 16),
          LumeProgressBar(value: 0.50, label: 'Step B'),
          SizedBox(height: 16),
          LumeProgressBar(value: 0.75, label: 'Step C'),
          SizedBox(height: 16),
          LumeProgressBar(value: 1.0, label: 'Step D'),
        ],
      ),
    ),
  );
}

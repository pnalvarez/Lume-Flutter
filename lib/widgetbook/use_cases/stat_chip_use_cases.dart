import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/chips/stat_chip.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Showcase', type: StatChip)
Widget statChipShowcase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'XP');
  final value = context.knobs.string(label: 'Value', initialValue: '1 200');

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatChip(icon: Icons.bolt_rounded, label: label, value: value),
          const SizedBox(height: 12),
          const StatChip(icon: Icons.local_fire_department_rounded, label: 'Streak', value: '7d'),
          const SizedBox(height: 12),
          const StatChip(icon: Icons.star_rounded, label: 'Level', value: '14'),
          const SizedBox(height: 12),
          const StatChip(icon: Icons.timeline_rounded, label: 'Cards', value: '243'),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/molecules/badges/lume_badge.dart';
import 'package:lume_design_system/molecules/chips/chip_picker.dart';
import 'package:lume_design_system/molecules/chips/status_chip.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/molecules/progress/step_progress_bar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'All states', type: StatusChip)
Widget statusChipAll(BuildContext context) {
  final hasDot = context.knobs.boolean(label: 'Has dot', initialValue: true);
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final s in StatusChipState.values)
            StatusChip(label: s.name, state: s, hasDot: hasDot),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: ChipPicker)
Widget chipPickerInteractive(BuildContext context) {
  final selected = context.knobs.int.slider(
    label: 'Selected index',
    initialValue: 0,
    min: 0,
    max: 3,
  );
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ChipPicker(
        items: const ['One', 'Two', 'Three', 'Four'],
        selectedIndex: selected,
        onSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: StepProgressBar)
Widget stepProgressInteractive(BuildContext context) {
  final current = context.knobs.int.slider(
    label: 'Current',
    initialValue: 2,
    min: 0,
    max: 8,
  );
  final total = context.knobs.int.slider(
    label: 'Total',
    initialValue: 8,
    min: 1,
    max: 12,
  );
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: StepProgressBar(currentValue: current, totalValue: total),
    ),
  );
}

@widgetbook.UseCase(name: 'With leading badge', type: LumeProgressBar)
Widget progressBarWithLeading(BuildContext context) {
  final value = context.knobs.double.slider(
    label: 'Value',
    initialValue: 0.65,
    min: 0,
    max: 1,
  );
  final label =
      context.knobs.string(label: 'Badge label', initialValue: 'Aprendendo');

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: LumeProgressBar(
        value: value,
        leading: LumeBadge(
          label: label,
          leadingIcon: Icons.school_rounded,
          backgroundColor: AppColors.Accent.accentLight,
          foregroundColor: AppColors.Accent.onAccent,
        ),
        fillColor: AppColors.Accent.onAccent,
        trackColor: AppColors.Accent.accentLight,
      ),
    ),
  );
}

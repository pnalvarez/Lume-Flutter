import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/molecules/badges/lume_badge.dart';
import 'package:lume_design_system/molecules/chips/chip_picker.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
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

@widgetbook.UseCase(name: 'Selected and unselected', type: SelectableChip)
Widget selectableChipStates(BuildContext context) {
  final selected = context.knobs.boolean(label: 'Selected', initialValue: true);
  final label = context.knobs.string(label: 'Label', initialValue: 'História');
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SelectableChip(label: label, selected: selected, onPressed: () {}),
          SelectableChip(
            label: 'Filosofia',
            selected: !selected,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multi-select with select all',
  type: SelectableChipGroup,
)
Widget selectableChipGroupInteractive(BuildContext context) {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(24),
      child: _SelectableChipGroupDemo(),
    ),
  );
}

class _SelectableChipGroupDemo extends StatefulWidget {
  const _SelectableChipGroupDemo();

  @override
  State<_SelectableChipGroupDemo> createState() =>
      _SelectableChipGroupDemoState();
}

class _SelectableChipGroupDemoState extends State<_SelectableChipGroupDemo> {
  static const _options = [
    SelectableChipOption(id: 1, label: 'História'),
    SelectableChipOption(id: 2, label: 'Ciência'),
    SelectableChipOption(id: 3, label: 'Cultura'),
    SelectableChipOption(id: 4, label: 'Esporte'),
  ];

  var _selected = <int>{1, 3};

  @override
  Widget build(BuildContext context) {
    return SelectableChipGroup<int>(
      options: _options,
      selectedIds: _selected,
      onToggle: (id) {
        setState(() {
          if (_selected.contains(id)) {
            _selected = {..._selected}..remove(id);
          } else {
            _selected = {..._selected, id};
          }
        });
      },
      selectAllLabel: 'Selecionar todas',
      onSelectAllToggled: () {
        setState(() {
          if (_selected.length == _options.length) {
            _selected = {};
          } else {
            _selected = {for (final option in _options) option.id};
          }
        });
      },
    );
  }
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
  final label = context.knobs.string(
    label: 'Badge label',
    initialValue: 'Aprendendo',
  );

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

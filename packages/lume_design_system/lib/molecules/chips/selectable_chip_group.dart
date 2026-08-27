import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/chips/selectable_chip.dart';

/// One option in a [SelectableChipGroup].
@immutable
class SelectableChipOption<T> {
  const SelectableChipOption({required this.id, required this.label});

  final T id;
  final String label;
}

/// Wrapping multi-select chip group built from [SelectableChip].
///
/// Optionally shows a select-all row when [selectAllLabel] and
/// [onSelectAllToggled] are both provided.
class SelectableChipGroup<T> extends StatelessWidget {
  const SelectableChipGroup({
    super.key,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
    this.selectAllLabel,
    this.onSelectAllToggled,
    this.spacing = AppSpacings.s,
    this.runSpacing = AppSpacings.s,
  });

  final List<SelectableChipOption<T>> options;
  final Set<T> selectedIds;
  final ValueChanged<T> onToggle;

  /// When set with [onSelectAllToggled], renders the select-all control.
  final String? selectAllLabel;
  final VoidCallback? onSelectAllToggled;

  final double spacing;
  final double runSpacing;

  bool get _allSelected =>
      options.isNotEmpty &&
      options.every((option) => selectedIds.contains(option.id));

  bool get _showSelectAll =>
      selectAllLabel != null && onSelectAllToggled != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final option in options)
              SelectableChip(
                label: option.label,
                selected: selectedIds.contains(option.id),
                onPressed: () => onToggle(option.id),
              ),
          ],
        ),
        if (_showSelectAll) ...[
          const SizedBox(height: AppSpacings.l),
          InkWell(
            onTap: onSelectAllToggled,
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _allSelected,
                    onChanged: (_) => onSelectAllToggled?.call(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: AppSpacings.xs),
                Expanded(
                  child: Text(
                    selectAllLabel!,
                    style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

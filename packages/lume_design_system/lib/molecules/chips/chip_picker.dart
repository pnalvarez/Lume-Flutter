import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

const double _kChipPickerMinHeight = 28;
const double _kChipPickerBarHeight = 36;

/// Horizontal single-select pill row.
class ChipPicker extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ChipPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    assert(
      selectedIndex >= 0 && selectedIndex < items.length,
      'selectedIndex must be within items',
    );

    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: _kChipPickerBarHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacings.s),
              _ChipPickerPill(
                label: items[i],
                selected: i == selectedIndex,
                scheme: cs,
                onTap: () => onSelected(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChipPickerPill extends StatelessWidget {
  final String label;
  final bool selected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _ChipPickerPill({
    required this.label,
    required this.selected,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? scheme.primary : scheme.secondaryContainer;
    final fg = selected ? scheme.onPrimary : scheme.onSecondaryContainer;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(
        AppRadius.full(_kChipPickerMinHeight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _kChipPickerMinHeight,
            maxHeight: _kChipPickerBarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.s,
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typ.tagS.copyWith(color: fg),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

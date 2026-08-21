import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

const double _kSelectableChipMinHeight = 32;

/// Tappable pill for multi-select groups (e.g. category preferences).
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.secondary : cs.surfaceContainerLowest;
    final fg = selected ? cs.onSecondary : cs.onSurfaceVariant;
    final border = selected ? Colors.transparent : cs.outline;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(
        AppRadius.full(_kSelectableChipMinHeight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _kSelectableChipMinHeight,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppRadius.full(_kSelectableChipMinHeight),
              ),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.l,
                vertical: AppSpacings.s,
              ),
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

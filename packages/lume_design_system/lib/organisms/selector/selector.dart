import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

const double _kSelectorMinHeight = 28;
const double _kSelectorBarHeight = 36;

/// Pill button that opens a bottom sheet of [options].
///
/// The button label is [selectedOption]. The caller updates it from
/// [onSelectOption].
///
/// The pill follows the ChipPicker geometry with a white fill instead of
/// the picker's blue selected background.
final class Selector extends StatelessWidget {
  final String bottomsheetTitle;
  final String selectedOption;
  final bool hasChevronDown;
  final List<String> options;
  final ValueChanged<String> onSelectOption;

  const Selector({
    super.key,
    required this.bottomsheetTitle,
    required this.selectedOption,
    required this.hasChevronDown,
    required this.options,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.full(_kSelectorMinHeight),
        ),
        side: BorderSide(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openSheet(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _kSelectorMinHeight,
            maxHeight: _kSelectorBarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.s,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    selectedOption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typ.tagS.copyWith(color: cs.onSurface),
                  ),
                ),
                if (hasChevronDown) ...[
                  const SizedBox(width: AppSpacings.xs),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppSizes.iconXs,
                    color: cs.onSurface,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSheet(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surfaceContainerLowest,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.l)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacings.l,
                  AppSpacings.s,
                  AppSpacings.l,
                  AppSpacings.m,
                ),
                child: Text(
                  bottomsheetTitle,
                  style: typ.subtitle2xs.copyWith(color: cs.onSurface),
                ),
              ),
              for (final option in options)
                InkWell(
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelectOption(option);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.l,
                      vertical: AppSpacings.m,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          option,
                          style: typ.body4Medium.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacings.s),
                        Divider(height: 1, color: cs.outline),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

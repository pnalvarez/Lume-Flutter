import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/organisms/selector/selector.dart';
import 'package:lume_design_system/organisms/tabs/tab_container.dart';
import 'package:lume_design_system/organisms/tabs/tab_container_layout_type.dart';

/// Scrollable achievement rows for the statuses in [categories].
///
/// The filter chrome above the rows follows [variation]. Rows stay the same
/// list for every layout.
class AchievementsList extends StatelessWidget {
  const AchievementsList({
    super.key,
    required this.categories,
    required this.variation,
    required this.selectedStatuses,
    required this.items,
    required this.onStatusSelected,
    required this.onClearFilters,
    required this.onRetry,
    this.showFilters = true,
    this.inlineError,
    this.onRefresh,
  });

  final List<AchievementListItemStatus> categories;
  final AchievementListFilterVariation variation;
  final Set<AchievementListItemStatus> selectedStatuses;
  final List<AchievementListItemUi> items;
  final ValueChanged<AchievementListItemStatus> onStatusSelected;
  final VoidCallback onClearFilters;
  final VoidCallback onRetry;
  final bool showFilters;
  final String? inlineError;
  final Future<void> Function()? onRefresh;

  List<AchievementListItemUi> get _shown {
    return [
      for (final item in items)
        if (categories.contains(item.status)) item,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final content = _shown.isEmpty
        ? _FilteredEmpty(
            inlineError: inlineError,
            showClearFilters:
                variation == AchievementListFilterVariation.chips &&
                selectedStatuses.isNotEmpty,
            onClearFilters: onClearFilters,
            onRefresh: onRefresh,
          )
        : _AchievementRows(
            items: _shown,
            inlineError: inlineError,
            onRetry: onRetry,
            onRefresh: onRefresh,
          );

    if (!showFilters || categories.isEmpty) return content;

    return switch (variation) {
      AchievementListFilterVariation.chips => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.xl,
              AppSpacings.s,
              AppSpacings.xl,
              AppSpacings.s,
            ),
            child: SelectableChipGroup<AchievementListItemStatus>(
              options: [
                for (final status in categories)
                  SelectableChipOption(id: status, label: _label(status)),
              ],
              selectedIds: selectedStatuses,
              onToggle: onStatusSelected,
            ),
          ),
          Expanded(child: content),
        ],
      ),
      AchievementListFilterVariation.tabs => TabContainer(
        tabs: [for (final status in categories) _label(status)],
        selectedTab: _label(_selectedStatus),
        layoutType: TabContainerLayoutType.fixed,
        onTabSelected: (label) => onStatusSelected(_statusForLabel(label)),
        child: content,
      ),
      AchievementListFilterVariation.selector => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.xl,
              AppSpacings.s,
              AppSpacings.xl,
              AppSpacings.s,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Selector(
                bottomsheetTitle: achievementsFilterSheetTitle,
                selectedOption: _label(_selectedStatus),
                hasChevronDown: true,
                options: [for (final status in categories) _label(status)],
                onSelectOption: (label) =>
                    onStatusSelected(_statusForLabel(label)),
              ),
            ),
          ),
          Expanded(child: content),
        ],
      ),
    };
  }

  AchievementListItemStatus get _selectedStatus {
    for (final status in categories) {
      if (selectedStatuses.contains(status)) return status;
    }
    return categories.first;
  }

  AchievementListItemStatus _statusForLabel(String label) {
    for (final status in categories) {
      if (_label(status) == label) return status;
    }
    return categories.first;
  }
}

String _label(AchievementListItemStatus status) {
  return switch (status) {
    AchievementListItemStatus.completed => achievementsFilterCompleted,
    AchievementListItemStatus.inProgress => achievementsFilterInProgress,
    AchievementListItemStatus.locked => achievementsFilterLocked,
  };
}

class _AchievementRows extends StatelessWidget {
  const _AchievementRows({
    required this.items,
    required this.onRetry,
    this.inlineError,
    this.onRefresh,
  });

  final List<AchievementListItemUi> items;
  final String? inlineError;
  final VoidCallback onRetry;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final error = inlineError;
    final list = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.xl,
        AppSpacings.s,
        AppSpacings.xl,
        AppSpacings.xl2,
      ),
      itemCount: items.length + (error != null ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacings.m),
      itemBuilder: (context, index) {
        if (error != null && index == 0) {
          return _InlineErrorBanner(message: error, onRetry: onRetry);
        }
        final item = items[error != null ? index - 1 : index];
        return AchievementListItem(
          title: item.title,
          description: item.description,
          status: item.status,
          progress: item.progress,
          target: item.target,
          icon: item.icon,
        );
      },
    );

    final refresh = onRefresh;
    if (refresh == null) return list;

    return RefreshIndicator(onRefresh: refresh, child: list);
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.m),
        LumeButton(
          label: achievementsRetry,
          type: LumeButtonType.outlined,
          onPressed: onRetry,
        ),
      ],
    );
  }
}

class _FilteredEmpty extends StatelessWidget {
  const _FilteredEmpty({
    required this.onClearFilters,
    required this.showClearFilters,
    this.inlineError,
    this.onRefresh,
  });

  final String? inlineError;
  final bool showClearFilters;
  final VoidCallback onClearFilters;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final content = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl2),
      children: [
        if (inlineError != null) ...[
          const SizedBox(height: AppSpacings.l),
          Text(
            inlineError!,
            textAlign: TextAlign.center,
            style: typ.body4Light.copyWith(color: cs.error),
          ),
          const SizedBox(height: AppSpacings.m),
        ],
        const SizedBox(height: AppSpacings.xl4),
        SvgPicture.asset(
          AppIcons.statusAlert,
          package: 'lume_design_system',
          width: AppSizes.mediaWellL,
          height: AppSizes.mediaWellL,
          colorFilter: ColorFilter.mode(cs.onSurfaceVariant, BlendMode.srcIn),
        ),
        const SizedBox(height: AppSpacings.l),
        Text(
          achievementsFilterEmpty,
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        if (showClearFilters) ...[
          const SizedBox(height: AppSpacings.l),
          LumeButton(
            label: achievementsFilterClearFilters,
            type: LumeButtonType.outlined,
            onPressed: onClearFilters,
          ),
        ],
      ],
    );

    final refresh = onRefresh;
    if (refresh == null) return content;

    return RefreshIndicator(onRefresh: refresh, child: content);
  }
}

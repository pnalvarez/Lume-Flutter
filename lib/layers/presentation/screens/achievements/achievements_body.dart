import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Achievements tab chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class AchievementsBody extends StatelessWidget {
  const AchievementsBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onFilterToggled,
    required this.onClearFilters,
    this.onRefresh,
  });

  final AchievementsState state;
  final VoidCallback onRetry;
  final ValueChanged<AchievementListItemStatus> onFilterToggled;
  final VoidCallback onClearFilters;
  final Future<void> Function()? onRefresh;

  static const statusFilterOptions =
      <SelectableChipOption<AchievementListItemStatus>>[
        SelectableChipOption(
          id: AchievementListItemStatus.completed,
          label: achievementsFilterCompleted,
        ),
        SelectableChipOption(
          id: AchievementListItemStatus.inProgress,
          label: achievementsFilterInProgress,
        ),
        SelectableChipOption(
          id: AchievementListItemStatus.locked,
          label: achievementsFilterLocked,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const PageHeader(title: achievementsTitle),
      body: switch (state) {
        final s when s.showFullScreenError => _AchievementsError(
          message: s.errorMessage ?? achievementsLoadError,
          onRetry: onRetry,
        ),
        final s when s.showSkeleton => const _AchievementsLoadingList(),
        final s when s.items.isEmpty => _AchievementsEmptyState(
          message: achievementsEmpty,
          onRetry: onRetry,
          onRefresh: onRefresh,
        ),
        final s => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (s.showStatusFilters)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacings.xl,
                  AppSpacings.s,
                  AppSpacings.xl,
                  AppSpacings.s,
                ),
                child: SelectableChipGroup<AchievementListItemStatus>(
                  options: statusFilterOptions,
                  selectedIds: s.selectedStatusFilters,
                  onToggle: onFilterToggled,
                ),
              ),
            Expanded(
              child: s.visibleItems.isEmpty
                  ? _AchievementsFilteredEmptyState(
                      inlineError: s.errorMessage,
                      onClearFilters: onClearFilters,
                      onRefresh: onRefresh,
                    )
                  : _AchievementsList(
                      items: s.visibleItems,
                      inlineError: s.errorMessage,
                      onRetry: onRetry,
                      onRefresh: onRefresh,
                    ),
            ),
          ],
        ),
      },
    );
  }
}

class _AchievementsList extends StatelessWidget {
  const _AchievementsList({
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

class _AchievementsLoadingList extends StatelessWidget {
  const _AchievementsLoadingList();

  static const int _placeholderCount = 4;

  static const AchievementListItemUi _placeholder = AchievementListItemUi(
    id: 'loading',
    title: achievementsLoadingTitle,
    description: achievementsLoadingDescription,
    status: AchievementListItemStatus.locked,
    progress: 0,
    target: 5,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.xl,
        AppSpacings.s,
        AppSpacings.xl,
        AppSpacings.xl2,
      ),
      itemCount: _placeholderCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacings.m),
      itemBuilder: (context, index) {
        return DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: AchievementListItem(
            title: _placeholder.title,
            description: _placeholder.description,
            status: _placeholder.status,
            progress: _placeholder.progress,
            target: _placeholder.target,
            icon: _placeholder.icon,
          ),
        );
      },
    );
  }
}

class _AchievementsEmptyState extends StatelessWidget {
  const _AchievementsEmptyState({
    required this.message,
    required this.onRetry,
    this.onRefresh,
  });

  final String message;
  final VoidCallback onRetry;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final content = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl2),
      children: [
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
          message,
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.l),
        LumeButton(
          label: achievementsRetry,
          type: LumeButtonType.outlined,
          onPressed: onRetry,
        ),
      ],
    );

    final refresh = onRefresh;
    if (refresh == null) return content;

    return RefreshIndicator(onRefresh: refresh, child: content);
  }
}

class _AchievementsFilteredEmptyState extends StatelessWidget {
  const _AchievementsFilteredEmptyState({
    required this.onClearFilters,
    this.inlineError,
    this.onRefresh,
  });

  final String? inlineError;
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
        const SizedBox(height: AppSpacings.l),
        LumeButton(
          label: achievementsFilterClearFilters,
          type: LumeButtonType.outlined,
          onPressed: onClearFilters,
        ),
      ],
    );

    final refresh = onRefresh;
    if (refresh == null) return content;

    return RefreshIndicator(onRefresh: refresh, child: content);
  }
}

class _AchievementsError extends StatelessWidget {
  const _AchievementsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacings.l),
            LumeButton(
              label: achievementsRetry,
              type: LumeButtonType.outlined,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

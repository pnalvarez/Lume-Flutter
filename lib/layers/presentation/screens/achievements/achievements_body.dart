import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_list.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
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
        final s => AchievementsList(
          categories: achievementFilterCategories,
          variation: s.filterVariation,
          selectedStatuses: s.selectedStatusFilters,
          items: s.visibleItems,
          showFilters: s.showStatusFilters,
          inlineError: s.errorMessage,
          onStatusSelected: onFilterToggled,
          onClearFilters: onClearFilters,
          onRetry: onRetry,
          onRefresh: onRefresh,
        ),
      },
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

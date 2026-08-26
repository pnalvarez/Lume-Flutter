import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Trail detail chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class TrailDetailBody extends StatelessWidget {
  const TrailDetailBody({
    super.key,
    required this.state,
    required this.onBack,
    required this.onRetry,
    required this.onSubmodulePressed,
  });

  final TrailDetailState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final ValueChanged<int> onSubmodulePressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // Soft brand wash behind the list — white cards and slate headers pop.
      backgroundColor: AppColors.Primary.primaryLight,
      appBar: PageHeader(title: state.headerTitle, onBack: onBack),
      body: switch (state.status) {
        TrailDetailStatus.loading => const TrailDetailLoadingList(),
        TrailDetailStatus.error => Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.errorMessage ?? trailDetailLoadError,
                textAlign: TextAlign.center,
                style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacings.l),
              LumeButton(
                label: trailDetailRetry,
                type: LumeButtonType.outlined,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
        TrailDetailStatus.ready => _ReadyContent(
          levels: state.levels,
          onSubmodulePressed: onSubmodulePressed,
        ),
      },
    );
  }
}

/// Skeleton for trail detail: 5 submodule cells.
class TrailDetailLoadingList extends StatelessWidget {
  const TrailDetailLoadingList({super.key});

  static const int itemCount = 5;

  static const TrailDetailSubmoduleRowUi _placeholder =
      TrailDetailSubmoduleRowUi(
        id: 0,
        title: trailDetailLoadingSubmoduleTitle,
        gamesCount: 4,
        isCompleted: false,
      );

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.l,
        AppSpacings.l,
        AppSpacings.l,
        AppSpacings.xl2,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacings.m),
      itemBuilder: (context, index) {
        return DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.l),
          child: TrailDetailSubmoduleListItem(
            submodule: _placeholder,
            onPressed: () {},
          ),
        );
      },
    );
  }
}

/// Submodule row used by ready levels and the loading skeleton.
class TrailDetailSubmoduleListItem extends StatelessWidget {
  const TrailDetailSubmoduleListItem({
    super.key,
    required this.submodule,
    required this.onPressed,
    this.applyDisabledOpacity = true,
  });

  final TrailDetailSubmoduleRowUi submodule;
  final VoidCallback? onPressed;
  final bool applyDisabledOpacity;

  @override
  Widget build(BuildContext context) {
    final locked = submodule.isLocked;
    final needsRetry = submodule.needsRetry;
    final gamesLabel = '${submodule.gamesCount} $trailDetailGamesCountSuffix';
    final statusLabel = locked
        ? trailDetailSubmoduleLocked
        : submodule.isCompleted
        ? trailDetailSubmoduleDone
        : needsRetry
        ? trailDetailSubmoduleRetry
        : trailDetailSubmoduleTodo;
    final unlockHint = submodule.unlockHint?.trim();
    final hint = unlockHint != null && unlockHint.isNotEmpty
        ? unlockHint
        : null;

    final trait = locked
        ? ListItemTrait.neutral
        : submodule.isCompleted
        ? ListItemTrait.success
        : ListItemTrait.brand;

    final trailingIcon = locked
        ? Icons.lock_rounded
        : submodule.isCompleted
        ? Icons.check_circle_rounded
        : needsRetry
        ? Icons.warning_amber_rounded
        : Icons.chevron_right_rounded;

    final warningColor = needsRetry ? AppColors.Accent.onAccent : null;

    return ListItem(
      trait: trait,
      isEnabled: applyDisabledOpacity ? !locked : true,
      borderRadius: AppRadius.l,
      onTap: locked ? null : onPressed,
      padding: EdgeInsets.zero,
      input: TitleCaptionTrailingInput(
        title: submodule.title,
        caption: '$gamesLabel · $statusLabel',
        hint: hint,
        hintColor: warningColor,
        trailingIcon: trailingIcon,
        trailingIconColor: warningColor,
        showAccentBar: true,
      ),
    );
  }
}

class _ReadyContent extends StatelessWidget {
  const _ReadyContent({required this.levels, required this.onSubmodulePressed});

  final List<TrailDetailLevelUi> levels;
  final ValueChanged<int> onSubmodulePressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visibleLevels = [
      for (final level in levels)
        if (level.submodules.isNotEmpty) level,
    ];

    if (visibleLevels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: Center(
          child: Text(
            trailDetailEmpty,
            textAlign: TextAlign.center,
            style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.l,
        AppSpacings.l,
        AppSpacings.l,
        AppSpacings.xl2,
      ),
      itemCount: visibleLevels.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacings.l),
      itemBuilder: (context, index) {
        return _LevelListItem(
          level: visibleLevels[index],
          onSubmodulePressed: onSubmodulePressed,
        );
      },
    );
  }
}

class _LevelListItem extends StatelessWidget {
  const _LevelListItem({required this.level, required this.onSubmodulePressed});

  final TrailDetailLevelUi level;
  final ValueChanged<int> onSubmodulePressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final locked = level.isLocked;

    final headerBg = locked
        ? cs.surfaceContainerHighest
        : AppColors.Secondary.secondary;
    final headerFg = locked ? cs.onSurfaceVariant : cs.onPrimary;

    return ListItem(
      trait: ListItemTrait.secondary,
      isEnabled: !locked,
      onTap: null,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.xl2,
      showShadow: true,
      input: HeaderChildrenInput(
        title: level.title,
        headerBackgroundColor: headerBg,
        headerForegroundColor: headerFg,
        leading: locked
            ? Icon(
                Icons.lock_rounded,
                size: AppSizes.iconXs,
                color: cs.onSurfaceVariant,
              )
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
        children: [
          for (final submodule in level.submodules)
            TrailDetailSubmoduleListItem(
              submodule: submodule,
              // Parent already dims the section when locked.
              applyDisabledOpacity: !locked,
              onPressed: () => onSubmodulePressed(submodule.id),
            ),
        ],
      ),
    );
  }
}

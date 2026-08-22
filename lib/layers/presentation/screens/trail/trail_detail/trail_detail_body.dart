import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
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
        TrailDetailStatus.loading => const Center(child: CircularLoader()),
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
        return _LevelContainer(
          level: visibleLevels[index],
          onSubmodulePressed: onSubmodulePressed,
        );
      },
    );
  }
}

class _LevelContainer extends StatelessWidget {
  const _LevelContainer({
    required this.level,
    required this.onSubmodulePressed,
  });

  final TrailDetailLevelUi level;
  final ValueChanged<int> onSubmodulePressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Friendlier mid blue — brighter than slate, softer than brand primary.
    final levelHeader = AppColors.Secondary.secondary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.Surface.onContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.Surface.onSurface.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.m,
            ),
            color: levelHeader,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacings.s),
                Expanded(
                  child: Text(
                    level.title,
                    style: typ.body4Semibold.copyWith(color: cs.onPrimary),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacings.m),
            child: Column(
              children: [
                for (var i = 0; i < level.submodules.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacings.s),
                  _SubmoduleCard(
                    submodule: level.submodules[i],
                    onTap: () => onSubmodulePressed(level.submodules[i].id),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmoduleCard extends StatelessWidget {
  const _SubmoduleCard({required this.submodule, required this.onTap});

  final TrailDetailSubmoduleRowUi submodule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusLabel = submodule.isCompleted
        ? trailDetailSubmoduleDone
        : trailDetailSubmoduleTodo;
    final gamesLabel = '${submodule.gamesCount} $trailDetailGamesCountSuffix';
    final accent = submodule.isCompleted ? cs.secondary : cs.primary;

    return Material(
      color: cs.surfaceContainerLowest,
      elevation: 0,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: cs.onSurface.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.l),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacings.m,
                      AppSpacings.m,
                      AppSpacings.l,
                      AppSpacings.m,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                submodule.title,
                                style: typ.body3Semibold.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacings.xs),
                              Text(
                                '$gamesLabel · $statusLabel',
                                style: typ.tagS.copyWith(
                                  color: accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          submodule.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.chevron_right_rounded,
                          size: 22,
                          color: accent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

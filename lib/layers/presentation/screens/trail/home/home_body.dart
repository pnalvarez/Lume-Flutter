import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';

/// Trail home chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onTrailPressed,
  });

  final HomeState state;
  final VoidCallback onRetry;
  final ValueChanged<int> onTrailPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: cs.surface,
      body: switch (state.status) {
        HomeStatus.loading => const SafeArea(
          child: Center(child: CircularLoader()),
        ),
        HomeStatus.error => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.xl2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.errorMessage ?? trailHomeLoadError,
                  textAlign: TextAlign.center,
                  style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacings.l),
                LumeButton(
                  label: trailHomeRetry,
                  type: LumeButtonType.outlined,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
        HomeStatus.ready => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacings.xl2,
                    topInset + AppSpacings.xl2,
                    AppSpacings.xl2,
                    AppSpacings.xl3,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppRadius.xl3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$trailHomeGreetingPrefix${state.greetingName}',
                        style: typ.body1Semibold.copyWith(color: cs.onPrimary),
                      ),
                      const SizedBox(height: AppSpacings.xs),
                      Text(
                        trailHomeSubtitle,
                        style: typ.body4Light.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacings.l,
                AppSpacings.l,
                AppSpacings.l,
                AppSpacings.xl2,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    trailHomeSectionTitle,
                    style: typ.body4Semibold.copyWith(color: cs.primary),
                  ),
                  const SizedBox(height: AppSpacings.m),
                  if (state.trails.isEmpty)
                    Text(
                      trailHomeEmpty,
                      style: typ.body4Light.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    )
                  else
                    for (final trail in state.trails) ...[
                      _TrailCard(
                        trail: trail,
                        onTap: () => onTrailPressed(trail.trailId),
                      ),
                      const SizedBox(height: AppSpacings.m),
                    ],
                ]),
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _TrailCard extends StatelessWidget {
  const _TrailCard({required this.trail, required this.onTap});

  final HomeTrailCardUi trail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final caption = trail.progressPercent == 0
        ? '${trail.totalSubmodules} $trailHomeSubmodulesLabel'
        : '${trail.completedSubmodules}/${trail.totalSubmodules} $trailHomeSubmodulesLabel · ${trail.progressPercent}%';

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: cs.primaryContainer),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.l,
              vertical: AppSpacings.m,
            ),
            child: Row(
              children: [
                Text(trail.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: AppSpacings.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trail.title,
                        style: typ.body3Semibold.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: AppSpacings.xs),
                      Text(
                        caption,
                        style: typ.tagS.copyWith(
                          color: cs.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.s),
                      LumeProgressBar(
                        value: trail.progressPercent / 100,
                        height: 4,
                        showPercentage: false,
                        fillColor: cs.primary,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 22, color: cs.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

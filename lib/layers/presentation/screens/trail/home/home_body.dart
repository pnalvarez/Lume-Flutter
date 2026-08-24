import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';

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
                      ListItem(
                        trait: ListItemTrait.brand,
                        borderRadius: AppRadius.xl,
                        showShadow: true,
                        onTap: () => onTrailPressed(trail.trailId),
                        input: LeadingTitleCaptionInput(
                          leading: Text(
                            trail.emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                          title: trail.title,
                          caption: trail.progressPercent == 0
                              ? '${trail.totalSubmodules} $trailHomeSubmodulesLabel'
                              : '${trail.completedSubmodules}/${trail.totalSubmodules} $trailHomeSubmodulesLabel · ${trail.progressPercent}%',
                          progress: trail.progressPercent / 100,
                        ),
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

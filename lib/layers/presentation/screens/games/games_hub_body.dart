import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_ui.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';

/// Games-tab hub chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class GamesHubBody extends StatelessWidget {
  const GamesHubBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onGamePressed,
    required this.onArcadePressed,
  });

  final GamesHubState state;
  final VoidCallback onRetry;
  final ValueChanged<String> onGamePressed;
  final VoidCallback onArcadePressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: switch (state.status) {
        GamesHubStatus.loading => const _GamesHubScroll(
          listChildren: [GamesHubLoadingList()],
        ),
        GamesHubStatus.error => SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacings.xl2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? gamesHubLoadError,
                    textAlign: TextAlign.center,
                    style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacings.l),
                  LumeButton(
                    label: gamesHubRetry,
                    type: LumeButtonType.outlined,
                    trait: .destructive,
                    onPressed: onRetry,
                  ),
                ],
              ),
            ),
          ),
        ),
        GamesHubStatus.ready => state.games.isEmpty
            ? const _GamesHubScroll(
                fillRemaining: true,
                listChildren: [GamesHubEmptyState()],
              )
            : _GamesHubScroll(
                listChildren: [
                  if (state.generalGames.isNotEmpty) ...[
                    const GamesHubSectionTitle(gamesHubSectionGeneral),
                    const SizedBox(height: AppSpacings.m),
                    GamesHubGamesList(
                      games: state.generalGames,
                      onGamePressed: onGamePressed,
                    ),
                    const SizedBox(height: AppSpacings.xl2),
                  ],
                  if (state.visualGames.isNotEmpty) ...[
                    const GamesHubSectionTitle(gamesHubSectionVisual),
                    const SizedBox(height: AppSpacings.m),
                    GamesHubGamesList(
                      games: state.visualGames,
                      onGamePressed: onGamePressed,
                    ),
                    const SizedBox(height: AppSpacings.xl2),
                  ],
                  GamesHubArcadeButton(onPressed: onArcadePressed),
                ],
              ),
      },
    );
  }
}

class _GamesHubScroll extends StatelessWidget {
  const _GamesHubScroll({
    required this.listChildren,
    this.fillRemaining = false,
  });

  final List<Widget> listChildren;
  final bool fillRemaining;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
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
                    gamesHubTitle,
                    style: typ.headlineM.copyWith(color: cs.onPrimary),
                  ),
                  const SizedBox(height: AppSpacings.xs),
                  Text(
                    gamesHubSubtitle,
                    style: typ.body4Light.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (fillRemaining)
          SliverFillRemaining(
            hasScrollBody: false,
            child: listChildren.single,
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.l,
              AppSpacings.l,
              AppSpacings.l,
              AppSpacings.xl2,
            ),
            sliver: SliverList(delegate: SliverChildListDelegate(listChildren)),
          ),
      ],
    );
  }
}

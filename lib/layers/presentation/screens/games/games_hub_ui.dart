import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';

/// Section label for the games hub list.
class GamesHubSectionTitle extends StatelessWidget {
  const GamesHubSectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(label, style: typ.body4Semibold.copyWith(color: cs.primary));
  }
}

/// Vertical list of hub game cells.
class GamesHubGamesList extends StatelessWidget {
  const GamesHubGamesList({
    super.key,
    required this.games,
    required this.onGamePressed,
  });

  final List<GamesHubCardUi> games;
  final ValueChanged<String> onGamePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < games.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacings.m),
          GamesHubGameCell(
            game: games[i],
            onPressed: () => onGamePressed(games[i].slug),
          ),
        ],
      ],
    );
  }
}

/// Single hub game row with a colored leading stripe.
class GamesHubGameCell extends StatelessWidget {
  const GamesHubGameCell({
    super.key,
    required this.game,
    required this.onPressed,
  });

  final GamesHubCardUi game;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final leadingColor = parseHexColor(game.colorHex) ?? cs.primary;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacings.xs,
                  height: AppSpacings.xl4,
                  decoration: BoxDecoration(
                    color: leadingColor,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
                const SizedBox(width: AppSpacings.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: typ.body4Semibold.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: AppSpacings.xs2),
                      Text(
                        game.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: typ.body4Light.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
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

/// Large arcade-mode CTA at the bottom of the hub.
///
/// Pink gradient surface with a continuous shimmer and a sliding shine sweep.
class GamesHubArcadeButton extends StatefulWidget {
  const GamesHubArcadeButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<GamesHubArcadeButton> createState() => _GamesHubArcadeButtonState();
}

class _GamesHubArcadeButtonState extends State<GamesHubArcadeButton>
    with SingleTickerProviderStateMixin {
  static const Duration _shinePeriod = Duration(milliseconds: 2400);

  late final AnimationController _shine;

  @override
  void initState() {
    super.initState();
    _shine = AnimationController(vsync: this, duration: _shinePeriod)..repeat();
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl3);
    final pinkDeep = AppColors.Extra.pinkDeep;
    final pink = AppColors.Extra.pink;
    final pinkLight = AppColors.Extra.pinkLight;
    final onPink = AppColors.Surface.surfaceContainerLowest;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: radius,
        splashColor: pinkLight.withValues(alpha: 0.35),
        highlightColor: pinkLight.withValues(alpha: 0.18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: pinkDeep.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: pink.withValues(alpha: 0.45),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shine,
                    builder: (context, _) {
                      final pulse =
                          (math.sin(_shine.value * math.pi * 2) + 1) / 2;
                      final mid = Color.lerp(
                        pinkDeep,
                        pink,
                        0.35 + pulse * 0.45,
                      )!;
                      final highlight = Color.lerp(
                        pink,
                        pinkLight,
                        0.35 + pulse * 0.4,
                      )!;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-1.2 + _shine.value * 2.4, -0.8),
                            end: Alignment(0.2 + _shine.value * 2.4, 1.0),
                            colors: [pinkDeep, mid, highlight, mid, pinkDeep],
                            stops: const [0.0, 0.28, 0.5, 0.72, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _shine,
                      builder: (context, _) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final travel = constraints.maxWidth * 1.6;
                            final dx =
                                (_shine.value * travel) -
                                constraints.maxWidth * 0.4;
                            return Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Transform.translate(
                                  offset: Offset(dx, 0),
                                  child: Transform.rotate(
                                    angle: -0.55,
                                    child: Container(
                                      width: constraints.maxWidth * 0.35,
                                      height: constraints.maxHeight * 2.2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            onPink.withValues(alpha: 0),
                                            onPink.withValues(alpha: 0.42),
                                            onPink.withValues(alpha: 0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacings.l,
                    AppSpacings.l,
                    AppSpacings.m,
                    AppSpacings.l,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppSpacings.xl4,
                        height: AppSpacings.xl4,
                        decoration: BoxDecoration(
                          color: onPink.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(AppRadius.l),
                          border: Border.all(
                            color: onPink.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Icon(
                          Icons.sports_esports_rounded,
                          color: onPink,
                          size: AppSpacings.xl2,
                        ),
                      ),
                      const SizedBox(width: AppSpacings.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamesHubArcadeTitle,
                              style: typ.headlineS.copyWith(color: onPink),
                            ),
                            const SizedBox(height: AppSpacings.xs),
                            Text(
                              gamesHubArcadeSubtitle,
                              style: typ.body4Light.copyWith(
                                color: onPink.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacings.s),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: onPink.withValues(alpha: 0.9),
                        size: AppSizes.iconL,
                      ),
                    ],
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

/// Centered empty-hub message with an alert glyph above the copy.
class GamesHubEmptyState extends StatelessWidget {
  const GamesHubEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.statusAlert,
              package: 'lume_design_system',
              width: AppSizes.mediaWellL,
              height: AppSizes.mediaWellL,
              colorFilter: ColorFilter.mode(
                cs.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: AppSpacings.l),
            Text(
              gamesHubEmpty,
              textAlign: TextAlign.center,
              style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the hub list: 2 sections × 2 cells + arcade CTA.
class GamesHubLoadingList extends StatelessWidget {
  const GamesHubLoadingList({super.key});

  static const int _itemsPerSection = 2;

  static const GamesHubCardUi _placeholderCell = GamesHubCardUi(
    id: 'loading',
    slug: 'loading',
    title: gamesHubLoadingCellTitle,
    description: gamesHubLoadingCellDescription,
    colorHex: '#94A3B8',
    hubSection: HubSection.general,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _GamesHubSectionSkeleton(label: gamesHubSectionGeneral),
        const SizedBox(height: AppSpacings.xl2),
        const _GamesHubSectionSkeleton(label: gamesHubSectionVisual),
        const SizedBox(height: AppSpacings.xl2),
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          child: GamesHubArcadeButton(onPressed: () {}),
        ),
      ],
    );
  }
}

class _GamesHubSectionSkeleton extends StatelessWidget {
  const _GamesHubSectionSkeleton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.s),
          child: GamesHubSectionTitle(label),
        ),
        const SizedBox(height: AppSpacings.m),
        for (var i = 0; i < GamesHubLoadingList._itemsPerSection; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacings.m),
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: GamesHubGameCell(
              game: GamesHubLoadingList._placeholderCell,
              onPressed: () {},
            ),
          ),
        ],
      ],
    );
  }
}

/// Parses `#RRGGBB` (and optional `#AARRGGBB`) into a [Color].
@visibleForTesting
Color? parseHexColor(String raw) {
  final value = raw.trim();
  if (!value.startsWith('#') || (value.length != 7 && value.length != 9)) {
    return null;
  }
  final hex = value.substring(1);
  final parsed = int.tryParse(hex, radix: 16);
  if (parsed == null) return null;
  if (hex.length == 6) return Color(0xFF000000 | parsed);
  return Color(parsed);
}

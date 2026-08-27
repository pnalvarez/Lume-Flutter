import 'package:flutter/material.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/presentation/screens/profile/profile_header.dart';
import 'package:lume/layers/presentation/screens/profile/profile_level_card.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/molecules/tiles/stat_tile.dart';

/// Profile tab chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onSettingsPressed,
    required this.onSignOutPressed,
  });

  final ProfileState state;
  final VoidCallback onRetry;
  final VoidCallback onSettingsPressed;
  final VoidCallback onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacings.xl,
                AppSpacings.l,
                AppSpacings.xl,
                AppSpacings.l,
              ),
              child: ProfileHeader(
                displayName: state.displayName,
                memberSince: state.memberSince,
                isLoading: state.isLoading,
                onSettingsPressed: onSettingsPressed,
                onSignOutPressed: onSignOutPressed,
              ),
            ),
            Expanded(
              child: switch (state.status) {
                ProfileStatus.error => Padding(
                  padding: const EdgeInsets.all(AppSpacings.xl2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? profileLoadError,
                        textAlign: TextAlign.center,
                        style: typ.body3Light.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.l),
                      LumeButton(
                        label: profileRetry,
                        type: LumeButtonType.outlined,
                        onPressed: onRetry,
                      ),
                    ],
                  ),
                ),
                ProfileStatus.loading || ProfileStatus.ready => ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacings.xl,
                    0,
                    AppSpacings.xl,
                    AppSpacings.xl2,
                  ),
                  children: [
                    ProfileLevelCard(
                      playerLevel: state.playerLevel,
                      currentStreak: state.currentStreak,
                      xpInLevel: state.xpInLevel,
                      xpForNextLevel: state.xpForNextLevel,
                      daysInApp: state.daysInApp,
                      submodulesCompleted: state.submodulesCompleted,
                      isLoading: state.isLoading,
                    ),
                    const SizedBox(height: AppSpacings.l),
                    _StatsGrid(
                      tiles: state.statTiles,
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.tiles, required this.isLoading});

  final List<ProfileStatTileUi> tiles;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: AppSpacings.s));
      final left = tiles[i];
      final right = i + 1 < tiles.length ? tiles[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _statCell(left)),
              const SizedBox(width: AppSpacings.s),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _statCell(right),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _statCell(ProfileStatTileUi tile) {
    return DisplayAsLoader(
      enabled: isLoading,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: StatTile(icon: tile.icon, label: tile.label, value: tile.value),
    );
  }
}

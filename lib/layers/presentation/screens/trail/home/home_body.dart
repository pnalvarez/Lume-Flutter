import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';
import 'package:lume_design_system/organisms/navigation/brand_header.dart';

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

    return Scaffold(
      backgroundColor: cs.surface,
      body: switch (state.status) {
        HomeStatus.loading => const _HomeScroll(
          listChildren: [HomeLoadingList()],
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
        HomeStatus.ready => _HomeScroll(
          greetingName: state.greetingName.isEmpty
              ? trailHomeGreetingFallback
              : state.greetingName,
          listChildren: [
            Text(
              trailHomeSectionTitle,
              style: typ.body4Semibold.copyWith(color: cs.primary),
            ),
            const SizedBox(height: AppSpacings.m),
            if (state.trails.isEmpty)
              Text(
                trailHomeEmpty,
                style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
              )
            else
              for (final trail in state.trails) ...[
                HomeTrailListItem(
                  trail: trail,
                  onPressed: () => onTrailPressed(trail.trailId),
                ),
                const SizedBox(height: AppSpacings.m),
              ],
          ],
        ),
      },
    );
  }
}

/// Skeleton for the trail hub list: section title + 4 trail cards.
class HomeLoadingList extends StatelessWidget {
  const HomeLoadingList({super.key});

  static const int itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.s),
          child: Text(
            trailHomeSectionTitle,
            style: typ.body4Semibold.copyWith(color: cs.primary),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        for (var i = 0; i < itemCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacings.m),
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: HomeTrailListItem(
              trail: const HomeTrailCardUi(
                trailId: 0,
                title: trailHomeLoadingTrailTitle,
                emoji: trailHomeEmojiFallback,
                completedSubmodules: 2,
                totalSubmodules: 8,
                progressPercent: 25,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ],
    );
  }
}

/// Single trail row used by the ready list and loading skeleton.
class HomeTrailListItem extends StatelessWidget {
  const HomeTrailListItem({
    super.key,
    required this.trail,
    required this.onPressed,
  });

  final HomeTrailCardUi trail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      trait: ListItemTrait.brand,
      borderRadius: AppRadius.xl,
      showShadow: true,
      onTap: onPressed,
      input: LeadingTitleCaptionInput(
        leading: Text(trail.emoji, style: const TextStyle(fontSize: 22)),
        title: trail.title,
        caption: trail.progressPercent == 0
            ? '${trail.totalSubmodules} $trailHomeSubmodulesLabel'
            : '${trail.completedSubmodules}/${trail.totalSubmodules} '
                  '$trailHomeSubmodulesLabel · ${trail.progressPercent}%',
        progress: trail.progressPercent / 100,
      ),
    );
  }
}

class _HomeScroll extends StatelessWidget {
  const _HomeScroll({required this.listChildren, this.greetingName});

  final List<Widget> listChildren;
  final String? greetingName;

  @override
  Widget build(BuildContext context) {
    final name = (greetingName == null || greetingName!.isEmpty)
        ? trailHomeGreetingFallback
        : greetingName!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BrandHeader(
          title: '$trailHomeGreetingPrefix$name',
          subtitle: trailHomeSubtitle,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.l,
              AppSpacings.l,
              AppSpacings.l,
              AppSpacings.xl2,
            ),
            children: listChildren,
          ),
        ),
      ],
    );
  }
}

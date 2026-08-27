import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/molecules/loaders/shimmer_box.dart';
import 'package:lume_design_system/molecules/tiles/feedback_tile.dart';
import 'package:lume_design_system/molecules/tiles/score_tile.dart';
import 'package:lume_design_system/molecules/tiles/stat_tile.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Showcase', type: ScoreTile)
Widget scoreTileShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: const [
          Expanded(
            child: ScoreTile(
              icon: Icons.check_circle_rounded,
              score: 18,
              label: 'Acertos',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ScoreTile(
              icon: Icons.bolt_rounded,
              score: 240,
              label: 'XP total',
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Showcase', type: StatTile)
Widget statTileShowcase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'XP Total');
  final value = context.knobs.string(label: 'Value', initialValue: '341');

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          StatTile(
            icon: Icons.star_outline_rounded,
            label: label,
            value: value,
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Sequência',
                  value: '0d',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatTile(
                  icon: Icons.bolt_rounded,
                  label: 'XP hoje',
                  value: '0',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.bolt_rounded,
                  label: 'XP semana',
                  value: '341',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatTile(
                  icon: Icons.emoji_events_outlined,
                  label: 'Nível',
                  value: '3',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'All states', type: FeedbackTile)
Widget feedbackTileAll(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          for (final s in FeedbackTileState.values) ...[
            Expanded(
              child: FeedbackTile(
                state: s,
                title: s.name,
                subtitle: 'Toque',
                onTap: () {},
              ),
            ),
            if (s != FeedbackTileState.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Sizes', type: CircularLoader)
Widget circularLoaderSizes(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final s in CircularLoaderSize.values) ...[
            CircularLoader(size: s),
            const SizedBox(width: 24),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Sizes', type: ShimmerBox)
Widget shimmerBoxSizes(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      children: [
        Text('Lines', style: typ.body3Semibold),
        const SizedBox(height: AppSpacings.m),
        const ShimmerBox(width: double.infinity, height: 14),
        const SizedBox(height: AppSpacings.s),
        const ShimmerBox(width: 180, height: 20),
        const SizedBox(height: AppSpacings.s),
        const ShimmerBox(width: 240, height: 12),
        const SizedBox(height: AppSpacings.xl2),
        Text('Blocks & avatar', style: typ.body3Semibold),
        const SizedBox(height: AppSpacings.m),
        Row(
          children: [
            const ShimmerBox(width: 48, height: 48, shape: BoxShape.circle),
            const SizedBox(width: AppSpacings.m),
            Expanded(
              child: ShimmerBox(
                height: 72,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Match child shape', type: DisplayAsLoader)
Widget displayAsLoaderMatchChild(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      children: [
        Text(
          'Shimmer covers the exact laid-out size of each child.',
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.xl2),
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.s),
          child: Text(
            'Short title',
            style: typ.headlineS.copyWith(color: cs.onSurface),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.s),
          child: Text(
            'A longer subtitle line that stretches further across the row.',
            style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSpacings.xl2),
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Container(
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: const Text('Hero card'),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        Row(
          children: [
            DisplayAsLoader(
              shape: BoxShape.circle,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: cs.primaryContainer,
                child: const Icon(Icons.person),
              ),
            ),
            const SizedBox(width: AppSpacings.m),
            Expanded(
              child: DisplayAsLoader(
                borderRadius: BorderRadius.circular(AppRadius.l),
                child: Container(
                  height: 56,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.m,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.l),
                    border: Border.all(color: cs.outline),
                  ),
                  child: const Text('Profile row'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading screen (multi-size cells)',
  type: DisplayAsLoader,
)
Widget displayAsLoaderLoadingScreen(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final cardRadius = BorderRadius.circular(AppRadius.xl);

  Widget fakeCard({
    required double height,
    required String label,
    BorderRadiusGeometry? radius,
  }) {
    return DisplayAsLoader(
      borderRadius: radius ?? cardRadius,
      child: Container(
        width: double.infinity,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: radius ?? cardRadius,
          border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
        ),
        child: Text(label),
      ),
    );
  }

  return Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        children: [
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Text(
              'Discover games',
              style: typ.headlineM.copyWith(color: cs.onSurface),
            ),
          ),
          const SizedBox(height: AppSpacings.s),
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Text(
              'Pick something to play while content loads…',
              style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacings.xl2),
          fakeCard(height: 140, label: 'Featured banner'),
          const SizedBox(height: AppSpacings.xl),
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Text(
              'Continue playing',
              style: typ.body3Semibold.copyWith(color: cs.primary),
            ),
          ),
          const SizedBox(height: AppSpacings.m),
          fakeCard(height: 72, label: 'Wide list cell'),
          const SizedBox(height: AppSpacings.m),
          fakeCard(height: 72, label: 'Wide list cell'),
          const SizedBox(height: AppSpacings.xl),
          DisplayAsLoader(
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Text(
              'Browse by size',
              style: typ.body3Semibold.copyWith(color: cs.primary),
            ),
          ),
          const SizedBox(height: AppSpacings.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: fakeCard(height: 160, label: 'Tall')),
              const SizedBox(width: AppSpacings.m),
              Expanded(
                child: Column(
                  children: [
                    fakeCard(height: 74, label: 'Sm'),
                    const SizedBox(height: AppSpacings.m),
                    fakeCard(height: 74, label: 'Sm'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.m),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacings.m),
                Expanded(
                  child: fakeCard(
                    height: 88,
                    label: 'Tile',
                    radius: BorderRadius.circular(AppRadius.m),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacings.xl),
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacings.s),
                DisplayAsLoader(
                  shape: BoxShape.circle,
                  child: CircleAvatar(
                    radius: 18 + (i * 2),
                    backgroundColor: cs.primaryContainer,
                  ),
                ),
              ],
              const Spacer(),
              DisplayAsLoader(
                borderRadius: BorderRadius.circular(AppRadius.xl3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.l,
                    vertical: AppSpacings.s,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                  ),
                  child: const Text('CTA'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/tiles/feedback_tile.dart';
import 'package:lume_design_system/molecules/tiles/score_tile.dart';
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

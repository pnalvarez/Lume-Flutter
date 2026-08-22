import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/organisms/trail/content_card.dart';
import 'package:lume_design_system/organisms/trail/path_node.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: ContentCard)
Widget contentCardDefault(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Module A');
  final progress = context.knobs.double.slider(
    label: 'Progress',
    initialValue: 0.4,
    min: 0,
    max: 1,
  );
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ContentCard(
        leading: const Text('📘', style: TextStyle(fontSize: 22)),
        leadingBackground: AppColors.Primary.primaryContainer,
        leadingRing: AppColors.Primary.primary,
        title: title,
        description: 'Short description of the content unit.',
        statusLabel: 'In progress',
        statusIcon: Icons.auto_awesome,
        statusColor: AppColors.Secondary.secondary,
        progress: progress,
        progressCaption: null,
        actionLabel: 'Continue',
        onAction: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Path', type: PathNode)
Widget pathNodePath(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PathNode(
            state: PathNodeState.done,
            label: 'Step 1',
            subtitle: 'Completed',
            onTap: () {},
          ),
          const PathConnector(),
          PathNode(
            state: PathNodeState.active,
            label: 'Step 2',
            subtitle: 'Current',
            onTap: () {},
          ),
          const PathConnector(dashed: true),
          const PathNode(
            state: PathNodeState.locked,
            label: 'Step 3',
            subtitle: 'Locked',
          ),
        ],
      ),
    ),
  );
}

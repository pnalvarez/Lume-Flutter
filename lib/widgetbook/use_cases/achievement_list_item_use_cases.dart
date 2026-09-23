import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Locked',
  type: AchievementListItem,
)
Widget achievementListItemLocked(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: const [
        AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos na trilha.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 5,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'In progress',
  type: AchievementListItem,
)
Widget achievementListItemInProgress(BuildContext context) {
  final progress = context.knobs.int.slider(
    label: 'Progress',
    initialValue: 3,
    min: 0,
    max: 5,
  );

  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: [
        AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos na trilha.',
          status: AchievementListItemStatus.inProgress,
          progress: progress,
          target: 5,
          onTap: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Completed',
  type: AchievementListItem,
)
Widget achievementListItemCompleted(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: const [
        AchievementListItem(
          title: 'Primeiro passo',
          description: 'Complete 1 submódulo na trilha.',
          status: AchievementListItemStatus.completed,
          progress: 1,
          target: 1,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'All states',
  type: AchievementListItem,
)
Widget achievementListItemAllStates(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.l),
      children: const [
        AchievementListItem(
          title: 'Arcade 50',
          description: 'Alcance 50 pontos em uma partida no Arcade.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 50,
        ),
        SizedBox(height: AppSpacings.m),
        AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos na trilha.',
          status: AchievementListItemStatus.inProgress,
          progress: 3,
          target: 5,
        ),
        SizedBox(height: AppSpacings.m),
        AchievementListItem(
          title: 'Primeiro passo',
          description: 'Complete 1 submódulo na trilha.',
          status: AchievementListItemStatus.completed,
          progress: 1,
          target: 1,
        ),
      ],
    ),
  );
}

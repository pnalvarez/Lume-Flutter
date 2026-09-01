import 'package:flutter/material.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume/layers/presentation/shared/level_up_alert.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Level up',
  name: 'Default',
  type: LevelUpAlert,
)
Widget levelUpAlertDefault(BuildContext context) {
  final level = context.knobs.int.slider(
    label: 'Level',
    initialValue: 3,
    min: 1,
    max: 50,
  );
  final xpOffset = context.knobs.int.slider(
    label: 'XP offset',
    initialValue: 100,
    min: 0,
    max: 500,
  );
  final currentXp = context.knobs.int.slider(
    label: 'Current XP',
    initialValue: 103,
    min: 0,
    max: 600,
  );
  final xpForNextLevel = context.knobs.int.slider(
    label: 'XP for next level',
    initialValue: 200,
    min: 1,
    max: 800,
  );

  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: LevelUpAlert(
          level: level,
          xpOffset: xpOffset,
          currentXp: currentXp,
          xpForNextLevel: xpForNextLevel,
          onContinue: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Level up',
  name: 'Interactive dialog',
  type: LevelUpAlert,
)
Widget levelUpAlertDialog(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Builder(
        builder: (ctx) {
          return LumeButton(
            label: xpLevelUpHeadline(3),
            onPressed: () {
              showDialog<void>(
                context: ctx,
                builder: (dialogContext) => LevelUpAlert(
                  level: 3,
                  xpOffset: 100,
                  currentXp: 103,
                  xpForNextLevel: 200,
                  onContinue: () => Navigator.of(dialogContext).pop(),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

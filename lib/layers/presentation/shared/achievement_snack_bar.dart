import 'package:flutter/material.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';

export 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart'
    show LumeSnackBarPosition;

/// Shows a top toast when an achievement is unlocked.
void showAchievementUnlockedSnackBar(
  BuildContext context,
  String name, {
  IconData icon = Icons.emoji_events_rounded,
  LumeSnackBarPosition position = LumeSnackBarPosition.top,
}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return;
  showLumeSnackBar(
    context,
    icon: icon,
    text: achievementUnlockedSnackBarText(trimmed),
    trait: LumeSnackBarTrait.brand,
    position: position,
    hasCloseButton: false,
  );
}

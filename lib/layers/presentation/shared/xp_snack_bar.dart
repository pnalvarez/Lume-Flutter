import 'package:flutter/material.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';

export 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart'
    show LumeSnackBarPosition;

/// Shows the XP toast when [xpAwarded] is positive.
void showXpAwardedSnackBar(
  BuildContext context,
  int xpAwarded, {
  LumeSnackBarPosition position = LumeSnackBarPosition.top,
}) {
  if (xpAwarded <= 0) return;
  showLumeSnackBar(
    context,
    icon: Icons.priority_high_rounded,
    text: xpAwardedSnackBarText(xpAwarded),
    trait: LumeSnackBarTrait.warning,
    position: position,
    hasCloseButton: false,
  );
}

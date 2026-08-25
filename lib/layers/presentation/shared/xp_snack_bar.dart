import 'package:flutter/material.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';

/// Shows the XP toast when [xpAwarded] is positive.
void showXpAwardedSnackBar(BuildContext context, int xpAwarded) {
  if (xpAwarded <= 0) return;
  showLumeSnackBar(
    context,
    icon: Icons.priority_high_rounded,
    text: xpAwardedSnackBarText(xpAwarded),
    trait: LumeSnackBarTrait.warning,
    hasCloseButton: false,
  );
}

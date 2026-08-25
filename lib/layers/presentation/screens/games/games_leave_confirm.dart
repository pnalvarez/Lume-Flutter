import 'package:flutter/material.dart';
import 'package:lume/common/strings/arcade_strings.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';

/// Asks whether to leave the games sequence and discard in-session progress.
///
/// Returns `true` when the user confirms leave.
Future<bool> confirmLeaveGamesSequence(BuildContext context) async {
  final cs = Theme.of(context).colorScheme;
  final confirmed = await showLumeDialog<bool>(
    context: context,
    tone: LumeDialogTone.negative,
    barrierDismissible: true,
    title: trailSessionLeaveTitle,
    content: Text(
      trailSessionLeaveBody,
      style: typ.body4Light.copyWith(color: cs.onSurface),
    ),
    actions: [
      Builder(
        builder: (dialogContext) => LumeButton(
          label: trailSessionLeaveCancel,
          type: LumeButtonType.outlined,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
      ),
      Builder(
        builder: (dialogContext) => LumeButton(
          label: trailSessionLeaveConfirm,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ),
    ],
  );
  return confirmed ?? false;
}

/// Asks whether to end the current arcade run. Rounds already played stay
/// scored, so the copy differs from the trail session dialog.
///
/// Returns `true` when the user confirms.
Future<bool> confirmLeaveArcadeRun(BuildContext context) async {
  final cs = Theme.of(context).colorScheme;
  final confirmed = await showLumeDialog<bool>(
    context: context,
    tone: LumeDialogTone.negative,
    barrierDismissible: true,
    title: arcadeLeaveTitle,
    content: Text(
      arcadeLeaveBody,
      style: typ.body4Light.copyWith(color: cs.onSurface),
    ),
    actions: [
      Builder(
        builder: (dialogContext) => LumeButton(
          label: arcadeLeaveCancel,
          type: LumeButtonType.outlined,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
      ),
      Builder(
        builder: (dialogContext) => LumeButton(
          label: arcadeLeaveConfirm,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ),
    ],
  );
  return confirmed ?? false;
}

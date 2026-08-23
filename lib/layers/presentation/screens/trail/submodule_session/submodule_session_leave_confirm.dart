import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';

/// Asks whether to leave the submodule and discard in-session progress.
///
/// Returns `true` when the user confirms leave.
Future<bool> confirmLeaveSubmoduleSession(BuildContext context) async {
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
  return confirmed == true;
}

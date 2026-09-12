import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';

/// Submodule session complete — wraps [GamesCompleteBody] with trail copy.
class SubmoduleCompleteBody extends StatelessWidget {
  const SubmoduleCompleteBody({
    super.key,
    required this.status,
    required this.correctCount,
    required this.total,
    required this.unlockMessage,
    required this.onBackToTrail,
  });

  final GamesCompleteStatus status;
  final int correctCount;
  final int total;
  final String unlockMessage;
  final VoidCallback onBackToTrail;

  @override
  Widget build(BuildContext context) {
    return GamesCompleteBody(
      status: status,
      title: status.submoduleTitle,
      scoreText: trailSessionCompleteScore(
        correctCount: correctCount,
        total: total,
      ),
      message: unlockMessage,
      actionLabel: trailSessionBackToTrail,
      onAction: onBackToTrail,
    );
  }
}

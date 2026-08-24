import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';

/// Submodule session complete — wraps [GamesCompleteBody] with trail copy.
class SubmoduleCompleteBody extends StatelessWidget {
  const SubmoduleCompleteBody({
    super.key,
    required this.correctCount,
    required this.total,
    required this.onBackToTrail,
  });

  final int correctCount;
  final int total;
  final VoidCallback onBackToTrail;

  @override
  Widget build(BuildContext context) {
    return GamesCompleteBody(
      title: trailSessionCompleteTitle,
      scoreText: trailSessionCompleteScore(
        correctCount: correctCount,
        total: total,
      ),
      actionLabel: trailSessionBackToTrail,
      onAction: onBackToTrail,
    );
  }
}

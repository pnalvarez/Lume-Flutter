import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_body.dart';

@RoutePage()
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AchievementsBody();
  }
}

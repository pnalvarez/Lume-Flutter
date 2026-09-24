import 'package:flutter/material.dart';
import 'package:lume/app/achievement_unlock_host.dart';
import 'package:lume/app/level_up_host.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

class LumeApp extends StatelessWidget {
  const LumeApp({
    super.key,
    required this.router,
    required this.levelUpEvents,
    required this.achievementUnlockEvents,
  });

  final AppRouter router;
  final Stream<LevelUpDomain> levelUpEvents;
  final Stream<AchievementUnlockDomain> achievementUnlockEvents;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: authBrandTitle,
      theme: lumeLightTheme(),
      routerConfig: router.config(),
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return AchievementUnlockHost(
          events: achievementUnlockEvents,
          navigatorKey: router.navigatorKey,
          child: LevelUpHost(
            events: levelUpEvents,
            navigatorKey: router.navigatorKey,
            child: content,
          ),
        );
      },
    );
  }
}

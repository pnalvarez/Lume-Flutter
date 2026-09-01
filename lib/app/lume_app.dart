import 'package:flutter/material.dart';
import 'package:lume/app/level_up_host.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

class LumeApp extends StatelessWidget {
  const LumeApp({super.key, required this.router, required this.levelUpEvents});

  final AppRouter router;
  final Stream<LevelUpDomain> levelUpEvents;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: authBrandTitle,
      theme: lumeLightTheme(),
      routerConfig: router.config(),
      builder: (context, child) {
        return LevelUpHost(
          events: levelUpEvents,
          navigatorKey: router.navigatorKey,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

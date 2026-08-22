import 'package:flutter/material.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

class LumeApp extends StatelessWidget {
  const LumeApp({super.key, required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: authBrandTitle,
      theme: lumeLightTheme(),
      routerConfig: router.config(),
    );
  }
}

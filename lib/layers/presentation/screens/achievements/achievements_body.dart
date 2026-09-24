import 'package:flutter/material.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

/// Achievements stub chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class AchievementsBody extends StatelessWidget {
  const AchievementsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Text(
            achievementsUnderDevelopment,
            style: typ.body1Semibold.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

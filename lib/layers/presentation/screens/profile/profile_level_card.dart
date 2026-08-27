import 'package:flutter/material.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/badges/sparkling_badge.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';

/// Level / streak / XP summary card for the profile screen.
///
/// No Bloc, router, or GetIt — safe for Widgetbook.
class ProfileLevelCard extends StatelessWidget {
  const ProfileLevelCard({
    super.key,
    required this.playerLevel,
    required this.currentStreak,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.daysInApp,
    required this.submodulesCompleted,
    this.isLoading = false,
  });

  final int playerLevel;
  final int currentStreak;
  final int xpInLevel;
  final int xpForNextLevel;
  final int daysInApp;
  final int submodulesCompleted;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final xpForNext = xpForNextLevel <= 0 ? 1 : xpForNextLevel;
    final progress = (xpInLevel / xpForNext).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: cs.outline.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayAsLoader(
                      enabled: isLoading,
                      borderRadius: BorderRadius.circular(AppRadius.s),
                      child: Text(
                        profileLevelLabel.toUpperCase(),
                        style: typ.tagXS.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacings.xs2),
                    DisplayAsLoader(
                      enabled: isLoading,
                      borderRadius: BorderRadius.circular(AppRadius.s),
                      child: Text(
                        '$playerLevel',
                        style: typ.headlineXs.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              DisplayAsLoader(
                enabled: isLoading,
                borderRadius: BorderRadius.circular(AppRadius.xl3),
                child: SparklingBadge(
                  title: profileStreakLabel,
                  description: profileStreakValue(currentStreak),
                  variant: SparklingBadgeVariant.warm,
                  leadingIcon: SparklingBadgeIcon.flame,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.m),
          DisplayAsLoader(
            enabled: isLoading,
            borderRadius: BorderRadius.circular(AppRadius.full(8)),
            child: _LevelProgressBar(progress: progress),
          ),
          const SizedBox(height: AppSpacings.xs),
          DisplayAsLoader(
            enabled: isLoading,
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Text(
              profileXpToNextLevel(xpInLevel, xpForNextLevel),
              style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacings.m),
          Divider(height: 1, color: cs.outline.withValues(alpha: 0.6)),
          const SizedBox(height: AppSpacings.m),
          Row(
            children: [
              Expanded(
                child: DisplayAsLoader(
                  enabled: isLoading,
                  borderRadius: BorderRadius.circular(AppRadius.s),
                  child: _FooterStat(
                    icon: Icons.calendar_today_rounded,
                    label: profileDaysInAppLabel,
                    value: profileDaysInAppValue(daysInApp),
                  ),
                ),
              ),
              Expanded(
                child: DisplayAsLoader(
                  enabled: isLoading,
                  borderRadius: BorderRadius.circular(AppRadius.s),
                  child: _FooterStat(
                    label: profileSubmodulesLabel,
                    value: '$submodulesCompleted',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  const _LevelProgressBar({required this.progress});

  final double progress;

  static const double _height = 8;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full(_height)),
      child: SizedBox(
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: cs.surfaceContainerHigh),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.Accent.accent,
                      AppColors.Secondary.secondary,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterStat extends StatelessWidget {
  const _FooterStat({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = cs.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconXs, color: muted),
              const SizedBox(width: AppSpacings.xs),
            ],
            Flexible(
              child: Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typ.tagXS.copyWith(
                  color: muted,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacings.xs2),
        Text(value, style: typ.body3Semibold.copyWith(color: cs.onSurface)),
      ],
    );
  }
}

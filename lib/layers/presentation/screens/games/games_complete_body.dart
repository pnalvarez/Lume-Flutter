import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';

/// Outcome for a finished game / submodule complete screen.
enum GamesCompleteStatus {
  success,
  failure;

  /// SVG hero for [success]. [failure] uses [heroIconData] instead.
  String? get heroSvgAsset => switch (this) {
    success => AppIcons.trophy,
    failure => null,
  };

  /// Material icon hero for [failure].
  IconData? get heroIconData => switch (this) {
    success => null,
    failure => Icons.sentiment_dissatisfied_rounded,
  };

  Color get heroIconColor => switch (this) {
    success => AppColors.Accent.accent,
    failure => AppColors.Extra.rose,
  };

  IconData get badgeIcon => switch (this) {
    success => Icons.check_rounded,
    failure => Icons.close_rounded,
  };

  Color get badgeIconColor => Colors.white;

  Color get badgeFillColor => switch (this) {
    success => AppColors.Success.onSuccess,
    failure => AppColors.Extra.rose,
  };

  /// Trail copy for [SubmoduleCompleteBody].
  String get submoduleTitle => switch (this) {
    success => trailSessionCompleteTitle,
    failure => trailSessionIncompleteTitle,
  };
}

/// End-of-sequence screen for a finished game run. Bloc-free.
class GamesCompleteBody extends StatelessWidget {
  const GamesCompleteBody({
    super.key,
    required this.title,
    required this.scoreText,
    required this.actionLabel,
    required this.onAction,
    this.status = GamesCompleteStatus.success,
    this.message,
  });

  final GamesCompleteStatus status;
  final String title;
  final String scoreText;
  final String actionLabel;
  final VoidCallback onAction;

  /// Optional guidance below the score (e.g. unlock threshold).
  final String? message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -60),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        switch (status.heroSvgAsset) {
                          final asset? => SvgPicture.asset(
                            asset,
                            package: 'lume_design_system',
                            width: AppSizes.mediaWellL,
                            height: AppSizes.mediaWellL,
                            colorFilter: ColorFilter.mode(
                              status.heroIconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          null => Icon(
                            status.heroIconData,
                            size: AppSizes.mediaWellL,
                            color: status.heroIconColor,
                          ),
                        },
                        const SizedBox(height: AppSpacings.l),
                        Text.rich(
                          TextSpan(
                            style: typ.headlineS.copyWith(color: cs.onSurface),
                            children: [
                              TextSpan(text: title),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppSpacings.xs,
                                  ),
                                  child: _StatusBadge(status: status),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacings.s),
                        Text(
                          scoreText,
                          textAlign: TextAlign.center,
                          style: typ.body3Light.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        if (message != null && message!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacings.m),
                          Text(
                            message!.trim(),
                            textAlign: TextAlign.center,
                            style: typ.body4Medium.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              LumeButton(
                label: actionLabel,
                size: LumeButtonSize.lg,
                isExpanded: true,
                onPressed: onAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final GamesCompleteStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.badgeFillColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.xs),
        child: Icon(
          status.badgeIcon,
          size: AppSizes.iconXs,
          color: status.badgeIconColor,
        ),
      ),
    );
  }
}

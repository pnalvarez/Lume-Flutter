import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Semantic state for [FeedbackTile].
enum FeedbackTileState { success, warning, error }

/// Tappable feedback card with accent icon, title and subtitle.
class FeedbackTile extends StatelessWidget {
  final FeedbackTileState state;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const FeedbackTile({
    super.key,
    required this.state,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = _style(state);
    final radius = BorderRadius.circular(AppRadius.xl2);

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: style.accent, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.s,
            vertical: AppSpacings.m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: _iconSize, color: style.accent),
              const SizedBox(height: AppSpacings.xs),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typ.body3Semibold.copyWith(color: style.accent),
              ),
              const SizedBox(height: AppSpacings.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typ.body4Medium.copyWith(color: style.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({Color accent, IconData icon}) _style(FeedbackTileState state) =>
      switch (state) {
        FeedbackTileState.success => (
          accent: AppColors.Success.onSuccess,
          icon: Icons.check_circle_rounded,
        ),
        FeedbackTileState.warning => (
          accent: AppColors.Accent.onAccent,
          icon: Icons.warning_amber_rounded,
        ),
        FeedbackTileState.error => (
          accent: AppColors.Error.onError,
          icon: Icons.cancel_rounded,
        ),
      };
}

import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:flutter/material.dart';

/// Generic content card: media well, title, description, status, optional
/// progress and primary action. All copy/colors come from the caller.
class ContentCard extends StatelessWidget {
  final Widget? leading;
  final Color? leadingBackground;
  final Color? leadingRing;
  final String title;
  final String? description;
  final String? statusLabel;
  final Color? statusColor;
  final IconData? statusIcon;
  final double? progress;
  final String? progressCaption;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionSecondary;

  const ContentCard({
    super.key,
    this.leading,
    this.leadingBackground,
    this.leadingRing,
    required this.title,
    this.description,
    this.statusLabel,
    this.statusColor,
    this.statusIcon,
    this.progress,
    this.progressCaption,
    this.actionLabel,
    this.onAction,
    this.actionSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusFg = statusColor ?? cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                Container(
                  width: AppSizes.mediaWellS,
                  height: AppSizes.mediaWellS,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: leadingBackground ?? cs.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: leadingRing == null
                        ? null
                        : [
                            BoxShadow(
                              color: leadingRing!.withValues(alpha: 0.4),
                              blurRadius: 0,
                              spreadRadius: 2,
                            ),
                          ],
                  ),
                  child: leading,
                ),
                const SizedBox(width: AppSpacings.m),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: typ.subtitleS.copyWith(color: cs.onSurface),
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacings.xs),
                      Text(
                        description!,
                        style: typ.body4Light.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (statusLabel != null) ...[
                      const SizedBox(height: AppSpacings.s),
                      Row(
                        children: [
                          if (statusIcon != null) ...[
                            Icon(statusIcon, size: 12, color: statusFg),
                            const SizedBox(width: AppSpacings.xs2),
                          ],
                          Flexible(
                            child: Text(
                              statusLabel!,
                              style: typ.tagS.copyWith(
                                color: statusFg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (progress != null) ...[
                      const SizedBox(height: AppSpacings.s),
                      LumeProgressBar(
                        value: progress!.clamp(0.0, 1.0),
                        label: progressCaption,
                        height: 6,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacings.l),
            LumeButton(
              label: actionLabel!,
              onPressed: onAction,
              isExpanded: true,
              trait: actionSecondary
                  ? LumeButtonTrait.secondary
                  : LumeButtonTrait.brand,
            ),
          ],
        ],
      ),
    );
  }
}

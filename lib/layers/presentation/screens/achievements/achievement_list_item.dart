import 'package:flutter/material.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';

/// Visual state for [AchievementListItem].
enum AchievementListItemStatus { locked, inProgress, completed }

/// Dumb row for one achievement: icon/image, title, description, progress.
///
/// No Bloc, GetIt, or network — props only.
class AchievementListItem extends StatelessWidget {
  const AchievementListItem({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.target,
    this.icon = Icons.emoji_events_rounded,
    this.image,
    this.onTap,
  });

  final String title;
  final String description;
  final AchievementListItemStatus status;
  final int progress;
  final int target;
  final IconData icon;
  final ImageProvider? image;
  final VoidCallback? onTap;

  double get _progressValue {
    if (status == AchievementListItemStatus.completed) return 1;
    if (target <= 0) return 0;
    return (progress / target).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLocked = status == AchievementListItemStatus.locked;
    final isCompleted = status == AchievementListItemStatus.completed;
    final caption = achievementProgressCaption(
      isCompleted ? target : progress.clamp(0, target < 0 ? 0 : target),
      target < 0 ? 0 : target,
    );

    return ListItem(
      trait: isCompleted ? ListItemTrait.brand : ListItemTrait.neutral,
      isExpanded: true,
      onTap: isLocked ? null : onTap,
      borderRadius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacings.l),
      input: GenericListItemInput(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AchievementLeading(icon: icon, image: image, status: status),
            const SizedBox(width: AppSpacings.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: typ.body3Semibold.copyWith(
                            color: cs.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(width: AppSpacings.s),
                        Icon(
                          Icons.check_circle_rounded,
                          size: AppSizes.iconS,
                          color: AppColors.Success.onSuccess,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacings.xs),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: typ.body4Light.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s),
                  LumeProgressBar(
                    value: _progressValue,
                    height: AppSizes.progressRingStroke,
                    showPercentage: false,
                    label: caption,
                    fillColor: isCompleted
                        ? AppColors.Accent.accent
                        : AppColors.Primary.primary,
                    trackColor: cs.surfaceContainerHigh,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementLeading extends StatelessWidget {
  const _AchievementLeading({
    required this.icon,
    required this.status,
    this.image,
  });

  static const double _well = AppSizes.avatarL;

  final IconData icon;
  final ImageProvider? image;
  final AchievementListItemStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCompleted = status == AchievementListItemStatus.completed;
    final isLocked = status == AchievementListItemStatus.locked;
    final iconColor = isCompleted
        ? AppColors.Accent.accent
        : isLocked
        ? cs.onSurfaceVariant
        : AppColors.Primary.primary;

    return SizedBox(
      width: _well,
      height: _well,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _well,
            height: _well,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.Accent.accentLight
                  : AppColors.Primary.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.l),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: image != null
                ? Image(
                    image: image!,
                    width: _well,
                    height: _well,
                    fit: BoxFit.cover,
                    color: isLocked ? cs.onSurfaceVariant : null,
                    colorBlendMode: isLocked ? BlendMode.saturation : null,
                  )
                : Icon(icon, size: AppSizes.iconM, color: iconColor),
          ),
          if (isLocked)
            Positioned(
              right: -AppSpacings.xs2,
              bottom: -AppSpacings.xs2,
              child: _AchievementBadge(
                icon: Icons.lock_rounded,
                iconColor: cs.onSurfaceVariant,
                borderColor: cs.outline,
                fillColor: cs.surfaceContainerLowest,
              ),
            ),
          if (isCompleted)
            Positioned(
              right: -AppSpacings.xs2,
              bottom: -AppSpacings.xs2,
              child: _AchievementBadge(
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.Accent.accent,
                borderColor: AppColors.Accent.accent,
                fillColor: cs.surfaceContainerLowest,
              ),
            ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.fillColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.xs2),
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Icon(icon, size: AppSizes.iconXs, color: iconColor),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';

/// Generic content card: media well, title, description, status, optional
/// progress and primary action. All copy/colors come from the caller.
///
/// Thin facade over [ListItem] + [LeadingTitleDescriptionStatusCtaInput].
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
    return ListItem(
      trait: ListItemTrait.neutral,
      borderRadius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacings.xl),
      input: LeadingTitleDescriptionStatusCtaInput(
        leading: leading,
        leadingBackground: leadingBackground,
        leadingRing: leadingRing,
        title: title,
        description: description,
        statusLabel: statusLabel,
        statusColor: statusColor,
        statusIcon: statusIcon,
        progress: progress,
        progressCaption: progressCaption,
        actionLabel: actionLabel,
        onAction: onAction,
        actionSecondary: actionSecondary,
      ),
    );
  }
}

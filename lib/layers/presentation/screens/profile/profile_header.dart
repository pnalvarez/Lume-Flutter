import 'package:flutter/material.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';

/// Profile page header: avatar, name, membership line, settings + sign-out.
///
/// No Bloc, router, or GetIt — safe for Widgetbook.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.displayName,
    required this.onSettingsPressed,
    required this.onSignOutPressed,
    this.memberSince,
    this.isLoading = false,
  });

  final String displayName;

  /// Formatted membership date (e.g. `agosto de 2026`). Null shows an em dash.
  final String? memberSince;
  final VoidCallback onSettingsPressed;
  final VoidCallback onSignOutPressed;
  final bool isLoading;

  static const double _avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = displayName.isEmpty
        ? profileLoadingNamePlaceholder
        : displayName;
    final initial = _initialFor(name);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayAsLoader(
          enabled: isLoading,
          shape: BoxShape.circle,
          child: Container(
            width: _avatarSize,
            height: _avatarSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.Primary.primary,
                  AppColors.Secondary.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              initial,
              style: typ.headline2xs.copyWith(color: cs.onPrimary),
            ),
          ),
        ),
        const SizedBox(width: AppSpacings.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DisplayAsLoader(
                enabled: isLoading,
                borderRadius: BorderRadius.circular(AppRadius.s),
                child: Text(
                  profileTitle.toUpperCase(),
                  style: typ.tagXS.copyWith(
                    color: cs.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DisplayAsLoader(
                enabled: isLoading,
                borderRadius: BorderRadius.circular(AppRadius.s),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typ.headline2xs.copyWith(color: cs.onSurface),
                ),
              ),
              DisplayAsLoader(
                enabled: isLoading,
                borderRadius: BorderRadius.circular(AppRadius.s),
                child: Text(
                  profileMemberSince(memberSince),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typ.body5Light.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacings.s),
        LumeIconButton(
          icon: Icons.settings_outlined,
          size: LumeIconButtonSize.sm,
          variant: LumeIconButtonVariant.outline,
          iconColor: cs.onSurfaceVariant,
          tooltip: profileSettingsTooltip,
          onPressed: onSettingsPressed,
        ),
        const SizedBox(width: AppSpacings.xs),
        LumeIconButton(
          icon: Icons.logout_rounded,
          size: LumeIconButtonSize.sm,
          variant: LumeIconButtonVariant.outline,
          iconColor: cs.onSurfaceVariant,
          tooltip: profileSignOutTooltip,
          onPressed: onSignOutPressed,
        ),
      ],
    );
  }

  static String _initialFor(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }
}

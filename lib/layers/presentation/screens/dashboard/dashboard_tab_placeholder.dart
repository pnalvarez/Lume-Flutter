import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';

/// Temporary tab body: title + centered sign-out until the feature lands.
class DashboardTabPlaceholder extends StatelessWidget {
  const DashboardTabPlaceholder({
    super.key,
    required this.title,
    required this.isSigningOut,
    required this.onSignOut,
  });

  final String title;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: typ.body1Semibold.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppSpacings.s),
              Text(
                homeAuthenticatedMessage,
                style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacings.xl2),
              LumeButton(
                label: homeSignOut,
                type: LumeButtonType.outlined,
                isExpanded: true,
                isLoading: isSigningOut,
                isEnabled: !isSigningOut,
                onPressed: onSignOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

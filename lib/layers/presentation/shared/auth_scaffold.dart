import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';

/// Shared chrome for unauthenticated auth screens: brand well, title, card.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.subtitle,
    required this.child,
    this.onBack,
    this.brandTitle = authBrandTitle,
  });

  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;
  final String brandTitle;

  static const double _maxWidth = 400;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.xl2,
              vertical: AppSpacings.l,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onBack != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LumeIconButton(
                        icon: Icons.arrow_back_rounded,
                        onPressed: onBack,
                        size: LumeIconButtonSize.sm,
                        tooltip: authBack,
                      ),
                    ),
                  const SizedBox(height: AppSpacings.l),
                  const Center(
                    child: LumeLogo(
                      size: 112,
                      variant: LumeLogoVariant.surface,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.l),
                  Text(
                    brandTitle,
                    textAlign: TextAlign.center,
                    style: typ.headlineL.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacings.s),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacings.xl2),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadius.l),
                      border: Border.all(color: cs.outline),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacings.xl2),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
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
    this.brandTitle = 'LUME',
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
                        tooltip: 'Voltar',
                      ),
                    ),
                  const SizedBox(height: AppSpacings.l),
                  Center(
                    child: Container(
                      width: AppSizes.avatarXl,
                      height: AppSizes.avatarXl,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(AppRadius.xl2),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppIcons.sparkle,
                        package: 'lume_design_system',
                        width: AppSizes.iconL,
                        height: AppSizes.iconL,
                        colorFilter: ColorFilter.mode(
                          cs.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
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

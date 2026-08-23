import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';

/// Session complete UI. No Bloc, router, or GetIt — safe for Widgetbook.
class SubmoduleCompleteBody extends StatelessWidget {
  const SubmoduleCompleteBody({
    super.key,
    required this.correctCount,
    required this.total,
    required this.onBackToTrail,
  });

  final int correctCount;
  final int total;
  final VoidCallback onBackToTrail;

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
                        SvgPicture.asset(
                          AppIcons.trophy,
                          package: 'lume_design_system',
                          width: AppSizes.mediaWellL,
                          height: AppSizes.mediaWellL,
                          colorFilter: ColorFilter.mode(
                            AppColors.Accent.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: AppSpacings.l),
                        Text.rich(
                          TextSpan(
                            style: typ.headlineS.copyWith(color: cs.onSurface),
                            children: [
                              const TextSpan(text: trailSessionCompleteTitle),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppSpacings.xs,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.Success.onSuccess,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(AppSpacings.xs),
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: AppSizes.iconXs,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacings.s),
                        Text(
                          trailSessionCompleteScore(
                            correctCount: correctCount,
                            total: total,
                          ),
                          textAlign: TextAlign.center,
                          style: typ.body3Light.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              LumeButton(
                label: trailSessionBackToTrail,
                size: LumeButtonSize.lg,
                isExpanded: true,
                onPressed: onBackToTrail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

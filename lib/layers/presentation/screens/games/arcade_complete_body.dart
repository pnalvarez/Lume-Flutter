import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/arcade_strings.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';

/// End of an arcade run. Celebrates with a trophy when the record fell.
/// Bloc-free.
class ArcadeCompleteBody extends StatelessWidget {
  const ArcadeCompleteBody({
    super.key,
    required this.scoredCount,
    required this.record,
    required this.isNewRecord,
    required this.xpEarned,
    required this.onAction,
  });

  /// Games scored across the whole run, not a consecutive streak.
  final int scoredCount;

  /// Personal best before this run started.
  final int record;

  final bool isNewRecord;
  final int xpEarned;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final title = isNewRecord
        ? arcadeCompleteNewRecordTitle
        : arcadeCompleteTitle;
    final recordText = isNewRecord
        ? arcadeCompletePreviousRecord(record)
        : arcadeCompleteRecord(record);

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
                        if (isNewRecord)
                          SvgPicture.asset(
                            AppIcons.trophy,
                            package: 'lume_design_system',
                            width: AppSizes.mediaWellL,
                            height: AppSizes.mediaWellL,
                            colorFilter: ColorFilter.mode(
                              AppColors.Accent.accent,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          Icon(
                            Icons.sports_esports_rounded,
                            size: AppSizes.mediaWellL,
                            color: cs.onSurfaceVariant,
                          ),
                        const SizedBox(height: AppSpacings.l),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: typ.headlineS.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacings.s),
                        Text(
                          arcadeCompleteScore(scoredCount),
                          textAlign: TextAlign.center,
                          style: typ.body3Light.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacings.xs),
                        Text(
                          recordText,
                          textAlign: TextAlign.center,
                          style: typ.body4Light.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        if (xpEarned > 0) ...[
                          const SizedBox(height: AppSpacings.m),
                          Text(
                            arcadeCompleteXp(xpEarned),
                            textAlign: TextAlign.center,
                            style: typ.body4Medium.copyWith(color: cs.primary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              LumeButton(
                label: arcadeCompleteAction,
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

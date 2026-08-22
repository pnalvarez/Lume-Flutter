import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/feedback/result_banner.dart';

/// Session complete UI. No Bloc, router, or GetIt — safe for Widgetbook.
class SubmoduleCompleteBody extends StatelessWidget {
  const SubmoduleCompleteBody({
    super.key,
    required this.correctCount,
    required this.total,
    required this.onBackToTrail,
    this.progressValue = 1,
  });

  final double progressValue;
  final int correctCount;
  final int total;
  final VoidCallback onBackToTrail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scoreBody =
        '$trailSessionCompleteBodyPrefix$correctCount'
        '$trailSessionCompleteBodyMiddle$total'
        '$trailSessionCompleteBodySuffix';

    return SubmoduleSessionChrome(
      progressValue: progressValue,
      onBack: onBackToTrail,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: Column(
          children: [
            const Spacer(),
            ResultBanner(
              tone: ResultBannerTone.positive,
              title: trailSessionCompleteTitle,
              bodyText: scoreBody,
              media: Icon(
                Icons.emoji_events_rounded,
                size: 48,
                color: cs.secondary,
              ),
            ),
            const Spacer(),
            LumeButton(
              label: trailSessionBackToTrail,
              size: LumeButtonSize.lg,
              isExpanded: true,
              onPressed: onBackToTrail,
            ),
          ],
        ),
      ),
    );
  }
}

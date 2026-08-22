import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Active game step UI. No Bloc, router, or GetIt — safe for Widgetbook.
class SubmodulePlayBody extends StatelessWidget {
  const SubmodulePlayBody({
    super.key,
    required this.progressValue,
    required this.onAbandoned,
    required this.onRetry,
    this.isSaving = false,
    this.errorMessage,
    this.gameSlot,
  });

  final double progressValue;
  final bool isSaving;
  final String? errorMessage;
  final Widget? gameSlot;
  final VoidCallback onAbandoned;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SubmoduleSessionChrome(
      progressValue: progressValue,
      onBack: onAbandoned,
      body: switch ((isSaving, errorMessage)) {
        (true, _) => const Center(child: CircularLoader()),
        (_, final String message) => Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacings.l),
              LumeButton(
                label: trailSessionRetry,
                type: LumeButtonType.outlined,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
        _ => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.l),
          child: gameSlot ?? const SizedBox.shrink(),
        ),
      },
    );
  }
}

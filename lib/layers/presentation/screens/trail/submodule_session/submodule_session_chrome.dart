import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Shared submodule-session chrome (progress header). Bloc-free.
class SubmoduleSessionChrome extends StatelessWidget {
  const SubmoduleSessionChrome({
    super.key,
    required this.progressValue,
    required this.onBack,
    required this.child,
  });

  final double progressValue;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PageHeader(
        onBack: onBack,
        titleWidget: Padding(
          padding: const EdgeInsets.only(right: AppSpacings.s),
          child: LumeProgressBar(
            value: progressValue.clamp(0.0, 1.0),
            height: 8,
            showPercentage: false,
            fillColor: cs.primary,
          ),
        ),
      ),
      body: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_chrome.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Preview step UI. No Bloc, router, or GetIt — safe for Widgetbook.
class SubmodulePreviewBody extends StatelessWidget {
  const SubmodulePreviewBody({
    super.key,
    required this.isLoading,
    required this.onAbandoned,
    required this.onContinue,
    required this.onRetry,
    this.progressValue = 0,
    this.title = '',
    this.preview = '',
    this.imageUrl,
    this.errorMessage,
  });

  final bool isLoading;
  final double progressValue;
  final String title;
  final String preview;
  final String? imageUrl;
  final String? errorMessage;
  final VoidCallback onAbandoned;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SubmoduleSessionChrome(
      progressValue: progressValue,
      onBack: onAbandoned,
      child: switch ((isLoading, errorMessage)) {
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
        _ => _PreviewContent(
          title: title,
          preview: preview,
          imageUrl: imageUrl,
          onContinue: onContinue,
        ),
      },
    );
  }
}

class _PreviewContent extends StatelessWidget {
  const _PreviewContent({
    required this.preview,
    required this.onContinue,
    this.imageUrl,
    this.title = '',
  });

  final String preview;
  final String? imageUrl;
  final String title;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final image = imageUrl?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.xl2,
              AppSpacings.m,
              AppSpacings.xl2,
              AppSpacings.l,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (image != null && image.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl2),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacings.l),
                ],
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    style: typ.headingH5.copyWith(color: cs.secondary),
                  ),
                  const SizedBox(height: AppSpacings.l),
                ],
                Text(
                  preview,
                  style: typ.body3Light.copyWith(
                    color: cs.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacings.xl2,
            AppSpacings.s,
            AppSpacings.xl2,
            AppSpacings.l,
          ),
          child: LumeButton(
            label: trailPreviewContinue,
            size: LumeButtonSize.lg,
            isExpanded: true,
            onPressed: onContinue,
          ),
        ),
      ],
    );
  }
}

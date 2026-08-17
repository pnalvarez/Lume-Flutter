import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Card that displays a prompt / question / statement.
class PromptCard extends StatelessWidget {
  final String text;
  final String? eyebrow;
  final Widget? media;

  const PromptCard({
    super.key,
    required this.text,
    this.eyebrow,
    this.media,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (media != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.l),
              child: media,
            ),
            const SizedBox(height: AppSpacings.m),
          ],
          if (eyebrow != null) ...[
            Text(
              eyebrow!,
              style: typ.tagS.copyWith(
                color: cs.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacings.xs),
          ],
          Text(
            text,
            style: typ.body2Semibold.copyWith(color: cs.onSurface, height: 1.35),
          ),
        ],
      ),
    );
  }
}

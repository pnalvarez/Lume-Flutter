import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/badges/amount_badge.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:flutter/material.dart';

/// Visual tone for [ResultBanner].
enum ResultBannerTone { positive, neutral, negative }

/// Feedback panel after an interaction: headline, body, optional chip + CTA.
class ResultBanner extends StatelessWidget {
  final ResultBannerTone tone;
  final String title;
  final String? subtitle;
  final String? bodyTitle;
  final String? bodyText;
  final String? footnote;
  final Widget? amountChip;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? media;

  const ResultBanner({
    super.key,
    required this.tone,
    required this.title,
    this.subtitle,
    this.bodyTitle,
    this.bodyText,
    this.footnote,
    this.amountChip,
    this.actionLabel,
    this.onAction,
    this.media,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = _toneStyle(tone, cs);

    return Container(
      padding: const EdgeInsets.all(AppSpacings.l),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: style.border),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: style.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(style.icon, color: style.accent, size: 20),
              ),
              const SizedBox(width: AppSpacings.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: typ.body3Semibold.copyWith(color: cs.onSurface),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              ?amountChip,
            ],
          ),
          if (bodyTitle != null || bodyText != null) ...[
            const SizedBox(height: AppSpacings.m),
            Container(
              padding: const EdgeInsets.all(AppSpacings.m),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: cs.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bodyTitle != null)
                    Text(
                      bodyTitle!,
                      style: typ.tagS.copyWith(
                        color: cs.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (bodyText != null) ...[
                    if (bodyTitle != null) const SizedBox(height: AppSpacings.xs),
                    Text(
                      bodyText!,
                      style: typ.body4Light.copyWith(color: cs.onSurface),
                    ),
                  ],
                  if (footnote != null) ...[
                    const SizedBox(height: AppSpacings.s),
                    Text(
                      footnote!,
                      style: typ.body4Light.copyWith(
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacings.m),
            LumeButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }

  /// Convenience: amount chip using [AmountBadge].
  static Widget amount({
    required String text,
    IconData icon = Icons.bolt_rounded,
    Color? accentColor,
  }) =>
      AmountBadge(text: text, icon: icon, accentColor: accentColor);

  ({Color bg, Color border, Color iconBg, Color accent, IconData icon})
      _toneStyle(ResultBannerTone tone, ColorScheme cs) => switch (tone) {
        ResultBannerTone.positive => (
            bg: AppColors.Success.successContainer,
            border: AppColors.Success.success.withValues(alpha: 0.45),
            iconBg: AppColors.Success.success.withValues(alpha: 0.35),
            accent: AppColors.Success.onSuccess,
            icon: Icons.check_rounded,
          ),
        ResultBannerTone.neutral => (
            bg: AppColors.Accent.accentLight,
            border: AppColors.Accent.accent.withValues(alpha: 0.45),
            iconBg: AppColors.Accent.accent.withValues(alpha: 0.3),
            accent: AppColors.Accent.onAccent,
            icon: Icons.undo_rounded,
          ),
        ResultBannerTone.negative => (
            bg: AppColors.Error.errorContainer,
            border: AppColors.Error.error.withValues(alpha: 0.55),
            iconBg: AppColors.Error.error.withValues(alpha: 0.4),
            accent: AppColors.Error.onError,
            icon: Icons.close_rounded,
          ),
      };
}

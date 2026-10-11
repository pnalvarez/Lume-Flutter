import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Pins the image well for catalogs and tests.
///
/// When null, the card resolves [ArtworkPromptCard.image] or
/// [ArtworkPromptCard.imageUrl] and shows loading or error on its own.
enum ArtworkPromptImagePhase { loading, error }

/// Question above a fixed 4:3 artwork image, with loading and error wells.
class ArtworkPromptCard extends StatelessWidget {
  final String question;
  final String? imageUrl;
  final ImageProvider? image;
  final ArtworkPromptImagePhase? phase;

  /// Width / height of the artwork frame.
  static const double aspectRatio = 4 / 3;

  const ArtworkPromptCard({
    super.key,
    required this.question,
    this.imageUrl,
    this.image,
    this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacings.xl),
      decoration: BoxDecoration(
        color: AppColors.Primary.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            style: typ.body3Semibold.copyWith(color: cs.onSurface, height: 1.4),
          ),
          const SizedBox(height: AppSpacings.m),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.l),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: _ArtworkWell(
                imageUrl: imageUrl,
                image: image,
                phase: phase,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtworkWell extends StatelessWidget {
  final String? imageUrl;
  final ImageProvider? image;
  final ArtworkPromptImagePhase? phase;

  const _ArtworkWell({this.imageUrl, this.image, this.phase});

  @override
  Widget build(BuildContext context) {
    if (phase == ArtworkPromptImagePhase.loading) {
      return const _ArtworkPlaceholder(loading: true);
    }
    if (phase == ArtworkPromptImagePhase.error) {
      return const _ArtworkPlaceholder(loading: false);
    }

    final provider = image ?? _networkImage(imageUrl);
    if (provider == null) {
      return const _ArtworkPlaceholder(loading: false);
    }

    return Image(
      image: provider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return const _ArtworkPlaceholder(loading: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ArtworkPlaceholder(loading: false);
      },
    );
  }

  static ImageProvider? _networkImage(String? url) {
    final resolved = url?.trim();
    if (resolved == null || resolved.isEmpty) return null;
    return NetworkImage(resolved);
  }
}

class _ArtworkPlaceholder extends StatelessWidget {
  final bool loading;

  const _ArtworkPlaceholder({required this.loading});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: loading
            ? const CircularLoader()
            : Icon(
                Icons.image_not_supported_outlined,
                size: AppSizes.iconL,
                color: cs.onSurfaceVariant,
              ),
      ),
    );
  }
}

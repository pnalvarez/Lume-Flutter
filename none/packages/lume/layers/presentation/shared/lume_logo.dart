import 'package:flutter/material.dart';

/// How the asset's baked-in white plate is treated.
enum LumeLogoVariant {
  /// Keep the white plate. Use on white canvases (splash).
  white,

  /// Recolor the white plate to [ColorScheme.surface]. Use on themed pages.
  surface,
}

/// Brand mark for Lume (sparkle + glint).
class LumeLogo extends StatelessWidget {
  const LumeLogo({
    super.key,
    this.size = 96,
    this.variant = LumeLogoVariant.white,
  });

  static const assetPath = 'assets/branding/lume_logo.png';

  final double size;
  final LumeLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Lume',
      color: variant == LumeLogoVariant.surface
          ? Theme.of(context).colorScheme.surface
          : null,
      colorBlendMode: BlendMode.modulate,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

OverlayEntry? _loadingOverlayEntry;

/// Full-screen translucent scrim with a centered [CircularLoader].
///
/// Blocks interaction via [AbsorbPointer]. Prefer [showLumeLoadingOverlay] /
/// [hideLumeLoadingOverlay] so the overlay sits above the whole app.
class LumeLoadingOverlay extends StatelessWidget {
  const LumeLoadingOverlay({super.key, this.scrimOpacity = 0.72});

  /// Opacity of the surface-colored scrim (0–1).
  final double scrimOpacity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AbsorbPointer(
      child: Material(
        color: cs.surface.withValues(alpha: scrimOpacity),
        child: const Center(child: CircularLoader()),
      ),
    );
  }
}

/// Inserts [LumeLoadingOverlay] on the root [Overlay], above all routes.
///
/// No-op when an overlay is already visible. Pass a [BuildContext] attached to
/// an [Overlay] (typically any route context).
void showLumeLoadingOverlay(
  BuildContext context, {
  double scrimOpacity = 0.72,
}) {
  if (_loadingOverlayEntry != null) return;

  final overlay = Overlay.of(context, rootOverlay: true);
  _loadingOverlayEntry = OverlayEntry(
    builder: (context) => LumeLoadingOverlay(scrimOpacity: scrimOpacity),
  );
  overlay.insert(_loadingOverlayEntry!);
}

/// Removes the overlay inserted by [showLumeLoadingOverlay], if any.
void hideLumeLoadingOverlay() {
  _loadingOverlayEntry?.remove();
  _loadingOverlayEntry = null;
}

/// Whether [showLumeLoadingOverlay] currently has an active entry.
bool get isLumeLoadingOverlayVisible => _loadingOverlayEntry != null;

/// Clears overlay state — for tests only.
@visibleForTesting
void resetLumeLoadingOverlayForTest() {
  hideLumeLoadingOverlay();
}

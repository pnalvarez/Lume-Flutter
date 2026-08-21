import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Visual state for a path / timeline node.
enum PathNodeState { locked, idle, active, done }

/// Circular node used in vertical learning paths / timelines.
class PathNode extends StatelessWidget {
  final PathNodeState state;
  final String label;
  final String? subtitle;
  final Widget? child;
  final VoidCallback? onTap;
  final Color? accentColor;

  const PathNode({
    super.key,
    required this.state,
    required this.label,
    this.subtitle,
    this.child,
    this.onTap,
    this.accentColor,
  });

  static const double _nodeSize = 56;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = accentColor ?? cs.primary;
    final (Color bg, Color fg, Color ring) = switch (state) {
      PathNodeState.locked => (
        cs.surfaceContainerHigh,
        cs.onSurfaceVariant.withValues(alpha: 0.5),
        cs.outline,
      ),
      PathNodeState.idle => (
        cs.surfaceContainerLowest,
        cs.onSurface,
        cs.outline,
      ),
      PathNodeState.active => (accent, cs.onPrimary, accent),
      PathNodeState.done => (
        cs.secondaryContainer,
        cs.onSecondaryContainer,
        cs.secondary,
      ),
    };

    final enabled = state != PathNodeState.locked && onTap != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: bg,
          shape: CircleBorder(side: BorderSide(color: ring, width: 2)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onTap : null,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: _nodeSize,
              child: Center(
                child:
                    child ??
                    Icon(
                      switch (state) {
                        PathNodeState.locked => Icons.lock_rounded,
                        PathNodeState.done => Icons.check_rounded,
                        PathNodeState.active => Icons.play_arrow_rounded,
                        PathNodeState.idle => Icons.circle_outlined,
                      },
                      color: fg,
                      size: AppSizes.iconM,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacings.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: typ.body3Semibold.copyWith(
                  color: state == PathNodeState.locked
                      ? cs.onSurfaceVariant
                      : cs.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Vertical connector between [PathNode]s.
class PathConnector extends StatelessWidget {
  final double height;
  final Color? color;
  final bool dashed;

  const PathConnector({
    super.key,
    this.height = 28,
    this.color,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final line = color ?? cs.outline;

    return Padding(
      padding: const EdgeInsets.only(left: (_nodePad)),
      child: SizedBox(
        height: height,
        width: AppSizes.connectorWidth,
        child: CustomPaint(
          painter: _ConnectorPainter(color: line, dashed: dashed),
        ),
      ),
    );
  }

  /// Centers the connector under a 56px node.
  static const double _nodePad = (56 - AppSizes.connectorWidth) / 2;
}

class _ConnectorPainter extends CustomPainter {
  final Color color;
  final bool dashed;

  _ConnectorPainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.round;

    if (!dashed) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      );
      return;
    }

    const dash = 4.0;
    const gap = 4.0;
    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, (y + dash).clamp(0, size.height)),
        paint,
      );
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorPainter old) =>
      old.color != color || old.dashed != dashed;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/motion/motion.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';

/// Modal shown when the player crosses a level threshold.
///
/// [xpOffset] is the cumulative XP at which [level] starts.
/// [xpForNextLevel] is the cumulative XP needed to reach the next level.
/// Progress is `(currentXp - xpOffset) / (xpForNextLevel - xpOffset)`.
class LevelUpAlert extends StatefulWidget {
  const LevelUpAlert({
    super.key,
    required this.level,
    required this.xpOffset,
    required this.currentXp,
    required this.xpForNextLevel,
    this.onContinue,
  });

  factory LevelUpAlert.fromDomain(
    LevelUpDomain levelUp, {
    Key? key,
    VoidCallback? onContinue,
  }) {
    return LevelUpAlert(
      key: key,
      level: levelUp.level,
      xpOffset: levelUp.xpOffset,
      currentXp: levelUp.currentXp,
      xpForNextLevel: levelUp.xpForNextLevel,
      onContinue: onContinue,
    );
  }

  final int level;
  final int xpOffset;
  final int currentXp;
  final int xpForNextLevel;
  final VoidCallback? onContinue;

  double get progress {
    final span = xpForNextLevel - xpOffset;
    if (span <= 0) return 1.0;
    return ((currentXp - xpOffset) / span).clamp(0.0, 1.0);
  }

  @override
  State<LevelUpAlert> createState() => _LevelUpAlertState();
}

class _LevelUpAlertState extends State<LevelUpAlert>
    with TickerProviderStateMixin {
  static final Duration _confettiPeriod = AppMotion.xxSlow * 2;

  AnimationController? _confetti;
  AnimationController? _fillController;
  Animation<double>? _fill;

  void _ensureAnimations() {
    if (_confetti != null && _fillController != null && _fill != null) {
      return;
    }
    _confetti?.dispose();
    _fillController?.dispose();

    final confetti = AnimationController(
      vsync: this,
      duration: _confettiPeriod,
    );
    final fillController = AnimationController(
      vsync: this,
      duration: AppMotion.xxSlow,
    );
    final fill = CurvedAnimation(
      parent: fillController,
      curve: AppMotion.decelerate,
    );

    _confetti = confetti;
    _fillController = fillController;
    _fill = fill;

    if (MediaQuery.disableAnimationsOf(context)) {
      fillController.value = 1;
    } else {
      confetti.repeat();
      fillController.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create here (not initState) so MediaQuery is available, and so hot reload
    // that preserves State without re-running initState can recover.
    _ensureAnimations();
    if (!MediaQuery.disableAnimationsOf(context)) return;
    _confetti?.stop();
    _fillController?.value = 1;
  }

  @override
  void dispose() {
    _confetti?.dispose();
    _fillController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureAnimations();
    final confetti = _confetti!;
    final fill = _fill!;
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacings.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: Border.all(color: cs.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: _TrophyWithConfetti(
                animation: confetti,
                trophyColor: cs.primary,
              ),
            ),
            const SizedBox(height: AppSpacings.m),
            Text(
              xpLevelUpHeadline(widget.level),
              textAlign: TextAlign.center,
              style: typ.headlineXs.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: AppSpacings.m),
            AnimatedBuilder(
              animation: fill,
              builder: (context, _) {
                return LumeProgressBar(
                  value: (widget.progress * fill.value).clamp(0.0, 1.0),
                  showPercentage: false,
                );
              },
            ),
            const SizedBox(height: AppSpacings.m),
            Text(
              xpLevelUpDescription(widget.currentXp, widget.xpForNextLevel),
              textAlign: TextAlign.center,
              style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacings.xl),
            LumeButton(
              label: xpLevelUpContinue,
              onPressed: widget.onContinue,
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrophyWithConfetti extends StatelessWidget {
  const _TrophyWithConfetti({
    required this.animation,
    required this.trophyColor,
  });

  final Animation<double> animation;
  final Color trophyColor;

  static const double _well = AppSizes.mediaWellL * 2;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = [
      cs.tertiary,
      AppColors.Extra.amber,
      AppColors.Accent.accent,
      AppColors.Accent.accentLight,
    ];

    return SizedBox(
      width: _well,
      height: _well,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ConfettiPainter(
              progress: animation.value,
              colors: colors,
            ),
            child: child,
          );
        },
        child: Center(
          child: SvgPicture.asset(
            AppIcons.trophy,
            package: 'lume_design_system',
            width: AppSizes.mediaWellM,
            height: AppSizes.mediaWellM,
            colorFilter: ColorFilter.mode(trophyColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  const _ConfettiPiece({
    required this.angle,
    required this.distance,
    required this.width,
    required this.height,
    required this.spin,
    required this.colorIndex,
    required this.phase,
    required this.isRect,
  });

  final double angle;
  final double distance;
  final double width;
  final double height;
  final double spin;
  final int colorIndex;
  final double phase;
  final bool isRect;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  static final List<_ConfettiPiece> _pieces = List.generate(18, (i) {
    return _ConfettiPiece(
      angle: i * math.pi * 2 / 9 + (i.isEven ? 0.18 : -0.12),
      distance: AppSizes.iconL + (i % 5) * AppSpacings.s,
      width: AppSpacings.s - (i % 3),
      height: AppSpacings.m - (i % 4),
      spin: (i.isEven ? 1.0 : -1.0) * (1.4 + (i % 3) * 0.5),
      colorIndex: i % 4,
      phase: (i * 0.08) % 1,
      isRect: i % 3 != 0,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final piece in _pieces) {
      final t = (progress + piece.phase) % 1.0;
      final burst = Curves.easeOut.transform(t);
      final radius = AppSpacings.m + burst * piece.distance;
      final fadeIn = t < 0.12 ? t / 0.12 : 1.0;
      final fadeOut = t > 0.7 ? (1 - t) / 0.3 : 1.0;
      final opacity = (fadeIn * fadeOut).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      canvas.save();
      canvas.translate(
        center.dx + math.cos(piece.angle) * radius,
        center.dy + math.sin(piece.angle) * radius - burst * AppSpacings.s,
      );
      canvas.rotate(piece.spin * t * math.pi * 2);
      final paint = Paint()
        ..color = colors[piece.colorIndex].withValues(alpha: opacity);
      if (piece.isRect) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: piece.width,
              height: piece.height,
            ),
            const Radius.circular(AppRadius.xs4),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, piece.width / 2, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}

/// Presents [LevelUpAlert] as a modal dialog.
Future<void> showLevelUpDialog(BuildContext context, LevelUpDomain levelUp) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) => LevelUpAlert.fromDomain(
      levelUp,
      onContinue: () => Navigator.of(ctx).pop(),
    ),
  );
}

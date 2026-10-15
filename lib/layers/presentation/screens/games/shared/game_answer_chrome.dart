import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';

/// Shared game layout: scrollable [child], feedback as a dialog when answered,
/// and a pinned [trailGameNext] CTA (outside the scroll).
///
/// No Bloc / GetIt / AutoRoute — safe for Widgetbook bodies.
class GameAnswerChrome extends StatefulWidget {
  const GameAnswerChrome({
    super.key,
    required this.answered,
    required this.isCorrect,
    required this.onNext,
    required this.child,
    this.explanation,
    this.correctAnswer,
  });

  final bool answered;
  final bool isCorrect;
  final String? explanation;
  final String? correctAnswer;
  final VoidCallback onNext;
  final Widget child;

  @override
  State<GameAnswerChrome> createState() => _GameAnswerChromeState();
}

class _GameAnswerChromeState extends State<GameAnswerChrome> {
  bool _feedbackDialogShown = false;
  bool _dialogVisible = false;
  bool _dismissScheduled = false;
  NavigatorState? _rootNavigator;
  Route<dynamic>? _dialogRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rootNavigator = Navigator.of(context, rootNavigator: true);
  }

  @override
  void initState() {
    super.initState();
    if (widget.answered) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _presentFeedback());
    }
  }

  @override
  void didUpdateWidget(covariant GameAnswerChrome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answered && !widget.answered) {
      _feedbackDialogShown = false;
      _scheduleDismiss();
    }
    if (!oldWidget.answered &&
        widget.answered &&
        !_feedbackDialogShown &&
        !_dialogVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _presentFeedback());
    }
  }

  @override
  void dispose() {
    // Pop only the feedback route, on the next frame. canPop() from dispose
    // can pop the session itself and re-enter PopScope.
    _scheduleDismiss();
    super.dispose();
  }

  void _scheduleDismiss() {
    if (!_dialogVisible || _dismissScheduled) return;
    _dismissScheduled = true;
    final route = _dialogRoute;
    final navigator = _rootNavigator;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dismissScheduled = false;
      _removeDialogRoute(route, navigator);
      if (mounted &&
          widget.answered &&
          !_feedbackDialogShown &&
          !_dialogVisible) {
        _presentFeedback();
      }
    });
  }

  void _dismissFeedbackDialog() {
    _removeDialogRoute(_dialogRoute, _rootNavigator);
  }

  void _removeDialogRoute(Route<dynamic>? route, NavigatorState? navigator) {
    if (!_dialogVisible && (route == null || !route.isActive)) return;
    _dialogVisible = false;
    if (identical(_dialogRoute, route)) _dialogRoute = null;
    if (route == null || !route.isActive || navigator == null) return;
    if (!navigator.mounted) return;
    navigator.removeRoute(route);
  }

  Future<void> _presentFeedback() async {
    if (_feedbackDialogShown ||
        _dialogVisible ||
        _dismissScheduled ||
        !mounted ||
        !widget.answered) {
      return;
    }
    _feedbackDialogShown = true;

    final cs = Theme.of(context).colorScheme;
    final explanation = widget.explanation?.trim();
    final correctAnswer = widget.correctAnswer?.trim();
    final hasExplanation = explanation != null && explanation.isNotEmpty;
    final hasCorrectAnswer = correctAnswer != null && correctAnswer.isNotEmpty;
    final hasContent = hasExplanation || hasCorrectAnswer;

    _dialogVisible = true;
    try {
      await showLumeDialog<void>(
        context: context,
        useRootNavigator: true,
        tone: widget.isCorrect
            ? LumeDialogTone.positive
            : LumeDialogTone.negative,
        title: widget.isCorrect ? trailGameCorrect : trailGameWrong,
        barrierDismissible: true,
        content: Builder(
          builder: (dialogContext) {
            final route = ModalRoute.of(dialogContext);
            _dialogRoute = route;
            if (!mounted || !widget.answered || !_dialogVisible) {
              final dialogNavigator = Navigator.of(dialogContext);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (route != null &&
                    route.isActive &&
                    dialogNavigator.mounted) {
                  dialogNavigator.removeRoute(route);
                }
              });
            }
            if (!hasContent) return const SizedBox.shrink();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasCorrectAnswer)
                  Text(
                    '$trailGameCorrectAnswerLabel $correctAnswer',
                    style: typ.body3Semibold.copyWith(color: cs.onSurface),
                  ),
                if (hasCorrectAnswer && hasExplanation)
                  const SizedBox(height: AppSpacings.s),
                if (hasExplanation)
                  Text(
                    explanation,
                    style: typ.body4Light.copyWith(color: cs.onSurface),
                  ),
              ],
            );
          },
        ),
        actions: [
          Builder(
            builder: (dialogContext) => LumeButton(
              label: trailGameFeedbackDismiss,
              type: LumeButtonType.outlined,
              trait: widget.isCorrect
                  ? LumeButtonTrait.success
                  : LumeButtonTrait.destructive,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ),
        ],
      );
    } finally {
      _dialogVisible = false;
    }
  }

  void _handleNext() {
    _dismissFeedbackDialog();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacings.l),
            child: widget.child,
          ),
        ),
        if (widget.answered)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                AppSpacings.s,
                0,
                AppSpacings.l,
              ),
              child: LumeButton(
                label: trailGameNext,
                size: LumeButtonSize.lg,
                isExpanded: true,
                onPressed: _handleNext,
              ),
            ),
          ),
      ],
    );
  }
}

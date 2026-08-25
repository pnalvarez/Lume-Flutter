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
  NavigatorState? _rootNavigator;

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
    if (!oldWidget.answered && widget.answered && !_feedbackDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _presentFeedback());
    }
    if (!widget.answered) {
      _feedbackDialogShown = false;
    }
  }

  @override
  void dispose() {
    // Never pop the navigator from dispose — canPop() may pop the session
    // route itself and re-enter PopScope handlers.
    _dialogVisible = false;
    super.dispose();
  }

  void _dismissFeedbackDialog() {
    if (!_dialogVisible) return;
    _dialogVisible = false;
    final navigator = _rootNavigator;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _presentFeedback() async {
    if (_feedbackDialogShown || !mounted || !widget.answered) return;
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
        content: hasContent
            ? Column(
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
              )
            : const SizedBox.shrink(),
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

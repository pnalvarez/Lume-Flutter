import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_bloc.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_body.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_event.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_state.dart';

/// Thin wrapper that owns the bloc wiring for the factory (not a RoutePage).
///
/// Starts the bloc once in [initState] — never from [build] — and closes it
/// on dispose to avoid restart loops / leaked subscriptions.
class LightningQuizPlay extends StatefulWidget {
  const LightningQuizPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final LightningQuizBloc bloc;
  final LightningQuizGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<LightningQuizPlay> createState() => _LightningQuizPlayState();
}

class _LightningQuizPlayState extends State<LightningQuizPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(LightningQuizStarted(widget.game));
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocConsumer<LightningQuizBloc, LightningQuizState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return LightningQuizBody(
            state: state,
            onOptionSelected: (id) {
              context.read<LightningQuizBloc>().add(
                LightningQuizOptionSelected(id),
              );
            },
            onNext: () {
              context.read<LightningQuizBloc>().add(
                const LightningQuizNextPressed(),
              );
            },
          );
        },
      ),
    );
  }
}

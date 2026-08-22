import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_bloc.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_body.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_event.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_state.dart';

class CompleteSentencePlay extends StatefulWidget {
  const CompleteSentencePlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final CompleteSentenceBloc bloc;
  final CompleteSentenceGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<CompleteSentencePlay> createState() => _CompleteSentencePlayState();
}

class _CompleteSentencePlayState extends State<CompleteSentencePlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(CompleteSentenceStarted(widget.game));
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
      child: BlocConsumer<CompleteSentenceBloc, CompleteSentenceState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return CompleteSentenceBody(
            state: state,
            onBlankSelected: (blankOrder, option) {
              context.read<CompleteSentenceBloc>().add(
                CompleteSentenceBlankSelected(
                  blankOrder: blankOrder,
                  option: option,
                ),
              );
            },
            onSubmit: () {
              context.read<CompleteSentenceBloc>().add(
                const CompleteSentenceSubmit(),
              );
            },
            onNext: () {
              context.read<CompleteSentenceBloc>().add(
                const CompleteSentenceNext(),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_bloc.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_body.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_event.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';

class MysteriousWordPlay extends StatefulWidget {
  const MysteriousWordPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final MysteriousWordBloc bloc;
  final MysteriousWordGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<MysteriousWordPlay> createState() => _MysteriousWordPlayState();
}

class _MysteriousWordPlayState extends State<MysteriousWordPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(MysteriousWordStarted(widget.game));
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
      child: BlocConsumer<MysteriousWordBloc, MysteriousWordState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return MysteriousWordBody(
            state: state,
            onLetterPressed: (letter) {
              context.read<MysteriousWordBloc>().add(
                MysteriousWordLetterPressed(letter),
              );
            },
            onNext: () {
              context.read<MysteriousWordBloc>().add(
                const MysteriousWordNext(),
              );
            },
          );
        },
      ),
    );
  }
}

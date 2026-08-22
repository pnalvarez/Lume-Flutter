import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_bloc.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_body.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_event.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_state.dart';

class TrueOrMythPlay extends StatefulWidget {
  const TrueOrMythPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final TrueOrMythBloc bloc;
  final TrueOrMythGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<TrueOrMythPlay> createState() => _TrueOrMythPlayState();
}

class _TrueOrMythPlayState extends State<TrueOrMythPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(TrueOrMythStarted(widget.game));
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
      child: BlocConsumer<TrueOrMythBloc, TrueOrMythState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return TrueOrMythBody(
            state: state,
            onOptionSelected: (id) {
              context.read<TrueOrMythBloc>().add(TrueOrMythOptionSelected(id));
            },
            onNext: () {
              context.read<TrueOrMythBloc>().add(
                const TrueOrMythNextPressed(),
              );
            },
          );
        },
      ),
    );
  }
}

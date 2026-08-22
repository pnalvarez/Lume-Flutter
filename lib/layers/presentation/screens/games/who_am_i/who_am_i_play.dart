import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_bloc.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_body.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_event.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_state.dart';

class WhoAmIPlay extends StatefulWidget {
  const WhoAmIPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final WhoAmIBloc bloc;
  final WhoAmIGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<WhoAmIPlay> createState() => _WhoAmIPlayState();
}

class _WhoAmIPlayState extends State<WhoAmIPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(WhoAmIStarted(widget.game));
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
      child: BlocConsumer<WhoAmIBloc, WhoAmIState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return WhoAmIBody(
            state: state,
            onAnswerChanged: (value) {
              context.read<WhoAmIBloc>().add(WhoAmIAnswerChanged(value));
            },
            onRevealHint: () {
              context.read<WhoAmIBloc>().add(const WhoAmIRevealHint());
            },
            onSubmit: () {
              context.read<WhoAmIBloc>().add(const WhoAmISubmit());
            },
            onNext: () {
              context.read<WhoAmIBloc>().add(const WhoAmINext());
            },
          );
        },
      ),
    );
  }
}

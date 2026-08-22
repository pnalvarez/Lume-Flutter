import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_bloc.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_body.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_event.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';

class ConnectionsPlay extends StatefulWidget {
  const ConnectionsPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final ConnectionsBloc bloc;
  final ConnectionsGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<ConnectionsPlay> createState() => _ConnectionsPlayState();
}

class _ConnectionsPlayState extends State<ConnectionsPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(ConnectionsStarted(widget.game));
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
      child: BlocConsumer<ConnectionsBloc, ConnectionsState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return ConnectionsBody(
            state: state,
            onLeftSelected: (id) {
              context.read<ConnectionsBloc>().add(ConnectionsLeftSelected(id));
            },
            onRightSelected: (id) {
              context.read<ConnectionsBloc>().add(
                ConnectionsRightSelected(id),
              );
            },
            onSubmit: () {
              context.read<ConnectionsBloc>().add(const ConnectionsSubmit());
            },
            onNext: () {
              context.read<ConnectionsBloc>().add(const ConnectionsNext());
            },
          );
        },
      ),
    );
  }
}

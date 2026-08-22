import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_bloc.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_body.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_event.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_state.dart';

class TimelinePlay extends StatefulWidget {
  const TimelinePlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final TimelineBloc bloc;
  final TimelineGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<TimelinePlay> createState() => _TimelinePlayState();
}

class _TimelinePlayState extends State<TimelinePlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(TimelineStarted(widget.game));
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
      child: BlocConsumer<TimelineBloc, TimelineState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return TimelineBody(
            state: state,
            onOptionSelected: (id) {
              context.read<TimelineBloc>().add(TimelineOptionSelected(id));
            },
            onNext: () {
              context.read<TimelineBloc>().add(const TimelineNextPressed());
            },
          );
        },
      ),
    );
  }
}

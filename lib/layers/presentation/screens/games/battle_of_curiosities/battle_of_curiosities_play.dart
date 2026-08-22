import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_bloc.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_body.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_event.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_state.dart';

class BattleOfCuriositiesPlay extends StatefulWidget {
  const BattleOfCuriositiesPlay({
    super.key,
    required this.bloc,
    required this.game,
    required this.onFinished,
  });

  final BattleOfCuriositiesBloc bloc;
  final BattleOfCuriositiesGameDomain game;
  final ValueChanged<bool> onFinished;

  @override
  State<BattleOfCuriositiesPlay> createState() =>
      _BattleOfCuriositiesPlayState();
}

class _BattleOfCuriositiesPlayState extends State<BattleOfCuriositiesPlay> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(BattleOfCuriositiesStarted(widget.game));
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
      child: BlocConsumer<BattleOfCuriositiesBloc, BattleOfCuriositiesState>(
        listenWhen: (previous, current) =>
            !previous.finished && current.finished,
        listener: (context, state) => widget.onFinished(state.isCorrect),
        builder: (context, state) {
          return BattleOfCuriositiesBody(
            state: state,
            onOptionSelected: (id) {
              context.read<BattleOfCuriositiesBloc>().add(
                BattleOfCuriositiesOptionSelected(id),
              );
            },
            onNext: () {
              context.read<BattleOfCuriositiesBloc>().add(
                const BattleOfCuriositiesNextPressed(),
              );
            },
          );
        },
      ),
    );
  }
}

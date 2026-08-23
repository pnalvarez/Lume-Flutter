import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_event.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';

@injectable
final class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  ConnectionsBloc() : super(const ConnectionsState()) {
    on<ConnectionsStarted>(_onStarted);
    on<ConnectionsLeftSelected>(_onLeftSelected);
    on<ConnectionsRightSelected>(_onRightSelected);
    on<ConnectionsUndoLast>(_onUndoLast);
    on<ConnectionsSubmit>(_onSubmit);
    on<ConnectionsNext>(_onNext);
  }

  void _onStarted(ConnectionsStarted event, Emitter<ConnectionsState> emit) {
    emit(ConnectionsState(game: event.game));
  }

  void _onLeftSelected(
    ConnectionsLeftSelected event,
    Emitter<ConnectionsState> emit,
  ) {
    if (state.game == null || state.answered) return;
    emit(state.copyWith(selectedLeftId: event.leftId));
  }

  void _onRightSelected(
    ConnectionsRightSelected event,
    Emitter<ConnectionsState> emit,
  ) {
    final leftId = state.selectedLeftId;
    if (state.game == null || state.answered || leftId == null) return;

    final nextLinks = Map<String, String>.from(state.links);

    // A right item can only belong to one pair.
    nextLinks.removeWhere(
      (key, value) => value == event.rightId && key != leftId,
    );
    nextLinks[leftId] = event.rightId;

    final nextOrder = state.linkOrder
        .where(nextLinks.containsKey)
        .toList(growable: true);
    if (!nextOrder.contains(leftId)) {
      nextOrder.add(leftId);
    }

    emit(
      state.copyWith(
        links: nextLinks,
        linkOrder: nextOrder,
        clearSelectedLeft: true,
      ),
    );
  }

  void _onUndoLast(ConnectionsUndoLast event, Emitter<ConnectionsState> emit) {
    if (!state.canUndoLast) return;
    final lastLeft = state.linkOrder.last;
    final nextLinks = Map<String, String>.from(state.links)..remove(lastLeft);
    final nextOrder = List<String>.from(state.linkOrder)..removeLast();
    emit(
      state.copyWith(
        links: nextLinks,
        linkOrder: nextOrder,
        clearSelectedLeft: true,
      ),
    );
  }

  void _onSubmit(ConnectionsSubmit event, Emitter<ConnectionsState> emit) {
    final game = state.game;
    if (game == null || state.answered) return;
    if (state.links.length < game.leftColumn.length) return;

    final correct = game.pairs.every(
      (pair) => state.links[pair.leftId] == pair.rightId,
    );
    emit(state.copyWith(answered: true, isCorrect: correct));
  }

  void _onNext(ConnectionsNext event, Emitter<ConnectionsState> emit) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}

import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
final class ConnectionsState {
  const ConnectionsState({
    this.game,
    this.selectedLeftId,
    this.links = const {},
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  final ConnectionsGameDomain? game;
  final String? selectedLeftId;
  final Map<String, String> links;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  ConnectionsState copyWith({
    ConnectionsGameDomain? game,
    String? selectedLeftId,
    bool clearSelectedLeft = false,
    Map<String, String>? links,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return ConnectionsState(
      game: game ?? this.game,
      selectedLeftId:
          clearSelectedLeft ? null : (selectedLeftId ?? this.selectedLeftId),
      links: links ?? this.links,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ConnectionsState &&
      other.game == game &&
      other.selectedLeftId == selectedLeftId &&
      mapEquals(other.links, links) &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode => Object.hash(
    game,
    selectedLeftId,
    Object.hashAll(links.entries.map((e) => Object.hash(e.key, e.value))),
    answered,
    isCorrect,
    finished,
  );
}

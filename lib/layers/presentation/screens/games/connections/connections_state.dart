import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

enum ConnectionsChipVisual { idle, selected, linked, positive, negative }

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

  bool get allLinked {
    final left = game?.leftColumn;
    if (left == null) return false;
    return links.length >= left.length;
  }

  bool get canSelectRight => !answered && selectedLeftId != null;

  ConnectionsChipVisual leftVisual(String id) {
    if (answered) {
      final linkedRight = links[id];
      String? expected;
      for (final pair in game?.pairs ?? const []) {
        if (pair.leftId == id) {
          expected = pair.rightId;
          break;
        }
      }
      if (linkedRight != null && linkedRight == expected) {
        return ConnectionsChipVisual.positive;
      }
      return ConnectionsChipVisual.negative;
    }
    if (selectedLeftId == id) return ConnectionsChipVisual.selected;
    if (links.containsKey(id)) return ConnectionsChipVisual.linked;
    return ConnectionsChipVisual.idle;
  }

  ConnectionsChipVisual rightVisual(String id) {
    if (answered) {
      String? expectedLeft;
      for (final pair in game?.pairs ?? const []) {
        if (pair.rightId == id) {
          expectedLeft = pair.leftId;
          break;
        }
      }
      if (expectedLeft == null) return ConnectionsChipVisual.idle;
      if (links[expectedLeft] == id) return ConnectionsChipVisual.positive;
      if (links.values.contains(id)) return ConnectionsChipVisual.negative;
      return ConnectionsChipVisual.idle;
    }
    if (links.values.contains(id)) return ConnectionsChipVisual.linked;
    return ConnectionsChipVisual.idle;
  }

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

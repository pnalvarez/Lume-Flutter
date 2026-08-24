import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/connections_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayConnections {
  ConnectionsPlayOutcome selectLeft({
    required ConnectionsPlayState current,
    required String leftId,
  });

  ConnectionsPlayOutcome? selectRight({
    required ConnectionsPlayState current,
    required String rightId,
  });

  ConnectionsPlayOutcome? undoLast({required ConnectionsPlayState current});

  ConnectionsPlayOutcome? submit({
    required ConnectionsPlayState current,
    required ConnectionsGameDomain game,
  });
}

@Injectable(as: IPlayConnections)
final class PlayConnections implements IPlayConnections {
  @override
  ConnectionsPlayOutcome selectLeft({
    required ConnectionsPlayState current,
    required String leftId,
  }) {
    return ConnectionsPlayOutcome(
      state: current.copyWith(selectedLeftId: leftId),
    );
  }

  @override
  ConnectionsPlayOutcome? selectRight({
    required ConnectionsPlayState current,
    required String rightId,
  }) {
    final leftId = current.selectedLeftId;
    if (leftId == null) return null;

    final nextLinks = Map<String, String>.from(current.links);
    nextLinks.removeWhere((key, value) => value == rightId && key != leftId);
    nextLinks[leftId] = rightId;

    final nextOrder = current.linkOrder
        .where(nextLinks.containsKey)
        .toList(growable: true);
    if (!nextOrder.contains(leftId)) {
      nextOrder.add(leftId);
    }

    return ConnectionsPlayOutcome(
      state: current.copyWith(
        links: nextLinks,
        linkOrder: nextOrder,
        clearSelectedLeft: true,
      ),
    );
  }

  @override
  ConnectionsPlayOutcome? undoLast({required ConnectionsPlayState current}) {
    if (current.linkOrder.isEmpty) return null;
    final lastLeft = current.linkOrder.last;
    final nextLinks = Map<String, String>.from(current.links)..remove(lastLeft);
    final nextOrder = List<String>.from(current.linkOrder)..removeLast();
    return ConnectionsPlayOutcome(
      state: current.copyWith(
        links: nextLinks,
        linkOrder: nextOrder,
        clearSelectedLeft: true,
      ),
    );
  }

  @override
  ConnectionsPlayOutcome? submit({
    required ConnectionsPlayState current,
    required ConnectionsGameDomain game,
  }) {
    if (current.links.length < game.leftColumn.length) return null;

    final correct = game.pairs.every(
      (pair) => current.links[pair.leftId] == pair.rightId,
    );
    return ConnectionsPlayOutcome(
      state: current,
      answered: true,
      isCorrect: correct,
    );
  }
}

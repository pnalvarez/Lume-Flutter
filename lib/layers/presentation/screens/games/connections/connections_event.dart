import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class ConnectionsEvent {
  const ConnectionsEvent();
}

final class ConnectionsStarted extends ConnectionsEvent {
  const ConnectionsStarted(this.game);

  final ConnectionsGameDomain game;
}

final class ConnectionsLeftSelected extends ConnectionsEvent {
  const ConnectionsLeftSelected(this.leftId);

  final String leftId;
}

final class ConnectionsRightSelected extends ConnectionsEvent {
  const ConnectionsRightSelected(this.rightId);

  final String rightId;
}

final class ConnectionsSubmit extends ConnectionsEvent {
  const ConnectionsSubmit();
}

final class ConnectionsNext extends ConnectionsEvent {
  const ConnectionsNext();
}

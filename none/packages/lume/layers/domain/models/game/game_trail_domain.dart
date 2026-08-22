import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

/// Game-focused trail tree used by the games home experience.
class GameTrailDomain {
  const GameTrailDomain({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.emoji,
    this.levels = const [],
  });

  final int id;
  final String title;
  final String? emoji;
  final int sortOrder;
  final List<GameTrailLevelDomain> levels;
}

class GameTrailLevelDomain {
  const GameTrailLevelDomain({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.submodules = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final List<GameTrailSubmoduleDomain> submodules;
}

class GameTrailSubmoduleDomain {
  const GameTrailSubmoduleDomain({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.imageUrl,
    this.preview = '',
    this.games = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final String? imageUrl;
  final String preview;
  final List<TrailGameDomain> games;
}

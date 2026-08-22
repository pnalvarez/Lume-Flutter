import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

/// Parsed games for a single submodule session.
class SubmoduleGamesDomain {
  const SubmoduleGamesDomain({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.imageUrl,
    this.levelId,
    this.moduleId,
    this.preview = '',
    this.games = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final String? imageUrl;
  final int? levelId;
  final int? moduleId;
  final String preview;
  final List<TrailGameDomain> games;
}

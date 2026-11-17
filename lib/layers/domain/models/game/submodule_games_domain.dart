import 'package:lume/layers/domain/models/game/preview_slides_domain.dart';
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
    this.previewSlides = const PreviewSlidesDomain(),
    this.games = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final String? imageUrl;
  final int? levelId;
  final int? moduleId;
  final String preview;
  final PreviewSlidesDomain previewSlides;
  final List<TrailGameDomain> games;
}

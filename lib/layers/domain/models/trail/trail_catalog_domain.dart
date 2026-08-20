import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/game_type.dart';

/// Full trail catalog snapshot with embedded progress.
class TrailBootstrapDomain {
  const TrailBootstrapDomain({
    this.trailStartedAt,
    this.modules = const [],
    this.categories = const [],
    this.levels = const [],
    this.submodules = const [],
    this.submodulePairs = const [],
    this.levelProgress = const [],
    this.pairProgress = const [],
  });

  final DateTime? trailStartedAt;
  final List<ModuleDomain> modules;
  final List<CategoryDomain> categories;
  final List<LevelDomain> levels;
  final List<SubmoduleDomain> submodules;
  final List<SubmodulePairDomain> submodulePairs;
  final List<LevelProgressDomain> levelProgress;
  final List<PairProgressDomain> pairProgress;
}

class ModuleDomain {
  const ModuleDomain({
    required this.id,
    required this.sortOrder,
    required this.title,
    required this.emoji,
    required this.color,
    this.categoryId,
    this.description,
  });

  final int id;
  final int sortOrder;
  final String title;
  final String emoji;
  final String color;
  final int? categoryId;
  final String? description;
}

class LevelDomain {
  const LevelDomain({
    required this.id,
    required this.moduleId,
    required this.sortOrder,
    required this.title,
  });

  final int id;
  final int moduleId;
  final int sortOrder;
  final String title;
}

class SubmoduleDomain {
  const SubmoduleDomain({
    required this.id,
    required this.moduleId,
    required this.sortOrder,
    required this.title,
    this.levelId,
    this.unlockDaysFromStart = 0,
    this.imageUrl,
  });

  final int id;
  final int moduleId;
  final int? levelId;
  final int sortOrder;
  final String title;
  final int unlockDaysFromStart;
  final String? imageUrl;
}

class SubmodulePairDomain {
  const SubmodulePairDomain({
    required this.id,
    required this.submoduleId,
    required this.sortOrder,
    required this.previewHook,
    required this.gameType,
    required this.contentType,
    required this.cognitiveDemand,
    this.conceptId,
    this.createdAt,
  });

  final int id;
  final int submoduleId;
  final int sortOrder;
  final String previewHook;
  final GameType gameType;
  final String contentType;
  final String cognitiveDemand;
  final int? conceptId;
  final DateTime? createdAt;
}

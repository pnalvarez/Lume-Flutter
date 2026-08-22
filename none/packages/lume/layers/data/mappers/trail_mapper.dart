import 'package:lume/layers/data/models/trail_catalog_data.dart';
import 'package:lume/layers/data/models/trail_progress_data.dart';
import 'package:lume/layers/data/mappers/trail_game_mapper.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_catalog_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/mappers/category_mapper.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';

abstract final class TrailMapper {
  const TrailMapper._();

  static TrailBootstrapDomain toBootstrapDomain(TrailBootstrapData data) {
    return TrailBootstrapDomain(
      trailStartedAt: data.trailStartedAt,
      modules: [for (final module in data.modules) toModuleDomain(module)],
      categories: [
        for (final category in data.categories)
          CategoryMapper.toDomain(category),
      ],
      levels: [for (final level in data.levels) toLevelDomain(level)],
      submodules: [
        for (final submodule in data.submodules) toSubmoduleDomain(submodule),
      ],
      submodulePairs: [
        for (final pair in data.submodulePairs) toSubmodulePairDomain(pair),
      ],
      levelProgress: [
        for (final progress in data.levelProgress)
          toLevelProgressDomain(progress),
      ],
      pairProgress: [
        for (final progress in data.pairProgress)
          toPairProgressDomain(progress),
      ],
    );
  }

  static TrailProgressDomain toProgressDomain(TrailProgressData data) {
    return TrailProgressDomain(
      levelProgress: [
        for (final progress in data.levelProgress)
          toLevelProgressDomain(progress),
      ],
      pairProgress: [
        for (final progress in data.pairProgress)
          toPairProgressDomain(progress),
      ],
    );
  }

  static LevelProgressDomain toLevelProgressDomain(LevelProgressData data) {
    return LevelProgressDomain(
      levelId: data.levelId,
      completed: data.completed,
      completedAt: data.completedAt,
    );
  }

  static PairProgressDomain toPairProgressDomain(PairProgressData data) {
    return PairProgressDomain(
      pairId: data.pairId,
      previewSeen: data.previewSeen,
      scorePct: data.scorePct,
      completed: data.completed,
      updatedAt: data.updatedAt,
    );
  }

  static List<GameTrailDomain> toGameTrailDomains(List<GameTrailData> data) {
    return [for (final trail in data) toGameTrailDomain(trail)];
  }

  static GameTrailDomain toGameTrailDomain(GameTrailData data) {
    return GameTrailDomain(
      id: data.id,
      title: data.title,
      emoji: data.emoji,
      sortOrder: data.sortOrder,
      levels: [for (final level in data.levels) toGameTrailLevelDomain(level)],
    );
  }

  static GameTrailLevelDomain toGameTrailLevelDomain(GameTrailLevelData data) {
    return GameTrailLevelDomain(
      id: data.id,
      title: data.title,
      sortOrder: data.sortOrder,
      submodules: [
        for (final submodule in data.submodules)
          toGameTrailSubmoduleDomain(submodule),
      ],
    );
  }

  static GameTrailSubmoduleDomain toGameTrailSubmoduleDomain(
    GameTrailSubmoduleData data,
  ) {
    return GameTrailSubmoduleDomain(
      id: data.id,
      title: data.title,
      sortOrder: data.sortOrder,
      imageUrl: data.imageUrl,
      preview: data.preview,
      games: TrailGameMapper.parseAll(data.games),
    );
  }

  static SubmoduleGamesDomain toSubmoduleGamesDomain(SubmoduleGamesData data) {
    return SubmoduleGamesDomain(
      id: data.id,
      title: data.title,
      sortOrder: data.sortOrder,
      imageUrl: data.imageUrl,
      levelId: data.levelId,
      moduleId: data.moduleId,
      preview: data.preview,
      games: TrailGameMapper.parseAll(data.games),
    );
  }

  static ModuleDomain toModuleDomain(ModuleData data) {
    return ModuleDomain(
      id: data.id,
      sortOrder: data.sortOrder,
      title: data.title,
      emoji: data.emoji,
      color: data.color,
      categoryId: data.categoryId,
      description: data.description,
    );
  }

  static LevelDomain toLevelDomain(LevelData data) {
    return LevelDomain(
      id: data.id,
      moduleId: data.moduleId,
      sortOrder: data.sortOrder,
      title: data.title,
    );
  }

  static SubmoduleDomain toSubmoduleDomain(SubmoduleData data) {
    return SubmoduleDomain(
      id: data.id,
      moduleId: data.moduleId,
      levelId: data.levelId,
      sortOrder: data.sortOrder,
      title: data.title,
      unlockDaysFromStart: data.unlockDaysFromStart,
      imageUrl: data.imageUrl,
    );
  }

  static SubmodulePairDomain toSubmodulePairDomain(SubmodulePairData data) {
    return SubmodulePairDomain(
      id: data.id,
      submoduleId: data.submoduleId,
      sortOrder: data.sortOrder,
      previewHook: data.previewHook,
      gameType: data.gameType,
      contentType: data.contentType,
      cognitiveDemand: data.cognitiveDemand,
      conceptId: data.conceptId,
      createdAt: data.createdAt,
    );
  }
}

import 'package:lume/layers/data/models/finished_game_match_data.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';

abstract final class FinishedGameMatchMapper {
  static FinishedGameMatchDomain toDomain(FinishedGameMatchData data) {
    return FinishedGameMatchDomain(xpEarned: data.xpEarned);
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/domain/models/trail_game/game_type.dart';

export 'package:lume/layers/domain/models/trail_game/game_type.dart';

class GameTypeConverter implements JsonConverter<GameType, String> {
  const GameTypeConverter();

  @override
  GameType fromJson(String json) => GameType.fromWire(json);

  @override
  String toJson(GameType object) => object.wireValue;
}

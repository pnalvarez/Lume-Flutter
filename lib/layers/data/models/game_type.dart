import 'package:json_annotation/json_annotation.dart';

/// Trail game formats exposed as English `game_format` in client RPC JSON.
enum GameType {
  @JsonValue('battle_of_curiosities')
  battleOfCuriosities('battle_of_curiosities'),

  @JsonValue('mysterious_word')
  mysteriousWord('mysterious_word'),

  @JsonValue('who_am_i')
  whoAmI('who_am_i'),

  @JsonValue('connections')
  connections('connections'),

  @JsonValue('timeline')
  timeline('timeline'),

  @JsonValue('true_or_myth')
  trueOrMyth('true_or_myth'),

  @JsonValue('complete_sentence')
  completeSentence('complete_sentence'),

  @JsonValue('lightning_quiz')
  lightningQuiz('lightning_quiz');

  const GameType(this.wireValue);

  final String wireValue;

  static GameType fromWire(String value) {
    final normalized = value.trim();
    for (final type in GameType.values) {
      if (type.wireValue == normalized) return type;
    }
    throw FormatException('Unsupported game_format: $value');
  }
}

class GameTypeConverter implements JsonConverter<GameType, String> {
  const GameTypeConverter();

  @override
  GameType fromJson(String json) => GameType.fromWire(json);

  @override
  String toJson(GameType object) => object.wireValue;
}

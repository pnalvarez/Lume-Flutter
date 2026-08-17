import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/game_type.dart';

void main() {
  test('fromWire parses English game_format values', () {
    expect(
      GameType.fromWire('battle_of_curiosities'),
      GameType.battleOfCuriosities,
    );
    expect(GameType.fromWire('connections'), GameType.connections);
    expect(GameType.fromWire('complete_sentence'), GameType.completeSentence);
    expect(GameType.fromWire('lightning_quiz'), GameType.lightningQuiz);
  });

  test('fromWire throws on legacy Portuguese slugs', () {
    expect(
      () => GameType.fromWire('batalha'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => GameType.fromWire('quem-sou-eu'),
      throwsA(isA<FormatException>()),
    );
  });

  test('wireValue round-trips through converter', () {
    const converter = GameTypeConverter();

    for (final type in GameType.values) {
      expect(converter.toJson(type), type.wireValue);
      expect(converter.fromJson(type.wireValue), type);
    }
  });
}

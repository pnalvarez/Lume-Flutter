/// Trail game formats exposed as English `game_format` in client RPC JSON.
enum GameType {
  battleOfCuriosities('battle_of_curiosities'),
  mysteriousWord('mysterious_word'),
  whoAmI('who_am_i'),
  connections('connections'),
  timeline('timeline'),
  trueOrMyth('true_or_myth'),
  completeSentence('complete_sentence'),
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

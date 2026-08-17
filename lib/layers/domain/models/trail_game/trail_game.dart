import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/data/models/game_type.dart';

/// Parsed trail game ready for presentation routing.
sealed class TrailGame {
  const TrailGame({
    required this.pairId,
    required this.sortOrder,
    required this.gameType,
    this.conceptId,
  });

  final int pairId;
  final int sortOrder;
  final GameType gameType;
  final int? conceptId;
}

final class LightningQuizGame extends TrailGame {
  const LightningQuizGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  }) : super(gameType: GameType.lightningQuiz);

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

final class WhoAmIGame extends TrailGame {
  const WhoAmIGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.header,
    required this.hints,
    required this.correctAnswer,
    required this.acceptedSynonyms,
    required this.explanation,
  }) : super(gameType: GameType.whoAmI);

  final String header;
  final List<String> hints;
  final String correctAnswer;
  final List<String> acceptedSynonyms;
  final String explanation;
}

final class TrueOrMythGame extends TrailGame {
  const TrueOrMythGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.text,
    required this.verdict,
    required this.explanation,
  }) : super(gameType: GameType.trueOrMyth);

  final String text;
  final TrueOrMythVerdict verdict;
  final String explanation;
}

final class CompleteSentenceGame extends TrailGame {
  const CompleteSentenceGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.sentence,
    required this.blanks,
    required this.explanation,
  }) : super(gameType: GameType.completeSentence);

  final String sentence;
  final List<SentenceBlank> blanks;
  final String explanation;
}

final class MysteriousWordGame extends TrailGame {
  const MysteriousWordGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.word,
    required this.description,
    required this.hint,
    required this.explanation,
  }) : super(gameType: GameType.mysteriousWord);

  final String word;
  final String description;
  final String hint;
  final String explanation;
}

final class BattleOfCuriositiesGame extends TrailGame {
  const BattleOfCuriositiesGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.correct,
    required this.comparisonCriterion,
    required this.explanation,
  }) : super(gameType: GameType.battleOfCuriosities);

  final String question;
  final String optionA;
  final String optionB;
  final BattleCorrectSide correct;
  final String? comparisonCriterion;
  final String explanation;
}

final class ConnectionsGame extends TrailGame {
  const ConnectionsGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.leftColumn,
    required this.rightColumn,
    required this.pairs,
  }) : super(gameType: GameType.connections);

  final List<ConnectionItem> leftColumn;
  final List<ConnectionItem> rightColumn;
  final List<ConnectionPair> pairs;
}

final class TimelineGame extends TrailGame {
  const TimelineGame({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.initialSituation,
    required this.options,
    required this.correctIndex,
    required this.relationType,
    required this.explanation,
  }) : super(gameType: GameType.timeline);

  final String initialSituation;
  final List<String> options;
  final int correctIndex;
  final String? relationType;
  final String explanation;
}

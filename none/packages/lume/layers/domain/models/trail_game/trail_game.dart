import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/domain/models/trail_game/game_type.dart';

/// Parsed trail game ready for presentation routing.
sealed class TrailGameDomain {
  const TrailGameDomain({
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

final class LightningQuizGameDomain extends TrailGameDomain {
  const LightningQuizGameDomain({
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

final class WhoAmIGameDomain extends TrailGameDomain {
  const WhoAmIGameDomain({
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

final class TrueOrMythGameDomain extends TrailGameDomain {
  const TrueOrMythGameDomain({
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

final class CompleteSentenceGameDomain extends TrailGameDomain {
  const CompleteSentenceGameDomain({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.sentence,
    required this.blanks,
    required this.explanation,
  }) : super(gameType: GameType.completeSentence);

  final String sentence;
  final List<SentenceBlankDomain> blanks;
  final String explanation;
}

final class MysteriousWordGameDomain extends TrailGameDomain {
  const MysteriousWordGameDomain({
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

final class BattleOfCuriositiesGameDomain extends TrailGameDomain {
  const BattleOfCuriositiesGameDomain({
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

final class ConnectionsGameDomain extends TrailGameDomain {
  const ConnectionsGameDomain({
    required super.pairId,
    required super.sortOrder,
    super.conceptId,
    required this.leftColumn,
    required this.rightColumn,
    required this.pairs,
  }) : super(gameType: GameType.connections);

  final List<ConnectionItemDomain> leftColumn;
  final List<ConnectionItemDomain> rightColumn;
  final List<ConnectionPairDomain> pairs;
}

final class TimelineGameDomain extends TrailGameDomain {
  const TimelineGameDomain({
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

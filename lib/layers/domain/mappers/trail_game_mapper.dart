import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/models/game_type.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';

abstract final class TrailGameMapper {
  const TrailGameMapper._();

  static TrailGame parse(GameItemData item) {
    final payload = item.gamePayload;
    if (payload == null || payload.isEmpty) {
      throw FormatException(
        'Missing game_payload for pair ${item.pairId} (${item.gameType.wireValue})',
      );
    }

    return switch (item.gameType) {
      GameType.lightningQuiz => _parseLightningQuiz(item, payload),
      GameType.whoAmI => _parseWhoAmI(item, payload),
      GameType.trueOrMyth => _parseTrueOrMyth(item, payload),
      GameType.completeSentence => _parseCompleteSentence(item, payload),
      GameType.mysteriousWord => _parseMysteriousWord(item, payload),
      GameType.battleOfCuriosities => _parseBattle(item, payload),
      GameType.connections => _parseConnections(item, payload),
      GameType.timeline => _parseTimeline(item, payload),
    };
  }

  static List<TrailGame> parseAll(Iterable<GameItemData> items) =>
      [for (final item in items) parse(item)];

  static LightningQuizGame _parseLightningQuiz(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return LightningQuizGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      prompt: _requireString(payload, 'prompt'),
      options: _requireStringList(payload, 'options'),
      correctIndex: _requireInt(payload, 'correct_index'),
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static WhoAmIGame _parseWhoAmI(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return WhoAmIGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      header: _requireString(payload, 'header'),
      hints: _requireStringList(payload, 'hints'),
      correctAnswer: _requireString(payload, 'correct_answer'),
      acceptedSynonyms: _optionalStringList(payload, 'accepted_synonyms'),
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static TrueOrMythGame _parseTrueOrMyth(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return TrueOrMythGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      text: _requireString(payload, 'text'),
      verdict: TrueOrMythVerdict.fromWire(_requireString(payload, 'verdict')),
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static CompleteSentenceGame _parseCompleteSentence(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    final blanksRaw = payload['blanks'];
    if (blanksRaw is! List) {
      throw FormatException('Expected blanks array for complete_sentence');
    }

    return CompleteSentenceGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      sentence: _requireString(payload, 'sentence'),
      blanks: [
        for (final blank in blanksRaw)
          SentenceBlank(
            order: _requireInt(asJsonMap(blank), 'order'),
            options: _requireStringList(asJsonMap(blank), 'options'),
            correct: _requireString(asJsonMap(blank), 'correct'),
          ),
      ],
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static MysteriousWordGame _parseMysteriousWord(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return MysteriousWordGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      word: _requireString(payload, 'word'),
      description: _requireString(payload, 'description'),
      hint: _optionalString(payload, 'hint') ?? '',
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static BattleOfCuriositiesGame _parseBattle(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return BattleOfCuriositiesGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      question: _requireString(payload, 'question'),
      optionA: _requireString(payload, 'option_a'),
      optionB: _requireString(payload, 'option_b'),
      correct: BattleCorrectSide.fromWire(_requireString(payload, 'correct')),
      comparisonCriterion: _optionalString(payload, 'comparison_criterion'),
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static ConnectionsGame _parseConnections(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return ConnectionsGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      leftColumn: _parseConnectionItems(payload, 'left_column'),
      rightColumn: _parseConnectionItems(payload, 'right_column'),
      pairs: _parseConnectionPairs(payload),
    );
  }

  static TimelineGame _parseTimeline(
    GameItemData item,
    Map<String, dynamic> payload,
  ) {
    return TimelineGame(
      pairId: item.pairId,
      sortOrder: item.sortOrder,
      conceptId: item.conceptId,
      initialSituation: _requireString(payload, 'initial_situation'),
      options: _requireStringList(payload, 'options'),
      correctIndex: _requireInt(payload, 'correct_index'),
      relationType: _optionalString(payload, 'relation_type'),
      explanation: _optionalString(payload, 'explanation') ?? '',
    );
  }

  static List<ConnectionItem> _parseConnectionItems(
    Map<String, dynamic> payload,
    String key,
  ) {
    final raw = payload[key];
    if (raw is! List) {
      throw FormatException('Expected $key array for connections');
    }

    return [
      for (final item in raw)
        ConnectionItem(
          id: _requireString(asJsonMap(item), 'id'),
          text: _requireString(asJsonMap(item), 'text'),
        ),
    ];
  }

  static List<ConnectionPair> _parseConnectionPairs(
    Map<String, dynamic> payload,
  ) {
    final raw = payload['pairs'];
    if (raw is! List) {
      throw FormatException('Expected pairs array for connections');
    }

    return [
      for (final item in raw)
        ConnectionPair(
          leftId: _requireString(asJsonMap(item), 'left_id'),
          rightId: _requireString(asJsonMap(item), 'right_id'),
          explanation: _optionalString(asJsonMap(item), 'explanation'),
        ),
    ];
  }

  static String _requireString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Expected non-empty string at $key');
    }
    return value;
  }

  static String? _optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is! String) {
      throw FormatException('Expected string at $key');
    }
    return value;
  }

  static int _requireInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Expected number at $key');
  }

  static List<String> _requireStringList(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is! List) {
      throw FormatException('Expected array at $key');
    }
    return [
      for (final item in value)
        if (item is String) item
        else throw FormatException('Expected string items at $key'),
    ];
  }

  static List<String> _optionalStringList(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value == null) return const [];
    return _requireStringList(json, key);
  }
}

extension GameItemDataTrailGame on GameItemData {
  TrailGame toTrailGame() => TrailGameMapper.parse(this);
}

extension SubmoduleGamesDataTrailGames on SubmoduleGamesData {
  List<TrailGame> get trailGames => TrailGameMapper.parseAll(games);
}

extension GameTrailDataTrailGames on GameTrailData {
  List<TrailGame> get trailGames => [
        for (final level in levels)
          for (final submodule in level.submodules)
            ...TrailGameMapper.parseAll(submodule.games),
      ];
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/domain/models/trail_game/game_type.dart';
import 'package:lume/layers/data/mappers/trail_game_mapper.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';

void main() {
  GameItemData item(GameType type, Map<String, dynamic> payload) {
    return GameItemData(
      pairId: 1,
      sortOrder: 1,
      gameType: type,
      gamePayload: payload,
    );
  }

  test('parse maps lightning quiz payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.lightningQuiz, {
        'prompt': 'What is AI?',
        'options': ['A', 'B', 'C'],
        'correct_index': 1,
        'explanation': 'Because.',
      }),
    );

    expect(game, isA<LightningQuizGameDomain>());
    final quiz = game as LightningQuizGameDomain;
    expect(quiz.prompt, 'What is AI?');
    expect(quiz.correctIndex, 1);
  });

  test('parse maps who am i payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.whoAmI, {
        'header': 'I am a concept.',
        'hints': ['Hint 1', 'Hint 2'],
        'correct_answer': 'entropy',
        'accepted_synonyms': ['disorder'],
        'explanation': 'Explanation.',
      }),
    );

    expect(game, isA<WhoAmIGameDomain>());
    final who = game as WhoAmIGameDomain;
    expect(who.hints, ['Hint 1', 'Hint 2']);
    expect(who.correctAnswer, 'entropy');
  });

  test('parse maps true or myth payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.trueOrMyth, {
        'text': 'AI always understands context.',
        'verdict': 'myth',
        'explanation': 'Not always.',
      }),
    );

    expect(game, isA<TrueOrMythGameDomain>());
    expect((game as TrueOrMythGameDomain).verdict, TrueOrMythVerdict.myth);
  });

  test('parse maps complete sentence payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.completeSentence, {
        'sentence': 'A [1] does [2].',
        'blanks': [
          {
            'order': 1,
            'options': ['system', 'rule'],
            'correct': 'system',
          },
        ],
        'explanation': 'Done.',
      }),
    );

    expect(game, isA<CompleteSentenceGameDomain>());
    final sentence = game as CompleteSentenceGameDomain;
    expect(sentence.blanks.single.correct, 'system');
  });

  test('parse maps mysterious word payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.mysteriousWord, {
        'word': 'format',
        'description': 'Output structure.',
        'hint': 'Starts with F.',
        'explanation': 'Format matters.',
      }),
    );

    expect(game, isA<MysteriousWordGameDomain>());
    expect((game as MysteriousWordGameDomain).word, 'format');
  });

  test('parse maps battle of curiosities payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.battleOfCuriosities, {
        'question': 'Which is better?',
        'option_a': 'A',
        'option_b': 'B',
        'correct': 'b',
        'comparison_criterion': 'clarity',
        'explanation': 'B wins.',
      }),
    );

    expect(game, isA<BattleOfCuriositiesGameDomain>());
    expect(
      (game as BattleOfCuriositiesGameDomain).correct,
      BattleCorrectSide.b,
    );
  });

  test('parse maps connections payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.connections, {
        'left_column': [
          {'id': 'e1', 'text': 'Left'},
        ],
        'right_column': [
          {'id': 'd1', 'text': 'Right'},
        ],
        'pairs': [
          {
            'left_id': 'e1',
            'right_id': 'd1',
            'explanation': 'Match.',
          },
        ],
      }),
    );

    expect(game, isA<ConnectionsGameDomain>());
    final connections = game as ConnectionsGameDomain;
    expect(connections.pairs.single.leftId, 'e1');
  });

  test('parse maps timeline payload', () {
    final game = TrailGameMapper.parse(
      item(GameType.timeline, {
        'initial_situation': 'Something happened.',
        'options': ['First', 'Second'],
        'correct_index': 0,
        'relation_type': 'sequence',
        'explanation': 'Then this.',
      }),
    );

    expect(game, isA<TimelineGameDomain>());
    expect((game as TimelineGameDomain).correctIndex, 0);
  });

  test('parse throws when game_payload is missing', () {
    expect(
      () => TrailGameMapper.parse(
        const GameItemData(
          pairId: 1,
          sortOrder: 1,
          gameType: GameType.whoAmI,
        ),
      ),
      throwsFormatException,
    );
  });

  test('SubmoduleGamesData.trailGameDomains parses all games', () {
    final data = SubmoduleGamesData.fromJson({
      'id': 9,
      'title': 'Preview',
      'sort_order': 1,
      'games': [
        {
          'pair_id': 1,
          'sort_order': 1,
          'game_format': 'who_am_i',
          'game_payload': {
            'header': 'Header',
            'hints': ['Hint'],
            'correct_answer': 'answer',
            'accepted_synonyms': [],
            'explanation': 'Explanation',
          },
        },
      ],
    });

    expect(data.trailGameDomains, hasLength(1));
    expect(data.trailGameDomains.single, isA<WhoAmIGameDomain>());
  });
}

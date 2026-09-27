import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/models/game_type.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

class _Session implements IAuthSessionProvider {
  _Session(this.userId);

  @override
  final String? userId;

  @override
  String? get accessToken => null;

  @override
  AuthSessionSnapshot? get session => null;

  @override
  bool get hasSession => userId != null;

  @override
  bool get isEmailConfirmed => true;

  @override
  bool get isPasswordRecovery => false;

  @override
  String? get email => null;

  @override
  Stream<void> get changes => const Stream.empty();

  @override
  void clearPasswordRecovery() {}

  @override
  Future<void> restore() async {}

  @override
  void dispose() {}
}

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late GameDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = GameDataSource(apiClient, storage, _Session('user-1'));
  });

  test(
    'fetchSubmoduleGames posts p_submodule_id and parses SubmoduleGamesData',
    () async {
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_submodule_games',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => {
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
        },
      );

      final data = await sut.fetchSubmoduleGames(submoduleId: 9);

      expect(data.id, 9);
      expect(data.title, 'Preview');
      expect(data.games.single.gameType, GameType.whoAmI);

      // Options are shuffled server-side — never reuse a cached payload.
      await sut.fetchSubmoduleGames(submoduleId: 9);
      verify(
        apiClient.rpc<Map<String, dynamic>>(
          'get_submodule_games',
          params: {'p_submodule_id': 9},
        ),
      ).called(2);
    },
  );

  test(
    'fetchHubGames posts get_hub_games and parses HubGameData list',
    () async {
      when(
        apiClient.rpc<List<dynamic>>(
          'get_hub_games',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'id': 'abc',
            'slug': 'quiz_relampago',
            'name': 'Quiz Relâmpago',
            'description': 'Rápido',
            'icon': 'Zap',
            'color_hex': '#F5A623',
            'hub_section': 'general',
            'order_index': 1,
          },
        ],
      );

      final data = await sut.fetchHubGames();

      expect(data, hasLength(1));
      expect(data.single.slug, 'quiz_relampago');
      expect(data.single.colorHex, '#F5A623');
      verify(apiClient.rpc<List<dynamic>>('get_hub_games')).called(1);
    },
  );

  test('startGameMatch posts the signed-in user and slug', () async {
    when(
      apiClient.rpc<Object>(
        'start_game_match',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => 'match-1');

    final matchId = await sut.startGameMatch(gameSlug: 'quiz_relampago');

    expect(matchId, 'match-1');
    verify(
      apiClient.rpc<Object>(
        'start_game_match',
        params: {'p_user_id': 'user-1', 'p_game_slug': 'quiz_relampago'},
      ),
    ).called(1);
  });

  test('finishGameMatch posts the score and drops the profile cache', () async {
    await storage.write(CacheKeys.profile, '{}');
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'finish_game_match',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => {'xp_earned': 11});

    final result = await sut.finishGameMatch(
      matchId: 'match-1',
      score: 100,
      correctCount: 2,
      totalQuestions: 2,
      durationSeconds: 30,
    );

    expect(result.xpEarned, 11);
    expect(await storage.read(CacheKeys.profile), isNull);
    verify(
      apiClient.rpc<Map<String, dynamic>>(
        'finish_game_match',
        params: {
          'p_user_id': 'user-1',
          'p_match_id': 'match-1',
          'p_score': 100,
          'p_correct_count': 2,
          'p_total_questions': 2,
          'p_duration_seconds': 30,
        },
      ),
    ).called(1);

    final withMetadata = await sut.finishGameMatch(
      matchId: 'match-1',
      score: 100,
      correctCount: 2,
      totalQuestions: 2,
      durationSeconds: 30,
      metadata: const {'zero_hint_streak': 2},
    );
    expect(withMetadata.xpEarned, 11);
    verify(
      apiClient.rpc<Map<String, dynamic>>(
        'finish_game_match',
        params: {
          'p_user_id': 'user-1',
          'p_match_id': 'match-1',
          'p_score': 100,
          'p_correct_count': 2,
          'p_total_questions': 2,
          'p_duration_seconds': 30,
          'p_metadata': {'zero_hint_streak': 2},
        },
      ),
    ).called(1);
  });
}

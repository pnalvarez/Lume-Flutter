import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/network/api_response.dart';
import 'package:lume/core/network/http_method.dart';
import 'package:lume/layers/data/datasource/knowledge_gallery_data_source.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';

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

class _ApiClient implements IApiClient {
  final calls = <String>[];
  final params = <Object?>[];
  Object? Function(String name)? handler;

  @override
  Future<T> rpc<T>(
    String name, {
    Object? params,
    Map<String, String> headers = const {},
  }) async {
    calls.add(name);
    this.params.add(params);
    return handler!(name) as T;
  }

  @override
  Future<T> get<T>({
    required String endpoint,
    Map<String, Object?> queryParameters = const {},
    Map<String, String> headers = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<T> post<T>({
    required String endpoint,
    Object? body,
    Map<String, String> headers = const {},
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<T>> request<T>({
    required HttpMethod method,
    required String endpoint,
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Object? body,
  }) {
    throw UnimplementedError();
  }
}

Map<String, Object?> _roundJson() {
  return {
    'question_id': 7,
    'prompt_text': 'Who painted this?',
    'image_url': 'https://cdn.example/art.jpg',
    'question_type': 'identify_artist',
    'options': [
      {'text': 'Van Gogh', 'is_correct': false},
      {'text': 'Da Vinci', 'is_correct': true},
      {'text': 'Picasso', 'is_correct': false},
      {'text': 'Monet', 'is_correct': false},
    ],
    'correct_answer': 'Da Vinci',
    'curiosity_fact': 'A fact',
    'feedback_correct': 'Yes',
    'feedback_incorrect': 'No',
  };
}

void main() {
  late _ApiClient api;
  late KnowledgeGalleryDataSource sut;

  setUp(() {
    api = _ApiClient();
    sut = KnowledgeGalleryDataSource(api, _Session('user-1'));
  });

  test('fetchRounds asks for five galeria_conhecimento items', () async {
    api.handler = (_) => [_roundJson()];

    final rounds = await sut.fetchRounds();

    expect(rounds.single.options, ['Van Gogh', 'Da Vinci', 'Picasso', 'Monet']);
    expect(api.calls, ['get_visual_game_items']);
    expect(api.params.single, {
      'p_user_id': 'user-1',
      'p_game_slug': knowledgeGalleryGameSlug,
      'p_count': knowledgeGalleryRoundsPerMatch,
    });
    expect(api.calls, isNot(contains('get_game_round')));
    expect(api.calls, isNot(contains('save_pair_progress')));
  });

  test('fetchRounds forwards a count of one', () async {
    api.handler = (_) => [_roundJson()];

    await sut.fetchRounds(count: 1);

    expect((api.params.single! as Map)['p_count'], 1);
  });

  test(
    'submitAnswer posts submit_visual_answer and not pair progress',
    () async {
      api.handler = (_) => {
        'correct': true,
        'correct_answer': 'Da Vinci',
        'feedback': 'That is the painter.',
        'curiosity': 'It hung in a hallway.',
      };

      final result = await sut.submitAnswer(questionId: 7, answer: 'Da Vinci');

      expect(result.correct, isTrue);
      expect(result.correctAnswer, 'Da Vinci');
      expect(api.calls, ['submit_visual_answer']);
      expect(api.params.single, {
        'p_user_id': 'user-1',
        'p_question_id': 7,
        'p_answer': 'Da Vinci',
      });
      expect(api.calls, isNot(contains('save_pair_progress')));
      expect(api.calls, isNot(contains('get_game_round')));
    },
  );

  test('requires a signed-in user', () async {
    sut = KnowledgeGalleryDataSource(api, _Session(null));

    expect(sut.fetchRounds(), throwsStateError);
    expect(api.calls, isEmpty);
  });
}

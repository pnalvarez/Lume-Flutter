import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/visual_choice_game_round_data.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';

/// Visual RPCs for a visual-choice match of any visual game slug.
abstract interface class IVisualChoiceGameDataSource {
  Future<List<VisualChoiceGameRoundData>> fetchRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  });

  Future<VisualChoiceGameAnswerData> submitAnswer({
    required int questionId,
    required String answer,
  });
}

@Injectable(as: IVisualChoiceGameDataSource)
final class VisualChoiceGameDataSource implements IVisualChoiceGameDataSource {
  VisualChoiceGameDataSource(this._apiClient, this._session);

  final IApiClient _apiClient;
  final IAuthSessionProvider _session;

  @override
  Future<List<VisualChoiceGameRoundData>> fetchRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) async {
    final raw = await _apiClient.rpc<List<dynamic>>(
      'get_visual_game_items',
      params: {
        'p_user_id': _requireUserId(),
        'p_game_slug': gameSlug,
        'p_count': count,
      },
    );
    return parseJsonList(raw, VisualChoiceGameRoundData.fromJson);
  }

  @override
  Future<VisualChoiceGameAnswerData> submitAnswer({
    required int questionId,
    required String answer,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'submit_visual_answer',
      params: {
        'p_user_id': _requireUserId(),
        'p_question_id': questionId,
        'p_answer': answer,
      },
    );
    return VisualChoiceGameAnswerData.fromJson(asJsonMap(raw));
  }

  String _requireUserId() {
    final userId = _session.userId;
    if (userId == null || userId.isEmpty) {
      throw StateError('visual choice game requires a signed-in user');
    }
    return userId;
  }
}

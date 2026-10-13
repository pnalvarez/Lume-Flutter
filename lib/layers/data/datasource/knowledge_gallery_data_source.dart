import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/knowledge_gallery_round_data.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';

/// Visual RPCs for a Knowledge Gallery match.
abstract interface class IKnowledgeGalleryDataSource {
  Future<List<KnowledgeGalleryRoundData>> fetchRounds({
    int count = knowledgeGalleryRoundsPerMatch,
  });

  Future<KnowledgeGalleryAnswerData> submitAnswer({
    required int questionId,
    required String answer,
  });
}

@Injectable(as: IKnowledgeGalleryDataSource)
final class KnowledgeGalleryDataSource implements IKnowledgeGalleryDataSource {
  KnowledgeGalleryDataSource(this._apiClient, this._session);

  final IApiClient _apiClient;
  final IAuthSessionProvider _session;

  @override
  Future<List<KnowledgeGalleryRoundData>> fetchRounds({
    int count = knowledgeGalleryRoundsPerMatch,
  }) async {
    final raw = await _apiClient.rpc<List<dynamic>>(
      'get_visual_game_items',
      params: {
        'p_user_id': _requireUserId(),
        'p_game_slug': knowledgeGalleryGameSlug,
        'p_count': count,
      },
    );
    return parseJsonList(raw, KnowledgeGalleryRoundData.fromJson);
  }

  @override
  Future<KnowledgeGalleryAnswerData> submitAnswer({
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
    return KnowledgeGalleryAnswerData.fromJson(asJsonMap(raw));
  }

  String _requireUserId() {
    final userId = _session.userId;
    if (userId == null || userId.isEmpty) {
      throw StateError('knowledge gallery requires a signed-in user');
    }
    return userId;
  }
}

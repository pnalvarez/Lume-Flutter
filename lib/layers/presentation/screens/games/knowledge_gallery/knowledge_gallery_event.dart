import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';

@immutable
sealed class KnowledgeGalleryEvent {
  const KnowledgeGalleryEvent();
}

final class KnowledgeGalleryStarted extends KnowledgeGalleryEvent {
  const KnowledgeGalleryStarted({required this.rounds, required this.matchId});

  final List<KnowledgeGalleryRound> rounds;
  final String matchId;
}

final class KnowledgeGalleryOptionSelected extends KnowledgeGalleryEvent {
  const KnowledgeGalleryOptionSelected(this.optionId);

  /// Index in the current options, as `'0'` … `'3'`.
  final String optionId;
}

final class KnowledgeGalleryNextPressed extends KnowledgeGalleryEvent {
  const KnowledgeGalleryNextPressed();
}

final class KnowledgeGalleryAbandoned extends KnowledgeGalleryEvent {
  const KnowledgeGalleryAbandoned();
}

final class KnowledgeGalleryNavigationHandled extends KnowledgeGalleryEvent {
  const KnowledgeGalleryNavigationHandled();
}

final class KnowledgeGallerySnackShown extends KnowledgeGalleryEvent {
  const KnowledgeGallerySnackShown();
}

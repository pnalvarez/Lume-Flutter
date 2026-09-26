import 'package:flutter/foundation.dart';

import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';

@immutable
sealed class AchievementsEvent {
  const AchievementsEvent();
}

final class AchievementsStarted extends AchievementsEvent {
  const AchievementsStarted();
}

/// Toggles one status filter chip (multi-select; empty set = show all).
final class AchievementsFilterToggled extends AchievementsEvent {
  const AchievementsFilterToggled(this.status);

  final AchievementListItemStatus status;
}

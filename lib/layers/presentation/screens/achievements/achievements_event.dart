import 'package:flutter/foundation.dart';

@immutable
sealed class AchievementsEvent {
  const AchievementsEvent();
}

final class AchievementsStarted extends AchievementsEvent {
  const AchievementsStarted();
}

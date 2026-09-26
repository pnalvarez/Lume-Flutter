import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/achievement/achievement_icon.dart';

void main() {
  group('AchievementIcon.fromWire', () {
    test('maps known aliases case-insensitively', () {
      expect(AchievementIcon.fromWire('trophy'), AchievementIcon.trophy);
      expect(AchievementIcon.fromWire('Trophy'), AchievementIcon.trophy);
      expect(AchievementIcon.fromWire('Zap'), AchievementIcon.zap);
      expect(AchievementIcon.fromWire('bolt'), AchievementIcon.zap);
      expect(
        AchievementIcon.fromWire('CheckCircle2'),
        AchievementIcon.checkCircle,
      );
      expect(AchievementIcon.fromWire('map_pin'), AchievementIcon.mapPin);
      expect(AchievementIcon.fromWire('gamepad'), AchievementIcon.gamepad);
    });

    test('null or blank defaults to trophy', () {
      expect(AchievementIcon.fromWire(null), AchievementIcon.trophy);
      expect(AchievementIcon.fromWire(''), AchievementIcon.trophy);
      expect(AchievementIcon.fromWire('  '), AchievementIcon.trophy);
    });

    test('emojis and unknown names map to unknown', () {
      expect(AchievementIcon.fromWire('🏠'), AchievementIcon.unknown);
      expect(
        AchievementIcon.fromWire('not-a-real-icon'),
        AchievementIcon.unknown,
      );
    });
  });
}

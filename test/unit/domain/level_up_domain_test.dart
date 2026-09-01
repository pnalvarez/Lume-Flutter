import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';

void main() {
  test('progress is (current - offset) / (next - offset)', () {
    const levelUp = LevelUpDomain(
      level: 3,
      xpOffset: 100,
      currentXp: 103,
      xpForNextLevel: 200,
    );

    expect(levelUp.progress, closeTo(0.03, 0.0001));
  });

  test('progress is 1 when the next-level span is not positive', () {
    const levelUp = LevelUpDomain(
      level: 50,
      xpOffset: 1000,
      currentXp: 1000,
      xpForNextLevel: 1000,
    );

    expect(levelUp.progress, 1.0);
  });
}

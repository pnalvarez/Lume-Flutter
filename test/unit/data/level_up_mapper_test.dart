import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/level_up_mapper.dart';
import 'package:lume/layers/data/models/level_up_data.dart';

void main() {
  test('maps event JSON fields onto the level-up domain', () {
    const data = LevelUpData(
      level: 3,
      totalXp: 103,
      xpLevelOffset: 100,
      xpNextLevelAt: 200,
    );

    final domain = LevelUpMapper.toDomain(data);

    expect(domain.level, 3);
    expect(domain.xpOffset, 100);
    expect(domain.currentXp, 103);
    expect(domain.xpForNextLevel, 200);
    expect(domain.progress, closeTo(0.03, 0.0001));
  });

  test('fromJson reads snake_case event rows', () {
    final data = LevelUpData.fromJson({
      'level': 3,
      'total_xp': 103,
      'xp_level_offset': 100,
      'xp_next_level_at': 200,
    });

    expect(data.level, 3);
    expect(data.totalXp, 103);
    expect(data.xpLevelOffset, 100);
    expect(data.xpNextLevelAt, 200);
  });
}

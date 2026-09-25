import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/achievement_unlock_mapper.dart';
import 'package:lume/layers/data/models/achievement_unlock_data.dart';

void main() {
  test('maps event JSON fields onto the unlock domain', () {
    const data = AchievementUnlockData(
      achievementId: 'ach-1',
      code: 'first_step',
      name: 'Primeiro passo',
      icon: 'trophy',
    );

    final domain = AchievementUnlockMapper.toDomain(data);

    expect(domain.achievementId, 'ach-1');
    expect(domain.code, 'first_step');
    expect(domain.name, 'Primeiro passo');
    expect(domain.icon, 'trophy');
  });

  test('fromJson reads snake_case event rows', () {
    final data = AchievementUnlockData.fromJson({
      'achievement_id': 'ach-1',
      'code': 'first_step',
      'name': 'Primeiro passo',
      'icon': null,
    });

    expect(data.achievementId, 'ach-1');
    expect(data.code, 'first_step');
    expect(data.name, 'Primeiro passo');
    expect(data.icon, isNull);
  });
}

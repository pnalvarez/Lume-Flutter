import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/achievement_mapper.dart';
import 'package:lume/layers/data/models/achievement_data.dart';

void main() {
  group('AchievementData.fromJson', () {
    test('parses nested get_achievements payload', () {
      final response = AchievementsResponseData.fromJson({
        'achievements': [
          {
            'id': '11111111-1111-1111-1111-111111111111',
            'code': 'first_submodule',
            'name': 'Primeiro passo',
            'description': 'Complete 1 submódulo na trilha.',
            'icon': 'trophy',
            'condition_type': 'trail_submodules_completed',
            'condition_target': 1,
            'reward_type': 'xp',
            'reward_amount': 25,
            'progress': 1,
            'completed_at': '2026-01-15T12:00:00Z',
            'reward_claimed_at': null,
          },
        ],
      });

      expect(response.achievements, hasLength(1));
      final item = response.achievements.single;
      expect(item.code, 'first_submodule');
      expect(item.conditionTarget, 1);
      expect(item.progress, 1);
      expect(item.completedAt, isNotNull);
      expect(item.rewardClaimedAt, isNull);
    });

    test('defaults progress when omitted', () {
      final item = AchievementData.fromJson({
        'id': 'a1',
        'code': 'x',
        'name': 'N',
        'description': 'D',
        'condition_type': 't',
        'condition_target': 5,
        'reward_type': 'xp',
        'reward_amount': 10,
      });
      expect(item.progress, 0);
    });

    test('defaults null reward_amount for non-xp rewards', () {
      final item = AchievementData.fromJson({
        'id': 'a1',
        'code': 'museum_master',
        'name': 'Mestre do Museu',
        'description': 'Colete tudo.',
        'condition_type': 'museum_items',
        'condition_target': 10,
        'reward_type': 'collectible',
        'reward_amount': null,
        'progress': 0,
      });
      expect(item.rewardAmount, 0);
      expect(item.rewardType, 'collectible');
    });
  });

  group('AchievementMapper', () {
    test('maps data to domain', () {
      final domain = AchievementMapper.toDomain(
        AchievementData(
          id: 'a1',
          code: 'first_submodule',
          name: 'Primeiro passo',
          description: 'Complete 1 submódulo.',
          icon: 'trophy',
          conditionType: 'trail_submodules_completed',
          conditionTarget: 1,
          rewardType: 'xp',
          rewardAmount: 25,
          progress: 1,
          completedAt: DateTime.utc(2026, 1, 1),
        ),
      );

      expect(domain.id, 'a1');
      expect(domain.isCompleted, isTrue);
      expect(domain.conditionTarget, 1);
    });
  });
}

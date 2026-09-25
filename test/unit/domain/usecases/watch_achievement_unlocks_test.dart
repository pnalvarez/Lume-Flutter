import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/domain/repository/achievement_unlock_repository.dart';
import 'package:lume/layers/domain/usecases/watch_achievement_unlocks.dart';

class _Repo implements IAchievementUnlockRepository {
  _Repo(this.stream);

  final Stream<AchievementUnlockDomain> stream;

  @override
  Stream<AchievementUnlockDomain> watch() => stream;
}

void main() {
  test('delegates to the achievement unlock repository', () async {
    const event = AchievementUnlockDomain(
      achievementId: 'ach-1',
      code: 'first_step',
      name: 'Primeiro passo',
    );
    final controller = StreamController<AchievementUnlockDomain>();
    final sut = WatchAchievementUnlocks(_Repo(controller.stream));

    final values = <AchievementUnlockDomain>[];
    final sub = sut().listen(values.add);
    controller.add(event);
    await Future<void>.delayed(Duration.zero);

    expect(values, [event]);
    await sub.cancel();
    await controller.close();
  });
}

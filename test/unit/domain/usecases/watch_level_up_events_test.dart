import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume/layers/domain/repository/level_up_repository.dart';
import 'package:lume/layers/domain/usecases/watch_level_up_events.dart';

class _Repo implements ILevelUpRepository {
  _Repo(this.stream);

  final Stream<LevelUpDomain> stream;

  @override
  Stream<LevelUpDomain> watch() => stream;
}

void main() {
  test('delegates to the level-up repository', () async {
    const event = LevelUpDomain(
      level: 3,
      xpOffset: 100,
      currentXp: 103,
      xpForNextLevel: 200,
    );
    final controller = StreamController<LevelUpDomain>();
    final sut = WatchLevelUpEvents(_Repo(controller.stream));

    final values = <LevelUpDomain>[];
    final sub = sut().listen(values.add);
    controller.add(event);
    await Future<void>.delayed(Duration.zero);

    expect(values, [event]);
    await sub.cancel();
    await controller.close();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to trail repository', () async {
    final repository = MockITrailRepository();
    final sut = GetGameTrails(repository);
    const expected = [
      GameTrailDomain(
        id: 1,
        title: 'History',
        sortOrder: 1,
        emoji: '📜',
      ),
    ];
    when(repository.getGameTrails(forceRefresh: false)).thenAnswer((_) async => expected);

    final result = await sut.call();

    expect(result, expected);
    verify(repository.getGameTrails(forceRefresh: false)).called(1);
  });
}

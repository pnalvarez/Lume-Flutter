import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/usecases/get_submodule_games.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to game repository', () async {
    final repository = MockIGameRepository();
    final sut = GetSubmoduleGames(repository);
    const expected = SubmoduleGamesDomain(
      id: 9,
      title: 'Preview',
      sortOrder: 1,
    );
    when(
      repository.getSubmoduleGames(submoduleId: 9, forceRefresh: false),
    ).thenAnswer((_) async => expected);

    final result = await sut.call(submoduleId: 9);

    expect(result, expected);
    verify(
      repository.getSubmoduleGames(submoduleId: 9, forceRefresh: false),
    ).called(1);
  });
}

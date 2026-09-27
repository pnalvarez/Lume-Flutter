import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to game repository', () async {
    final repository = MockIGameRepository();
    final sut = StartGameMatch(repository);
    when(
      repository.startGameMatch(gameSlug: 'leilao_dicas'),
    ).thenAnswer((_) async => 'match-1');

    final result = await sut.call(gameSlug: 'leilao_dicas');

    expect(result, 'match-1');
    verify(repository.startGameMatch(gameSlug: 'leilao_dicas')).called(1);
  });
}

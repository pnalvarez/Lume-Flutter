import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/curiosity_data.dart';
import 'package:lume/layers/data/repository/curiosity_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockICuriosityDataSource dataSource;
  late CuriosityRepository sut;
  final day = DateTime(2026, 3, 7);

  setUp(() {
    dataSource = MockICuriosityDataSource();
    sut = CuriosityRepository(dataSource);
  });

  test('getDailyCuriosity maps data to domain', () async {
    when(dataSource.fetchDailyCuriosity(day)).thenAnswer(
      (_) async => const CuriosityData(id: 'c-1', title: 'T', opened: true),
    );

    final result = await sut.getDailyCuriosity(day);

    expect(result!.id, 'c-1');
    expect(result.title, 'T');
    expect(result.opened, isTrue);
  });

  test('getDailyCuriosity returns null when there is no curiosity', () async {
    when(dataSource.fetchDailyCuriosity(day)).thenAnswer((_) async => null);

    expect(await sut.getDailyCuriosity(day), isNull);
  });

  test('getDailyCuriosity propagates data source errors', () async {
    when(
      dataSource.fetchDailyCuriosity(day),
    ).thenAnswer((_) async => throw StateError('boom'));

    await expectLater(sut.getDailyCuriosity(day), throwsStateError);
  });

  test('markCuriositySeen delegates to the data source', () async {
    when(dataSource.markSeen('c-1')).thenAnswer((_) async {});

    await sut.markCuriositySeen('c-1');

    verify(dataSource.markSeen('c-1')).called(1);
  });
}

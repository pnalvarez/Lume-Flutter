import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/mappers/profile_mapper.dart';
import 'package:lume/layers/data/models/profile_data.dart';

void main() {
  test('toDomain computes daysInApp from createdAt when RPC returns 0', () {
    final createdAt = DateTime.now().toUtc().subtract(const Duration(days: 30));
    final data = ProfileData(id: 'user-1', createdAt: createdAt, daysInApp: 0);

    final domain = ProfileMapper.toDomain(data);

    final expected = DateTime.now().difference(createdAt).inDays;
    expect(domain.daysInApp, expected);
    expect(domain.daysInApp, greaterThan(0));
  });

  test('toDomain keeps non-zero daysInApp from the backend untouched', () {
    final createdAt = DateTime.now().toUtc().subtract(
      const Duration(days: 365),
    );
    final data = ProfileData(id: 'user-1', createdAt: createdAt, daysInApp: 12);

    final domain = ProfileMapper.toDomain(data);

    expect(domain.daysInApp, 12);
  });

  test('toDomain leaves daysInApp at 0 when createdAt is also unavailable', () {
    final data = ProfileData(id: 'user-1', createdAt: null, daysInApp: 0);

    final domain = ProfileMapper.toDomain(data);

    expect(domain.daysInApp, 0);
  });

  test('toDomain does not compute negative daysInApp for same-day signup', () {
    final data = ProfileData(
      id: 'user-1',
      createdAt: DateTime.now().toUtc(),
      daysInApp: 0,
    );

    final domain = ProfileMapper.toDomain(data);

    expect(domain.daysInApp, 0);
  });
}

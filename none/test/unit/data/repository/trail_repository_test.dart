import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/trail_progress_data.dart';
import 'package:lume/layers/data/repository/trail_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockITrailDataSource dataSource;
  late TrailRepository sut;

  setUp(() {
    dataSource = MockITrailDataSource();
    sut = TrailRepository(dataSource);
  });

  test(
    'getBootstrap maps TrailBootstrapData to TrailBootstrapDomain',
    () async {
      when(dataSource.fetchBootstrap(forceRefresh: false)).thenAnswer(
        (_) async => TrailBootstrapData.fromJson({
          'trail_started_at': '2026-08-17T12:00:00Z',
          'modules': [
            {
              'id': 1,
              'sort_order': 1,
              'title': 'History',
              'emoji': '📜',
              'color': '#111',
            },
          ],
        }),
      );

      final bootstrap = await sut.getBootstrap();

      expect(bootstrap.modules.single.title, 'History');
      expect(bootstrap.trailStartedAt, DateTime.utc(2026, 8, 17, 12));
    },
  );

  test(
    'savePairProgress maps PairProgressData to PairProgressDomain',
    () async {
      when(dataSource.savePairProgress(pairId: 4, scorePct: 80)).thenAnswer(
        (_) async => PairProgressData.fromJson({
          'pair_id': 4,
          'completed': true,
          'score_pct': 80,
          'preview_seen': true,
        }),
      );

      final progress = await sut.savePairProgress(pairId: 4, scorePct: 80);

      expect(progress.pairId, 4);
      expect(progress.completed, isTrue);
      expect(progress.scorePct, 80);
    },
  );
}

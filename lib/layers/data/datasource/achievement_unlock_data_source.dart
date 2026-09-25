import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/achievement_unlock_data.dart';

abstract interface class IAchievementUnlockDataSource {
  /// Live inserts on `player_achievement_events` for the signed-in user.
  Stream<AchievementUnlockData> watch();
}

@LazySingleton(as: IAchievementUnlockDataSource)
final class AchievementUnlockDataSource
    implements IAchievementUnlockDataSource {
  AchievementUnlockDataSource(this._realtime, this._session);

  static const _table = 'player_achievement_events';

  final IRealtimeClient _realtime;
  final IAuthSessionProvider _session;

  @override
  Stream<AchievementUnlockData> watch() {
    return Stream<AchievementUnlockData>.multi((controller) {
      StreamSubscription<void>? authSub;
      StreamSubscription<Map<String, dynamic>>? insertsSub;

      void resubscribe() {
        insertsSub?.cancel();
        insertsSub = null;
        final userId = _session.userId;
        if (userId == null) return;
        insertsSub = _realtime
            .watchInserts(
              table: _table,
              filterColumn: 'user_id',
              filterValue: userId,
            )
            .listen(
              (row) => controller.add(
                AchievementUnlockData.fromJson(asJsonMap(row)),
              ),
              onError: controller.addError,
            );
      }

      resubscribe();
      authSub = _session.changes.listen((_) => resubscribe());
      controller.onCancel = () async {
        await authSub?.cancel();
        await insertsSub?.cancel();
      };
    });
  }
}

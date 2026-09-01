import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/level_up_data.dart';

abstract interface class ILevelUpDataSource {
  /// Live inserts on `player_level_up_events` for the signed-in user.
  Stream<LevelUpData> watch();
}

@LazySingleton(as: ILevelUpDataSource)
final class LevelUpDataSource implements ILevelUpDataSource {
  LevelUpDataSource(this._realtime, this._session);

  static const _table = 'player_level_up_events';

  final IRealtimeClient _realtime;
  final IAuthSessionProvider _session;

  @override
  Stream<LevelUpData> watch() {
    return Stream<LevelUpData>.multi((controller) {
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
              (row) => controller.add(LevelUpData.fromJson(asJsonMap(row))),
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

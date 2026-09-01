import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin adapter over Supabase Realtime. The only type besides [IAuthService]
/// and bootstrap that may import the SDK.
abstract interface class IRealtimeClient {
  /// Emits each new row inserted into [table] where [filterColumn] equals
  /// [filterValue]. Cancelling the subscription leaves the channel.
  Stream<Map<String, dynamic>> watchInserts({
    required String table,
    required String filterColumn,
    required String filterValue,
    String schema = 'public',
  });
}

@LazySingleton(as: IRealtimeClient)
final class RealtimeClient implements IRealtimeClient {
  RealtimeClient() : this._();

  @visibleForTesting
  RealtimeClient.withClient(SupabaseClient client) : this._(client: client);

  RealtimeClient._({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;

  SupabaseClient get _client => _clientOverride ?? Supabase.instance.client;

  @override
  Stream<Map<String, dynamic>> watchInserts({
    required String table,
    required String filterColumn,
    required String filterValue,
    String schema = 'public',
  }) {
    final controller = StreamController<Map<String, dynamic>>();
    RealtimeChannel? channel;

    controller.onListen = () {
      final topic =
          'inserts:$schema.$table:$filterColumn=$filterValue'
          ':${identityHashCode(controller)}';
      channel = _client
          .channel(topic)
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: schema,
            table: table,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: filterColumn,
              value: filterValue,
            ),
            callback: (payload) {
              if (controller.isClosed) return;
              controller.add(Map<String, dynamic>.from(payload.newRecord));
            },
          )
          .subscribe();
    };

    controller.onCancel = () async {
      final subscribed = channel;
      channel = null;
      if (subscribed == null) return;
      await _client.removeChannel(subscribed);
    };

    return controller.stream;
  }
}

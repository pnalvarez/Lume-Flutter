import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';

/// IANA timezone of the device (for example `America/Sao_Paulo`).
abstract interface class IDeviceTimezone {
  /// Current device timezone, or `null` when it cannot be resolved.
  Future<String?> current();
}

@LazySingleton(as: IDeviceTimezone)
final class DeviceTimezone implements IDeviceTimezone {
  @override
  Future<String?> current() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final id = info.identifier;
      return id.isEmpty ? null : id;
    } on Object catch (error, stack) {
      debugPrint('Device timezone lookup failed: $error\n$stack');
      return null;
    }
  }
}

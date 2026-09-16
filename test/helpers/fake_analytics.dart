import 'package:lume/core/analytics/analytics.dart';

/// Records [logEvent] / [setUserId] calls for bloc unit tests.
final class FakeAnalytics implements IAnalytics {
  final List<({String name, Map<String, Object>? parameters})> events = [];
  final List<String?> userIds = [];

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    events.add((name: name, parameters: parameters));
  }

  @override
  Future<void> setUserId(String? userId) async {
    userIds.add(userId);
  }

  bool hasEvent(String name) => events.any((e) => e.name == name);

  Map<String, Object>? parametersFor(String name) {
    for (final event in events.reversed) {
      if (event.name == name) return event.parameters;
    }
    return null;
  }
}

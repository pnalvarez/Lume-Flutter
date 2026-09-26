import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import '../../helpers/fake_analytics.dart';

class _SignOut implements ISignOut {
  var calls = 0;

  @override
  Future<void> call() async {
    calls += 1;
  }
}

class _RemoteConfig implements IRemoteConfig {
  _RemoteConfig({this.achievements = false});

  final bool achievements;

  @override
  bool get arcadeEnabled => true;

  @override
  bool get achievementsEnabled => achievements;

  @override
  Map<String, Object> get debugOverrides => const {};

  @override
  bool getBool(String key, {required bool defaultValue}) {
    if (key == RemoteConfigKeys.achievementsEnabled) return achievements;
    return defaultValue;
  }

  @override
  String getString(String key, {required String defaultValue}) => defaultValue;

  @override
  Future<void> refresh() async {}

  @override
  void setDebugOverride(String key, Object? value) {}
}

void main() {
  FakeAnalytics? dashboardAnalytics;

  setUp(() => dashboardAnalytics = null);
  test('initial state hides achievements when flag is off', () {
    final bloc = DashboardBloc(_SignOut(), FakeAnalytics(), _RemoteConfig());
    expect(bloc.state.showAchievements, isFalse);
    bloc.close();
  });

  test('initial state shows achievements when flag is on', () {
    final bloc = DashboardBloc(
      _SignOut(),
      FakeAnalytics(),
      _RemoteConfig(achievements: true),
    );
    expect(bloc.state.showAchievements, isTrue);
    bloc.close();
  });

  test('sign out goes to login and clears analytics user id', () async {
    final signOut = _SignOut();
    final analytics = FakeAnalytics();
    final bloc = DashboardBloc(signOut, analytics, _RemoteConfig());
    bloc.add(const DashboardSignOutPressed());
    await expectLater(
      bloc.stream,
      emitsInOrder([
        const DashboardState(isSigningOut: true),
        const DashboardState(goToLogin: true),
      ]),
    );
    expect(signOut.calls, 1);
    expect(analytics.userIds, [null]);
    await bloc.close();
  });

  blocTest<DashboardBloc, DashboardState>(
    'sign out goes to login',
    build: () => DashboardBloc(_SignOut(), FakeAnalytics(), _RemoteConfig()),
    act: (bloc) => bloc.add(const DashboardSignOutPressed()),
    expect: () => [
      const DashboardState(isSigningOut: true),
      const DashboardState(goToLogin: true),
    ],
  );

  blocTest<DashboardBloc, DashboardState>(
    'sign out preserves showAchievements from remote config',
    build: () => DashboardBloc(
      _SignOut(),
      FakeAnalytics(),
      _RemoteConfig(achievements: true),
    ),
    act: (bloc) => bloc.add(const DashboardSignOutPressed()),
    expect: () => [
      const DashboardState(isSigningOut: true, showAchievements: true),
      const DashboardState(goToLogin: true, showAchievements: true),
    ],
  );

  blocTest<DashboardBloc, DashboardState>(
    'DashboardStarted fires achievementsTabImpression when achievements enabled',
    build: () {
      final analytics = FakeAnalytics();
      dashboardAnalytics = analytics;
      return DashboardBloc(
        _SignOut(),
        analytics,
        _RemoteConfig(achievements: true),
      );
    },
    act: (bloc) => bloc.add(const DashboardStarted()),
    verify: (_) {
      expect(
        dashboardAnalytics!.hasEvent(AnalyticsEvents.achievementsTabImpression),
        isTrue,
      );
      final params = dashboardAnalytics!.parametersFor(
        AnalyticsEvents.achievementsTabImpression,
      );
      expect(params?[AnalyticsParams.achievementsEnabled], isTrue);
    },
  );

  blocTest<DashboardBloc, DashboardState>(
    'DashboardStarted does not fire achievementsTabImpression when flag is off',
    build: () {
      final analytics = FakeAnalytics();
      dashboardAnalytics = analytics;
      return DashboardBloc(_SignOut(), analytics, _RemoteConfig());
    },
    act: (bloc) => bloc.add(const DashboardStarted()),
    verify: (_) {
      expect(
        dashboardAnalytics!.hasEvent(AnalyticsEvents.achievementsTabImpression),
        isFalse,
      );
    },
  );
}

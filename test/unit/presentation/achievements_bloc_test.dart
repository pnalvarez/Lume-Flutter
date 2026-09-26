import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/models/achievement/achievement_icon.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_bloc.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import '../../helpers/fake_analytics.dart';

class _GetAchievements implements IGetAchievements {
  List<AchievementDomain> result = const [
    AchievementDomain(
      id: 'a1',
      code: 'first_submodule',
      name: 'Primeiro passo',
      description: 'Complete 1 submódulo na trilha.',
      icon: AchievementIcon.trophy,
      conditionType: 'trail_submodules_completed',
      conditionTarget: 1,
      rewardType: 'xp',
      rewardAmount: 25,
      progress: 1,
      completedAt: null,
    ),
    AchievementDomain(
      id: 'a2',
      code: 'submodules_5',
      name: 'Explorador',
      description: 'Complete 5 submódulos na trilha.',
      icon: AchievementIcon.trophy,
      conditionType: 'trail_submodules_completed',
      conditionTarget: 5,
      rewardType: 'xp',
      rewardAmount: 50,
      progress: 3,
    ),
    AchievementDomain(
      id: 'a3',
      code: 'arcade_20',
      name: 'Arcade 20',
      description: 'Alcance 20 pontos em uma partida no Arcade.',
      icon: AchievementIcon.trophy,
      conditionType: 'arcade_best_rounds',
      conditionTarget: 20,
      rewardType: 'xp',
      rewardAmount: 40,
      progress: 0,
    ),
  ];
  Object? error;
  var calls = 0;

  @override
  Future<List<AchievementDomain>> call() async {
    calls += 1;
    if (error != null) throw error!;
    return result;
  }
}

class _FakeRemoteConfig implements IRemoteConfig {
  @override
  bool get arcadeEnabled => true;
  @override
  bool get achievementsEnabled => true;
  @override
  Map<String, Object> get debugOverrides => const {};
  @override
  bool getBool(String key, {required bool defaultValue}) => defaultValue;
  @override
  String getString(String key, {required String defaultValue}) => defaultValue;
  @override
  Future<void> refresh() async {}
  @override
  void setDebugOverride(String key, Object? value) {}
}

void main() {
  late _GetAchievements getAchievements;
  late FakeAnalytics analytics;

  setUp(() {
    getAchievements = _GetAchievements();
    analytics = FakeAnalytics();
  });

  AchievementsBloc buildBloc() =>
      AchievementsBloc(getAchievements, analytics, _FakeRemoteConfig());

  blocTest<AchievementsBloc, AchievementsState>(
    'loads catalog into ready state with status mapping',
    build: buildBloc,
    act: (bloc) => bloc.add(const AchievementsStarted()),
    expect: () => [
      isA<AchievementsState>().having(
        (s) => s.status,
        'status',
        AchievementsStatus.loading,
      ),
      isA<AchievementsState>()
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.items, 'items', hasLength(3))
          .having(
            (s) => s.items[0].status,
            'first status',
            // progress 1, target 1, no completedAt → inProgress
            AchievementListItemStatus.inProgress,
          )
          .having(
            (s) => s.items[1].status,
            'second status',
            AchievementListItemStatus.inProgress,
          )
          .having(
            (s) => s.items[2].status,
            'third status',
            AchievementListItemStatus.locked,
          )
          .having((s) => s.items[0].title, 'title', 'Primeiro passo'),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'maps completed_at to completed status',
    build: () {
      getAchievements.result = [
        AchievementDomain(
          id: 'a1',
          code: 'first_submodule',
          name: 'Primeiro passo',
          description: 'Complete 1 submódulo na trilha.',
          conditionType: 'trail_submodules_completed',
          conditionTarget: 1,
          rewardType: 'xp',
          rewardAmount: 25,
          progress: 1,
          completedAt: DateTime.utc(2026, 1, 1),
        ),
      ];
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AchievementsStarted()),
    expect: () => [
      isA<AchievementsState>(),
      isA<AchievementsState>()
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having(
            (s) => s.items.single.status,
            'status',
            AchievementListItemStatus.completed,
          ),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'emits error when load fails',
    build: () {
      getAchievements.error = Exception('network');
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AchievementsStarted()),
    expect: () => [
      isA<AchievementsState>().having(
        (s) => s.status,
        'status',
        AchievementsStatus.loading,
      ),
      isA<AchievementsState>()
          .having((s) => s.status, 'status', AchievementsStatus.error)
          .having((s) => s.errorMessage, 'error', achievementsLoadError)
          .having((s) => s.items, 'items', isEmpty),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'keeps rows and sets inline error when reload fails',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) {
      getAchievements.error = Exception('network');
      bloc.add(const AchievementsStarted());
    },
    expect: () => [
      isA<AchievementsState>()
          .having((s) => s.isRefreshing, 'refreshing', isTrue)
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.items, 'items', hasLength(3)),
      isA<AchievementsState>()
          .having((s) => s.isRefreshing, 'refreshing', isFalse)
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.items, 'items', hasLength(3))
          .having((s) => s.errorMessage, 'error', achievementsLoadError),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'reload keeps ready status without skeleton when items exist',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) => bloc.add(const AchievementsStarted()),
    expect: () => [
      isA<AchievementsState>()
          .having((s) => s.isRefreshing, 'refreshing', isTrue)
          .having((s) => s.showSkeleton, 'skeleton', isFalse)
          .having((s) => s.items, 'items', hasLength(3)),
      isA<AchievementsState>()
          .having((s) => s.isRefreshing, 'refreshing', isFalse)
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.items, 'items', hasLength(3)),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'toggles status filters as multi-select',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) {
      bloc.add(
        const AchievementsFilterToggled(AchievementListItemStatus.locked),
      );
      bloc.add(
        const AchievementsFilterToggled(AchievementListItemStatus.completed),
      );
      bloc.add(
        const AchievementsFilterToggled(AchievementListItemStatus.locked),
      );
    },
    expect: () => [
      isA<AchievementsState>().having(
        (s) => s.selectedStatusFilters,
        'filters',
        {AchievementListItemStatus.locked},
      ),
      isA<AchievementsState>().having(
        (s) => s.selectedStatusFilters,
        'filters',
        {AchievementListItemStatus.locked, AchievementListItemStatus.completed},
      ),
      isA<AchievementsState>().having(
        (s) => s.selectedStatusFilters,
        'filters',
        {AchievementListItemStatus.completed},
      ),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'visibleItems respects selected status filters',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(
      getAchievements.result,
      selectedStatusFilters: {AchievementListItemStatus.locked},
    ),
    verify: (bloc) {
      expect(bloc.state.visibleItems, hasLength(1));
      expect(
        bloc.state.visibleItems.single.status,
        AchievementListItemStatus.locked,
      );
    },
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'reload preserves selected status filters',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(
      getAchievements.result,
      selectedStatusFilters: {
        AchievementListItemStatus.completed,
        AchievementListItemStatus.inProgress,
      },
    ),
    act: (bloc) => bloc.add(const AchievementsStarted()),
    expect: () => [
      isA<AchievementsState>()
          .having((s) => s.isRefreshing, 'refreshing', isTrue)
          .having((s) => s.selectedStatusFilters, 'filters', {
            AchievementListItemStatus.completed,
            AchievementListItemStatus.inProgress,
          }),
      isA<AchievementsState>()
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.selectedStatusFilters, 'filters', {
            AchievementListItemStatus.completed,
            AchievementListItemStatus.inProgress,
          }),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'filter toggled during reload is not overwritten by fromDomain emit',
    // Toggle before the reload: proves fromDomain reads state.selectedStatusFilters
    // at emit time, not a snapshot captured before the RPC.
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(
      getAchievements.result,
      selectedStatusFilters: {AchievementListItemStatus.inProgress},
    ),
    act: (bloc) {
      // Toggle to a new set, then reload — the reload must see the new set.
      bloc.add(
        const AchievementsFilterToggled(AchievementListItemStatus.locked),
      );
      bloc.add(const AchievementsStarted());
    },
    expect: () => [
      // toggle adds locked
      isA<AchievementsState>().having(
        (s) => s.selectedStatusFilters,
        'filters after toggle',
        {
          AchievementListItemStatus.inProgress,
          AchievementListItemStatus.locked,
        },
      ),
      // refreshing intermediate
      isA<AchievementsState>().having(
        (s) => s.isRefreshing,
        'refreshing',
        isTrue,
      ),
      // fromDomain must preserve the post-toggle set
      isA<AchievementsState>()
          .having((s) => s.status, 'status', AchievementsStatus.ready)
          .having((s) => s.selectedStatusFilters, 'filters after reload', {
            AchievementListItemStatus.inProgress,
            AchievementListItemStatus.locked,
          }),
    ],
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'logs achievements_opened and achievements_list_viewed on first load',
    build: buildBloc,
    act: (bloc) => bloc.add(const AchievementsStarted()),
    verify: (_) {
      expect(
        analytics.hasEvent(AnalyticsEvents.achievementsOpened),
        isTrue,
        reason: 'achievementsOpened fires before the RPC on first load',
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.achievementsTabImpression),
        isFalse,
        reason: 'achievementsTabImpression is owned by DashboardBloc, not here',
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.achievementsListViewed),
        isTrue,
      );
      final params = analytics.parametersFor(
        AnalyticsEvents.achievementsListViewed,
      );
      expect(params?[AnalyticsParams.lockedCount], 1);
      expect(params?[AnalyticsParams.inProgressCount], 2);
      expect(params?[AnalyticsParams.completedCount], 0);
    },
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'logs achievements_filter_applied with correct params on toggle',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) => bloc.add(
      const AchievementsFilterToggled(AchievementListItemStatus.locked),
    ),
    verify: (_) {
      expect(
        analytics.hasEvent(AnalyticsEvents.achievementsFilterApplied),
        isTrue,
      );
      final params = analytics.parametersFor(
        AnalyticsEvents.achievementsFilterApplied,
      );
      expect(params?[AnalyticsParams.filterStatus], 'locked');
      expect(params?[AnalyticsParams.activeFilterCount], 1);
    },
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'filter_status uses snake_case: inProgress maps to in_progress',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) => bloc.add(
      const AchievementsFilterToggled(AchievementListItemStatus.inProgress),
    ),
    verify: (_) {
      final params = analytics.parametersFor(
        AnalyticsEvents.achievementsFilterApplied,
      );
      expect(
        params?[AnalyticsParams.filterStatus],
        'in_progress',
        reason: 'enum.name gives inProgress; contract requires in_progress',
      );
    },
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'filter_status uses snake_case: completed maps to completed',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(getAchievements.result),
    act: (bloc) => bloc.add(
      const AchievementsFilterToggled(AchievementListItemStatus.completed),
    ),
    verify: (_) {
      final params = analytics.parametersFor(
        AnalyticsEvents.achievementsFilterApplied,
      );
      expect(params?[AnalyticsParams.filterStatus], 'completed');
    },
  );

  blocTest<AchievementsBloc, AchievementsState>(
    'logs achievements_filter_cleared with previous count on AchievementsFilterCleared',
    build: buildBloc,
    seed: () => AchievementsState.fromDomain(
      getAchievements.result,
      selectedStatusFilters: {
        AchievementListItemStatus.locked,
        AchievementListItemStatus.completed,
      },
    ),
    act: (bloc) => bloc.add(const AchievementsFilterCleared()),
    expect: () => [
      isA<AchievementsState>().having(
        (s) => s.selectedStatusFilters,
        'filters cleared',
        isEmpty,
      ),
    ],
    verify: (_) {
      expect(
        analytics.hasEvent(AnalyticsEvents.achievementsFilterCleared),
        isTrue,
      );
      final params = analytics.parametersFor(
        AnalyticsEvents.achievementsFilterCleared,
      );
      expect(params?[AnalyticsParams.previousFilterCount], 2);
    },
  );
}

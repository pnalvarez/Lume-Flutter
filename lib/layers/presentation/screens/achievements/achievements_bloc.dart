import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';

@injectable
final class AchievementsBloc
    extends Bloc<AchievementsEvent, AchievementsState> {
  AchievementsBloc(this._getAchievements, this._analytics, this._remoteConfig)
    : super(const AchievementsState()) {
    on<AchievementsStarted>(_onStarted);
    on<AchievementsFilterToggled>(_onFilterToggled);
    on<AchievementsFilterCleared>(_onFilterCleared);
  }

  final IGetAchievements _getAchievements;
  final IAnalytics _analytics;
  final IRemoteConfig _remoteConfig;

  void _logEvent(String name, {Map<String, Object>? parameters}) =>
      _analytics.logEvent(name, parameters: parameters);

  Future<void> _onStarted(
    AchievementsStarted event,
    Emitter<AchievementsState> emit,
  ) async {
    final keepItems = state.items.isNotEmpty;
    final filterVariation = AchievementListFilterVariation.parse(
      _remoteConfig.achievementsFilterLayout,
    );
    final selectedStatusFilters = _selectionFor(
      filterVariation,
      state.selectedStatusFilters,
    );

    // Fire before any state change or RPC so the open is always counted,
    // even when the load fails.  Only on the first/fresh load (empty state)
    // so pull-to-refresh and pop-back do not inflate the metric.
    if (!keepItems) {
      _logEvent(
        AnalyticsEvents.achievementsOpened,
        parameters: {
          AnalyticsParams.achievementsEnabled:
              _remoteConfig.achievementsEnabled,
        },
      );
    }

    if (keepItems) {
      emit(
        state.copyWith(
          isRefreshing: true,
          clearError: true,
          filterVariation: filterVariation,
          selectedStatusFilters: selectedStatusFilters,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AchievementsStatus.loading,
          isRefreshing: false,
          clearError: true,
          filterVariation: filterVariation,
          selectedStatusFilters: selectedStatusFilters,
        ),
      );
    }

    try {
      final achievements = await _getAchievements();
      // Read selectedStatusFilters from state *after* the await so any
      // AchievementsFilterToggled that arrived during the RPC is preserved.
      final newState = AchievementsState.fromDomain(
        achievements,
        selectedStatusFilters: _selectionFor(
          filterVariation,
          state.selectedStatusFilters,
        ),
        filterVariation: filterVariation,
      );
      emit(newState);

      // Fire-and-forget: analytics must never block or delay the UI.
      _logEvent(
        AnalyticsEvents.achievementsListViewed,
        parameters: {
          AnalyticsParams.lockedCount: newState.items
              .where((i) => i.status == AchievementListItemStatus.locked)
              .length,
          AnalyticsParams.inProgressCount: newState.items
              .where((i) => i.status == AchievementListItemStatus.inProgress)
              .length,
          AnalyticsParams.completedCount: newState.items
              .where((i) => i.status == AchievementListItemStatus.completed)
              .length,
        },
      );
    } on Object {
      if (keepItems) {
        emit(
          state.copyWith(
            status: AchievementsStatus.ready,
            isRefreshing: false,
            errorMessage: achievementsLoadError,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AchievementsStatus.error,
            isRefreshing: false,
            errorMessage: achievementsLoadError,
          ),
        );
      }
    }
  }

  void _onFilterToggled(
    AchievementsFilterToggled event,
    Emitter<AchievementsState> emit,
  ) {
    final next = switch (state.filterVariation) {
      AchievementListFilterVariation.chips => _toggledChips(
        state.selectedStatusFilters,
        event.status,
      ),
      AchievementListFilterVariation.tabs ||
      AchievementListFilterVariation.selector => {event.status},
    };
    emit(state.copyWith(selectedStatusFilters: next));

    _logEvent(
      AnalyticsEvents.achievementsFilterApplied,
      parameters: {
        AnalyticsParams.filterStatus: _statusLabel(event.status),
        AnalyticsParams.activeFilterCount: next.length,
        AnalyticsParams.visibleCount: state.visibleItems.length,
      },
    );
  }

  static Set<AchievementListItemStatus> _selectionFor(
    AchievementListFilterVariation variation,
    Set<AchievementListItemStatus> current,
  ) {
    if (!variation.isExclusive) return current;
    for (final status in achievementFilterCategories) {
      if (current.contains(status)) return {status};
    }
    return {achievementFilterCategories.first};
  }

  static Set<AchievementListItemStatus> _toggledChips(
    Set<AchievementListItemStatus> current,
    AchievementListItemStatus status,
  ) {
    final next = Set<AchievementListItemStatus>.of(current);
    if (!next.add(status)) next.remove(status);
    return next;
  }

  /// Maps enum values to the snake_case strings required by the analytics
  /// contract.  [AchievementListItemStatus.inProgress.name] gives `inProgress`,
  /// not `in_progress`, so we convert explicitly here.
  static String _statusLabel(AchievementListItemStatus status) =>
      switch (status) {
        AchievementListItemStatus.locked => 'locked',
        AchievementListItemStatus.inProgress => 'in_progress',
        AchievementListItemStatus.completed => 'completed',
      };

  void _onFilterCleared(
    AchievementsFilterCleared event,
    Emitter<AchievementsState> emit,
  ) {
    if (state.filterVariation.isExclusive) return;
    final previousCount = state.selectedStatusFilters.length;
    emit(state.copyWith(selectedStatusFilters: {}));
    _logEvent(
      AnalyticsEvents.achievementsFilterCleared,
      parameters: {AnalyticsParams.previousFilterCount: previousCount},
    );
  }
}

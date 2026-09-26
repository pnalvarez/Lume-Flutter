import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/models/achievement/achievement_icon.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';

enum AchievementsStatus { loading, ready, error }

@immutable
final class AchievementListItemUi {
  const AchievementListItemUi({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.target,
    this.icon = Icons.emoji_events_rounded,
  });

  final String id;
  final String title;
  final String description;
  final AchievementListItemStatus status;
  final int progress;
  final int target;
  final IconData icon;

  factory AchievementListItemUi.fromDomain(AchievementDomain achievement) {
    return AchievementListItemUi(
      id: achievement.id,
      title: achievement.name,
      description: achievement.description,
      status: _statusFor(achievement),
      progress: achievement.progress,
      target: achievement.conditionTarget,
      icon: _iconFor(achievement.icon),
    );
  }

  static AchievementListItemStatus _statusFor(AchievementDomain achievement) {
    if (achievement.completedAt != null) {
      return AchievementListItemStatus.completed;
    }
    if (achievement.progress <= 0) {
      return AchievementListItemStatus.locked;
    }
    return AchievementListItemStatus.inProgress;
  }

  static IconData _iconFor(AchievementIcon icon) {
    return switch (icon) {
      AchievementIcon.trophy ||
      AchievementIcon.unknown => Icons.emoji_events_rounded,
      AchievementIcon.star => Icons.star_rounded,
      AchievementIcon.flame => Icons.local_fire_department_rounded,
      AchievementIcon.gamepad => Icons.sports_esports_rounded,
      AchievementIcon.zap => Icons.bolt_rounded,
      AchievementIcon.explore => Icons.explore_rounded,
      AchievementIcon.brain => Icons.psychology_rounded,
      AchievementIcon.landmark => Icons.account_balance_rounded,
      AchievementIcon.layers => Icons.layers_rounded,
      AchievementIcon.checkCircle => Icons.check_circle_rounded,
      AchievementIcon.clock => Icons.schedule_rounded,
      AchievementIcon.gavel => Icons.gavel_rounded,
      AchievementIcon.globe => Icons.public_rounded,
      AchievementIcon.image => Icons.image_rounded,
      AchievementIcon.mapPin => Icons.location_on_rounded,
      AchievementIcon.rewind => Icons.fast_rewind_rounded,
      AchievementIcon.swords => Icons.sports_mma_rounded,
      AchievementIcon.user => Icons.person_rounded,
      AchievementIcon.compass => Icons.explore_rounded,
      AchievementIcon.package => Icons.inventory_2_rounded,
      AchievementIcon.repeat => Icons.repeat_rounded,
      AchievementIcon.sparkles => Icons.auto_awesome_rounded,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is AchievementListItemUi &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.status == status &&
      other.progress == progress &&
      other.target == target &&
      other.icon == icon;

  @override
  int get hashCode =>
      Object.hash(id, title, description, status, progress, target, icon);
}

@immutable
final class AchievementsState {
  const AchievementsState({
    this.status = AchievementsStatus.loading,
    this.items = const [],
    this.selectedStatusFilters = const {},
    this.isRefreshing = false,
    this.errorMessage,
  });

  final AchievementsStatus status;
  final List<AchievementListItemUi> items;

  /// Active status chips. Empty means show the full catalog.
  final Set<AchievementListItemStatus> selectedStatusFilters;
  final bool isRefreshing;
  final String? errorMessage;

  bool get isLoading => status == AchievementsStatus.loading;

  /// First paint with no rows yet — show skeleton instead of an empty list.
  bool get showSkeleton => isLoading && items.isEmpty;

  /// Full-screen error only when there is nothing to keep on screen.
  bool get showFullScreenError =>
      status == AchievementsStatus.error && items.isEmpty;

  /// Whether the filter chip row should appear (catalog loaded with rows).
  bool get showStatusFilters =>
      !showSkeleton && !showFullScreenError && items.isNotEmpty;

  /// Items after applying [selectedStatusFilters].
  List<AchievementListItemUi> get visibleItems {
    if (selectedStatusFilters.isEmpty) return items;
    return [
      for (final item in items)
        if (selectedStatusFilters.contains(item.status)) item,
    ];
  }

  factory AchievementsState.fromDomain(
    List<AchievementDomain> achievements, {
    Set<AchievementListItemStatus> selectedStatusFilters = const {},
  }) {
    return AchievementsState(
      status: AchievementsStatus.ready,
      items: [
        for (final achievement in achievements)
          AchievementListItemUi.fromDomain(achievement),
      ],
      selectedStatusFilters: selectedStatusFilters,
    );
  }

  AchievementsState copyWith({
    AchievementsStatus? status,
    List<AchievementListItemUi>? items,
    Set<AchievementListItemStatus>? selectedStatusFilters,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AchievementsState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedStatusFilters:
          selectedStatusFilters ?? this.selectedStatusFilters,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AchievementsState &&
      other.status == status &&
      listEquals(other.items, items) &&
      setEquals(other.selectedStatusFilters, selectedStatusFilters) &&
      other.isRefreshing == isRefreshing &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(items),
    Object.hashAll(selectedStatusFilters),
    isRefreshing,
    errorMessage,
  );
}

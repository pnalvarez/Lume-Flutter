import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
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

  static IconData _iconFor(String? icon) {
    return switch (icon?.trim().toLowerCase()) {
      'trophy' || 'emoji_events' || 'award' => Icons.emoji_events_rounded,
      'star' => Icons.star_rounded,
      'flame' || 'fire' => Icons.local_fire_department_rounded,
      'bolt' || 'zap' => Icons.bolt_rounded,
      'gamepad' || 'sports_esports' => Icons.sports_esports_rounded,
      'explore' => Icons.explore_rounded,
      _ => Icons.emoji_events_rounded,
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
    this.errorMessage,
  });

  final AchievementsStatus status;
  final List<AchievementListItemUi> items;
  final String? errorMessage;

  bool get isLoading => status == AchievementsStatus.loading;

  factory AchievementsState.fromDomain(List<AchievementDomain> achievements) {
    return AchievementsState(
      status: AchievementsStatus.ready,
      items: [
        for (final achievement in achievements)
          AchievementListItemUi.fromDomain(achievement),
      ],
    );
  }

  AchievementsState copyWith({
    AchievementsStatus? status,
    List<AchievementListItemUi>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AchievementsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AchievementsState &&
      other.status == status &&
      listEquals(other.items, items) &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(status, Object.hashAll(items), errorMessage);
}

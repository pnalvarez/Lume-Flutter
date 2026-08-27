import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';

enum ProfileStatus { loading, ready, error }

enum ProfileDestination { login, settings }

@immutable
final class ProfileStatTileUi {
  const ProfileStatTileUi({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  bool operator ==(Object other) =>
      other is ProfileStatTileUi &&
      other.icon == icon &&
      other.label == label &&
      other.value == value;

  @override
  int get hashCode => Object.hash(icon, label, value);
}

@immutable
final class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.loading,
    this.displayName = profileLoadingNamePlaceholder,
    this.memberSince,
    this.playerLevel = 1,
    this.currentStreak = 0,
    this.xpInLevel = 0,
    this.xpForNextLevel = 100,
    this.daysInApp = 0,
    this.submodulesCompleted = 0,
    this.statTiles = loadingPlaceholderTiles,
    this.isSigningOut = false,
    this.errorMessage,
    this.destination,
  });

  final ProfileStatus status;
  final String displayName;
  final String? memberSince;
  final int playerLevel;
  final int currentStreak;
  final int xpInLevel;
  final int xpForNextLevel;
  final int daysInApp;
  final int submodulesCompleted;
  final List<ProfileStatTileUi> statTiles;
  final bool isSigningOut;
  final String? errorMessage;
  final ProfileDestination? destination;

  bool get isLoading => status == ProfileStatus.loading;

  static const loadingPlaceholderTiles = [
    ProfileStatTileUi(
      icon: Icons.star_outline_rounded,
      label: profileXpTotalLabel,
      value: '000',
    ),
    ProfileStatTileUi(
      icon: Icons.local_fire_department_outlined,
      label: profileSequenceLabel,
      value: '0d',
    ),
    ProfileStatTileUi(
      icon: Icons.bolt_rounded,
      label: profileXpTodayLabel,
      value: '000',
    ),
    ProfileStatTileUi(
      icon: Icons.bolt_rounded,
      label: profileXpWeekLabel,
      value: '000',
    ),
    ProfileStatTileUi(
      icon: Icons.emoji_events_outlined,
      label: profileBestStreakLabel,
      value: '0',
    ),
    ProfileStatTileUi(
      icon: Icons.military_tech_outlined,
      label: profileLevelLabel,
      value: '1',
    ),
  ];

  factory ProfileState.fromDomain(ProfileDomain profile) {
    return ProfileState(
      status: ProfileStatus.ready,
      displayName: _displayName(
        fullName: profile.fullName,
        email: profile.email,
      ),
      memberSince: profileFormatMemberSince(profile.trailStartedAt),
      playerLevel: profile.playerLevel,
      currentStreak: profile.currentStreak,
      xpInLevel: profile.xpInLevel,
      xpForNextLevel: profile.xpForNextLevel,
      daysInApp: profile.daysInApp,
      submodulesCompleted: profile.submodulesCompleted,
      statTiles: [
        ProfileStatTileUi(
          icon: Icons.star_outline_rounded,
          label: profileXpTotalLabel,
          value: '${profile.totalXp}',
        ),
        ProfileStatTileUi(
          icon: Icons.local_fire_department_outlined,
          label: profileSequenceLabel,
          value: profileSequenceTileValue(profile.currentStreak),
        ),
        ProfileStatTileUi(
          icon: Icons.bolt_rounded,
          label: profileXpTodayLabel,
          value: '${profile.xpToday}',
        ),
        ProfileStatTileUi(
          icon: Icons.bolt_rounded,
          label: profileXpWeekLabel,
          value: '${profile.xpWeek}',
        ),
        ProfileStatTileUi(
          icon: Icons.emoji_events_outlined,
          label: profileBestStreakLabel,
          value: '${profile.bestStreak}',
        ),
        ProfileStatTileUi(
          icon: Icons.military_tech_outlined,
          label: profileLevelLabel,
          value: '${profile.playerLevel}',
        ),
      ],
    );
  }

  ProfileState copyWith({
    ProfileStatus? status,
    String? displayName,
    String? memberSince,
    int? playerLevel,
    int? currentStreak,
    int? xpInLevel,
    int? xpForNextLevel,
    int? daysInApp,
    int? submodulesCompleted,
    List<ProfileStatTileUi>? statTiles,
    bool? isSigningOut,
    String? errorMessage,
    ProfileDestination? destination,
    bool clearError = false,
    bool clearMemberSince = false,
    bool clearDestination = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      displayName: displayName ?? this.displayName,
      memberSince: clearMemberSince ? null : memberSince ?? this.memberSince,
      playerLevel: playerLevel ?? this.playerLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      xpInLevel: xpInLevel ?? this.xpInLevel,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      daysInApp: daysInApp ?? this.daysInApp,
      submodulesCompleted: submodulesCompleted ?? this.submodulesCompleted,
      statTiles: statTiles ?? this.statTiles,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  static String _displayName({String? fullName, String? email}) {
    final fromName = fullName?.trim();
    if (fromName != null && fromName.isNotEmpty) return fromName;
    final fromEmail = email?.trim().split('@').firstOrNull;
    if (fromEmail != null && fromEmail.isNotEmpty) return fromEmail;
    return profileDisplayNameFallback;
  }

  @override
  bool operator ==(Object other) =>
      other is ProfileState &&
      other.status == status &&
      other.displayName == displayName &&
      other.memberSince == memberSince &&
      other.playerLevel == playerLevel &&
      other.currentStreak == currentStreak &&
      other.xpInLevel == xpInLevel &&
      other.xpForNextLevel == xpForNextLevel &&
      other.daysInApp == daysInApp &&
      other.submodulesCompleted == submodulesCompleted &&
      listEquals(other.statTiles, statTiles) &&
      other.isSigningOut == isSigningOut &&
      other.errorMessage == errorMessage &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    status,
    displayName,
    memberSince,
    playerLevel,
    currentStreak,
    xpInLevel,
    xpForNextLevel,
    daysInApp,
    submodulesCompleted,
    Object.hashAll(statTiles),
    isSigningOut,
    errorMessage,
    destination,
  );
}

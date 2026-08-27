import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';

void main() {
  test('fromDomain maps header, level card, and stat tiles', () {
    final state = ProfileState.fromDomain(
      ProfileDomain(
        id: 'user-1',
        email: 'ada@example.com',
        fullName: 'Ada Lovelace',
        trailStartedAt: DateTime(2026, 8, 1),
        playerLevel: 5,
        totalXp: 1240,
        xpInLevel: 140,
        xpForNextLevel: 300,
        currentStreak: 7,
        bestStreak: 12,
        xpToday: 40,
        xpWeek: 210,
        daysInApp: 21,
        submodulesCompleted: 6,
      ),
    );

    expect(state.status, ProfileStatus.ready);
    expect(state.isLoading, isFalse);
    expect(state.displayName, 'Ada Lovelace');
    expect(state.memberSince, 'agosto de 2026');
    expect(state.playerLevel, 5);
    expect(state.currentStreak, 7);
    expect(state.xpInLevel, 140);
    expect(state.xpForNextLevel, 300);
    expect(state.daysInApp, 21);
    expect(state.submodulesCompleted, 6);
    expect(state.statTiles, [
      const ProfileStatTileUi(
        icon: Icons.star_outline_rounded,
        label: profileXpTotalLabel,
        value: '1240',
      ),
      const ProfileStatTileUi(
        icon: Icons.local_fire_department_outlined,
        label: profileSequenceLabel,
        value: '7d',
      ),
      const ProfileStatTileUi(
        icon: Icons.bolt_rounded,
        label: profileXpTodayLabel,
        value: '40',
      ),
      const ProfileStatTileUi(
        icon: Icons.bolt_rounded,
        label: profileXpWeekLabel,
        value: '210',
      ),
      const ProfileStatTileUi(
        icon: Icons.emoji_events_outlined,
        label: profileBestStreakLabel,
        value: '12',
      ),
      const ProfileStatTileUi(
        icon: Icons.military_tech_outlined,
        label: profileLevelLabel,
        value: '5',
      ),
    ]);
  });

  test('falls back to email local-part when name is empty', () {
    final state = ProfileState.fromDomain(
      const ProfileDomain(id: 'user-1', email: 'explorer@lume.app'),
    );

    expect(state.displayName, 'explorer');
  });
}

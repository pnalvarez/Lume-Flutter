import 'package:flutter/material.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/presentation/screens/profile/profile_body.dart';
import 'package:lume/layers/presentation/screens/profile/profile_header.dart';
import 'package:lume/layers/presentation/screens/profile/profile_level_card.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noop() {}

ProfileState _readyState() {
  return ProfileState.fromDomain(
    ProfileDomain(
      id: '1',
      email: 'ada@lume.app',
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
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Ready',
  type: ProfileBody,
)
Widget profileBodyReady(BuildContext context) {
  return ProfileBody(
    state: _readyState(),
    onRetry: _noop,
    onSettingsPressed: _noop,
    onSignOutPressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Loading',
  type: ProfileBody,
)
Widget profileBodyLoading(BuildContext context) {
  return ProfileBody(
    state: const ProfileState(),
    onRetry: _noop,
    onSettingsPressed: _noop,
    onSignOutPressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Error',
  type: ProfileBody,
)
Widget profileBodyError(BuildContext context) {
  return ProfileBody(
    state: const ProfileState(
      status: ProfileStatus.error,
      errorMessage: profileLoadError,
    ),
    onRetry: _noop,
    onSettingsPressed: _noop,
    onSignOutPressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Default',
  type: ProfileHeader,
)
Widget profileHeaderDefault(BuildContext context) {
  final name = context.knobs.string(
    label: 'Name',
    initialValue: 'pedronalvarez',
  );
  final memberSince = context.knobs.stringOrNull(
    label: 'Member since',
    initialValue: null,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      child: ProfileHeader(
        displayName: name,
        memberSince: memberSince,
        onSettingsPressed: _noop,
        onSignOutPressed: _noop,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'With membership date',
  type: ProfileHeader,
)
Widget profileHeaderWithMembership(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      child: ProfileHeader(
        displayName: 'Ada Lovelace',
        memberSince: 'agosto de 2026',
        onSettingsPressed: _noop,
        onSignOutPressed: _noop,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Loading',
  type: ProfileHeader,
)
Widget profileHeaderLoading(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      child: ProfileHeader(
        displayName: 'Ada Lovelace',
        memberSince: 'agosto de 2026',
        isLoading: true,
        onSettingsPressed: _noop,
        onSignOutPressed: _noop,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Default',
  type: ProfileLevelCard,
)
Widget profileLevelCardDefault(BuildContext context) {
  final level = context.knobs.int.slider(
    label: 'Level',
    initialValue: 3,
    min: 1,
    max: 50,
  );
  final streak = context.knobs.int.slider(
    label: 'Streak',
    initialValue: 0,
    min: 0,
    max: 100,
  );
  final xpIn = context.knobs.int.slider(
    label: 'XP in level',
    initialValue: 91,
    min: 0,
    max: 500,
  );
  final xpFor = context.knobs.int.slider(
    label: 'XP for next',
    initialValue: 200,
    min: 1,
    max: 500,
  );
  final daysInApp = context.knobs.int.slider(
    label: 'Days in app',
    initialValue: 0,
    min: 0,
    max: 365,
  );
  final submodules = context.knobs.int.slider(
    label: 'Submodules',
    initialValue: 0,
    max: 48,
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      child: ProfileLevelCard(
        playerLevel: level,
        currentStreak: streak,
        xpInLevel: xpIn,
        xpForNextLevel: xpFor,
        daysInApp: daysInApp,
        submodulesCompleted: submodules,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Active streak',
  type: ProfileLevelCard,
)
Widget profileLevelCardActiveStreak(BuildContext context) {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(AppSpacings.xl2),
      child: ProfileLevelCard(
        playerLevel: 5,
        currentStreak: 7,
        xpInLevel: 140,
        xpForNextLevel: 300,
        daysInApp: 21,
        submodulesCompleted: 6,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Profile',
  name: 'Loading',
  type: ProfileLevelCard,
)
Widget profileLevelCardLoading(BuildContext context) {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(AppSpacings.xl2),
      child: ProfileLevelCard(
        playerLevel: 5,
        currentStreak: 7,
        xpInLevel: 140,
        xpForNextLevel: 300,
        daysInApp: 21,
        submodulesCompleted: 6,
        isLoading: true,
      ),
    ),
  );
}

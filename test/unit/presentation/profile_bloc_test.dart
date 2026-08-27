import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/profile/profile_bloc.dart';
import 'package:lume/layers/presentation/screens/profile/profile_event.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';

class _GetProfile implements IGetProfile {
  ProfileDomain result = const ProfileDomain(
    id: 'user-1',
    email: 'ada@example.com',
    fullName: 'Ada Lovelace',
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
  );
  Object? error;
  bool? lastForceRefresh;

  @override
  Future<ProfileDomain> call({bool forceRefresh = false}) async {
    lastForceRefresh = forceRefresh;
    if (error != null) throw error!;
    return result;
  }
}

class _SignOut implements ISignOut {
  var calls = 0;
  Object? error;

  @override
  Future<void> call() async {
    calls += 1;
    if (error != null) throw error!;
  }
}

void main() {
  late _GetProfile getProfile;
  late _SignOut signOut;

  setUp(() {
    getProfile = _GetProfile();
    signOut = _SignOut();
  });

  ProfileBloc buildBloc() => ProfileBloc(getProfile, signOut);

  blocTest<ProfileBloc, ProfileState>(
    'loads profile stats into ready state',
    build: buildBloc,
    act: (bloc) => bloc.add(const ProfileStarted()),
    expect: () => [
      isA<ProfileState>().having(
        (s) => s.status,
        'status',
        ProfileStatus.loading,
      ),
      isA<ProfileState>()
          .having((s) => s.status, 'status', ProfileStatus.ready)
          .having((s) => s.displayName, 'displayName', 'Ada Lovelace')
          .having((s) => s.playerLevel, 'playerLevel', 5)
          .having((s) => s.currentStreak, 'currentStreak', 7)
          .having((s) => s.statTiles, 'statTiles', hasLength(6))
          .having((s) => s.statTiles[0].value, 'xp total', '1240')
          .having((s) => s.statTiles[2].value, 'xp today', '40')
          .having((s) => s.statTiles[3].value, 'xp week', '210')
          .having((s) => s.statTiles[5].value, 'level', '5'),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits error when load fails',
    build: () {
      getProfile.error = Exception('network');
      return buildBloc();
    },
    act: (bloc) => bloc.add(const ProfileStarted()),
    expect: () => [
      isA<ProfileState>().having(
        (s) => s.status,
        'status',
        ProfileStatus.loading,
      ),
      isA<ProfileState>()
          .having((s) => s.status, 'status', ProfileStatus.error)
          .having((s) => s.errorMessage, 'error', profileLoadError),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'forwards forceRefresh on retry',
    build: buildBloc,
    act: (bloc) => bloc.add(const ProfileStarted(forceRefresh: true)),
    verify: (_) => expect(getProfile.lastForceRefresh, isTrue),
  );

  blocTest<ProfileBloc, ProfileState>(
    'settings opens category preferences',
    build: buildBloc,
    act: (bloc) => bloc.add(const ProfileSettingsPressed()),
    expect: () => [
      isA<ProfileState>().having(
        (s) => s.destination,
        'destination',
        ProfileDestination.settings,
      ),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'sign out goes to login',
    build: buildBloc,
    act: (bloc) => bloc.add(const ProfileSignOutPressed()),
    expect: () => [
      isA<ProfileState>().having((s) => s.isSigningOut, 'signingOut', isTrue),
      isA<ProfileState>()
          .having((s) => s.isSigningOut, 'signingOut', isFalse)
          .having(
            (s) => s.destination,
            'destination',
            ProfileDestination.login,
          ),
    ],
    verify: (_) => expect(signOut.calls, 1),
  );

  blocTest<ProfileBloc, ProfileState>(
    'clears destination after navigation is handled',
    build: buildBloc,
    seed: () => const ProfileState(destination: ProfileDestination.settings),
    act: (bloc) => bloc.add(const ProfileNavigationHandled()),
    expect: () => [
      isA<ProfileState>().having((s) => s.destination, 'destination', isNull),
    ],
  );
}

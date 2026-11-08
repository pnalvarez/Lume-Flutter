import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_event.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';

class _GetGameTrails implements IGetGameTrails {
  _GetGameTrails({this.trails = const [], this.error});

  List<GameTrailDomain> trails;
  Object? error;
  bool? lastForceRefresh;

  @override
  Future<List<GameTrailDomain>> call({bool forceRefresh = false}) async {
    lastForceRefresh = forceRefresh;
    if (error != null) throw error!;
    return trails;
  }
}

class _GetTrailProgress implements IGetTrailProgress {
  _GetTrailProgress({this.progress = const TrailProgressDomain(), this.error});

  TrailProgressDomain progress;
  Object? error;

  @override
  Future<TrailProgressDomain> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return progress;
  }
}

class _GetProfile implements IGetProfile {
  _GetProfile({this.profile, this.error});

  ProfileDomain? profile;
  Object? error;

  @override
  Future<ProfileDomain> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return profile ?? const ProfileDomain(id: 'user-1');
  }
}

const _quiz = LightningQuizGameDomain(
  pairId: 1,
  sortOrder: 1,
  prompt: 'q',
  options: ['a'],
  correctIndex: 0,
  explanation: '',
);

final _historyTrail = GameTrailDomain(
  id: 10,
  title: 'História do Brasil',
  sortOrder: 1,
  emoji: '📜',
  levels: [
    GameTrailLevelDomain(
      id: 100,
      title: 'Nível 1',
      sortOrder: 1,
      submodules: [
        GameTrailSubmoduleDomain(
          id: 1000,
          title: 'Independência',
          sortOrder: 1,
          games: const [_quiz],
        ),
        const GameTrailSubmoduleDomain(
          id: 1001,
          title: 'República',
          sortOrder: 2,
        ),
      ],
    ),
  ],
);

HomeBloc _bloc({
  IGetGameTrails? trails,
  IGetTrailProgress? progress,
  IGetProfile? profile,
}) {
  return HomeBloc(
    trails ?? _GetGameTrails(),
    progress ?? _GetTrailProgress(),
    profile ?? _GetProfile(),
    TrailProgressCalculator(),
  );
}

void main() {
  blocTest<HomeBloc, HomeState>(
    'maps returned trails to home cards with progress',
    build: () => _bloc(
      trails: _GetGameTrails(trails: [_historyTrail]),
      progress: _GetTrailProgress(
        progress: const TrailProgressDomain(
          pairProgress: [PairProgressDomain(pairId: 1, scorePct: 100)],
        ),
      ),
      profile: _GetProfile(
        profile: const ProfileDomain(
          id: 'user-1',
          fullName: 'Ada Lovelace',
          email: 'ada@example.com',
        ),
      ),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => [
      isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.ready)
          .having((s) => s.greetingName, 'greeting', 'Ada')
          .having((s) => s.trails, 'trails', hasLength(1))
          .having((s) => s.trails.single.trailId, 'trailId', 10)
          .having((s) => s.trails.single.title, 'title', 'História do Brasil')
          .having((s) => s.trails.single.emoji, 'emoji', '📜')
          .having((s) => s.trails.single.completedSubmodules, 'done', 1)
          .having((s) => s.trails.single.totalSubmodules, 'total', 2)
          .having((s) => s.trails.single.progressPercent, 'percent', 50),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'empty trail list yields ready state with no cards',
    build: _bloc,
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => [
      isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.ready)
          .having((s) => s.trails, 'trails', isEmpty),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'load error surfaces trail home error message',
    build: () => _bloc(trails: _GetGameTrails(error: Exception('network'))),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => [
      isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading),
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.error)
          .having((s) => s.errorMessage, 'error', trailHomeLoadError),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'falls back to email local-part when profile name is missing',
    build: () => _bloc(
      profile: _GetProfile(
        profile: const ProfileDomain(id: 'user-1', email: 'explorer@lume.app'),
      ),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    skip: 1,
    expect: () => [
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.ready)
          .having((s) => s.greetingName, 'greeting', 'explorer'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'profile failure still loads trails with greeting fallback',
    build: () => _bloc(
      trails: _GetGameTrails(trails: [_historyTrail]),
      profile: _GetProfile(error: Exception('profile down')),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    skip: 1,
    expect: () => [
      isA<HomeState>()
          .having((s) => s.status, 'status', HomeStatus.ready)
          .having((s) => s.greetingName, 'greeting', trailHomeGreetingFallback)
          .having((s) => s.trails, 'trails', hasLength(1)),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'trail press selects id and navigation handled clears it',
    build: _bloc,
    act: (bloc) {
      bloc
        ..add(const HomeTrailPressed(42))
        ..add(const HomeNavigationHandled());
    },
    expect: () => [
      isA<HomeState>().having((s) => s.selectedTrailId, 'selected', 42),
      isA<HomeState>().having((s) => s.selectedTrailId, 'selected', isNull),
    ],
  );

  test('forwards forceRefresh to getGameTrails', () async {
    final trails = _GetGameTrails();
    final bloc = _bloc(trails: trails);
    bloc.add(const HomeStarted(forceRefresh: true));
    await bloc.stream.firstWhere((s) => s.status == HomeStatus.ready);
    expect(trails.lastForceRefresh, isTrue);
    await bloc.close();
  });
}

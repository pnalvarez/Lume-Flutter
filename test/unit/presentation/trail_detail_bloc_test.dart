import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_event.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';

class _GetGameTrails implements IGetGameTrails {
  _GetGameTrails({this.trails = const [], this.error});

  List<GameTrailDomain> trails;
  Object? error;

  @override
  Future<List<GameTrailDomain>> call({bool forceRefresh = false}) async {
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

const _quizA = LightningQuizGameDomain(
  pairId: 1,
  sortOrder: 1,
  prompt: 'q',
  options: ['a'],
  correctIndex: 0,
  explanation: '',
);

const _quizB = LightningQuizGameDomain(
  pairId: 2,
  sortOrder: 2,
  prompt: 'q2',
  options: ['a'],
  correctIndex: 0,
  explanation: '',
);

final _trail = GameTrailDomain(
  id: 7,
  title: 'Idade Média',
  sortOrder: 1,
  emoji: '🏰',
  levels: [
    GameTrailLevelDomain(
      id: 70,
      title: 'Nível 1',
      sortOrder: 1,
      submodules: [
        GameTrailSubmoduleDomain(
          id: 700,
          title: 'Feudalismo',
          sortOrder: 1,
          games: const [_quizA, _quizB],
        ),
        const GameTrailSubmoduleDomain(
          id: 701,
          title: 'Cruzadas',
          sortOrder: 2,
        ),
      ],
    ),
  ],
);

TrailDetailBloc _bloc({IGetGameTrails? trails, IGetTrailProgress? progress}) {
  return TrailDetailBloc(
    trails ?? _GetGameTrails(trails: [_trail]),
    progress ?? _GetTrailProgress(),
    TrailProgressCalculator(),
  );
}

void main() {
  blocTest<TrailDetailBloc, TrailDetailState>(
    'loads trail detail when the trail id is found',
    build: _bloc,
    act: (bloc) => bloc.add(const TrailDetailStarted(trailId: 7)),
    expect: () => [
      isA<TrailDetailState>()
          .having((s) => s.status, 'status', TrailDetailStatus.loading)
          .having((s) => s.trailId, 'trailId', 7),
      isA<TrailDetailState>()
          .having((s) => s.status, 'status', TrailDetailStatus.ready)
          .having((s) => s.trailId, 'trailId', 7)
          .having((s) => s.title, 'title', 'Idade Média')
          .having((s) => s.emoji, 'emoji', '🏰')
          .having((s) => s.levels, 'levels', hasLength(1))
          .having((s) => s.levels.single.submodules, 'subs', hasLength(2))
          .having(
            (s) => s.levels.single.submodules.first.isLocked,
            'first locked',
            isFalse,
          )
          .having(
            (s) => s.levels.single.submodules.last.isLocked,
            'second locked',
            isTrue,
          ),
    ],
  );

  blocTest<TrailDetailBloc, TrailDetailState>(
    'hidden or missing trail id emits trail detail load error',
    build: () => _bloc(trails: _GetGameTrails(trails: [_trail])),
    act: (bloc) => bloc.add(const TrailDetailStarted(trailId: 999)),
    expect: () => [
      isA<TrailDetailState>().having(
        (s) => s.status,
        'status',
        TrailDetailStatus.loading,
      ),
      isA<TrailDetailState>()
          .having((s) => s.status, 'status', TrailDetailStatus.error)
          .having((s) => s.trailId, 'trailId', 999)
          .having((s) => s.errorMessage, 'error', trailDetailLoadError),
    ],
  );

  blocTest<TrailDetailBloc, TrailDetailState>(
    'fetch failure emits trail detail load error',
    build: () => _bloc(trails: _GetGameTrails(error: Exception('network'))),
    act: (bloc) => bloc.add(const TrailDetailStarted(trailId: 7)),
    expect: () => [
      isA<TrailDetailState>().having(
        (s) => s.status,
        'status',
        TrailDetailStatus.loading,
      ),
      isA<TrailDetailState>()
          .having((s) => s.status, 'status', TrailDetailStatus.error)
          .having((s) => s.errorMessage, 'error', trailDetailLoadError),
    ],
  );

  blocTest<TrailDetailBloc, TrailDetailState>(
    'empty emoji falls back to home emoji placeholder',
    build: () => _bloc(
      trails: _GetGameTrails(
        trails: [
          GameTrailDomain(
            id: 7,
            title: 'Sem emoji',
            sortOrder: 1,
            emoji: '   ',
            levels: _trail.levels,
          ),
        ],
      ),
    ),
    act: (bloc) => bloc.add(const TrailDetailStarted(trailId: 7)),
    skip: 1,
    expect: () => [
      isA<TrailDetailState>()
          .having((s) => s.status, 'status', TrailDetailStatus.ready)
          .having((s) => s.emoji, 'emoji', trailHomeEmojiFallback),
    ],
  );

  blocTest<TrailDetailBloc, TrailDetailState>(
    'ignores presses on locked submodules',
    build: _bloc,
    seed: () => TrailDetailState(
      status: TrailDetailStatus.ready,
      trailId: 7,
      levels: [
        TrailDetailLevelUi(
          title: 'Nível 1',
          submodules: [
            const TrailDetailSubmoduleRowUi(
              id: 700,
              title: 'Feudalismo',
              gamesCount: 2,
              isCompleted: false,
            ),
            const TrailDetailSubmoduleRowUi(
              id: 701,
              title: 'Cruzadas',
              gamesCount: 0,
              isCompleted: false,
              isLocked: true,
            ),
          ],
        ),
      ],
    ),
    act: (bloc) => bloc.add(const TrailDetailSubmodulePressed(701)),
    expect: () => <TrailDetailState>[],
  );

  blocTest<TrailDetailBloc, TrailDetailState>(
    'back press and navigation handled clear selection flags',
    build: _bloc,
    act: (bloc) {
      bloc
        ..add(const TrailDetailBackPressed())
        ..add(const TrailDetailNavigationHandled());
    },
    expect: () => [
      isA<TrailDetailState>().having((s) => s.goBack, 'goBack', isTrue),
      isA<TrailDetailState>()
          .having((s) => s.goBack, 'goBack', isFalse)
          .having((s) => s.selectedSubmoduleId, 'selected', isNull),
    ],
  );
}

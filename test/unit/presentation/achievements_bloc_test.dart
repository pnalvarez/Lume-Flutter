import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/models/achievement/achievement_icon.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_bloc.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';

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

void main() {
  late _GetAchievements getAchievements;

  setUp(() {
    getAchievements = _GetAchievements();
  });

  AchievementsBloc buildBloc() => AchievementsBloc(getAchievements);

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
          .having((s) => s.errorMessage, 'error', achievementsLoadError),
    ],
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/core/remote_config/remote_config_keys.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/get_knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/knowledge_gallery_match.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';
import 'package:lume/layers/presentation/screens/games/arcade_round_draw.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

class _GetHubGames implements IGetHubGames {
  List<HubGameDomain> result = const [
    HubGameDomain(
      id: '1',
      slug: 'quiz_relampago',
      name: 'Quiz Relâmpago',
      description: 'Rápido',
      icon: 'Zap',
      colorHex: '#F5A623',
      hubSection: HubSection.general,
      orderIndex: 1,
    ),
    HubGameDomain(
      id: '2',
      slug: 'giro_pelo_mundo',
      name: 'Giro pelo Mundo',
      description: 'Visual',
      icon: 'Globe',
      colorHex: '#7BC8A4',
      hubSection: HubSection.visual,
      orderIndex: 100,
    ),
  ];
  Object? error;

  @override
  Future<List<HubGameDomain>> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return result;
  }
}

class _GetGameRound implements IGetGameRound {
  HubGameRoundDomain? result;
  Object? error;
  final slugs = <String>[];

  @override
  Future<HubGameRoundDomain> call({
    required String gameSlug,
    int limit = 5,
  }) async {
    if (error != null) throw error!;
    slugs.add(gameSlug);
    return result ??
        HubGameRoundDomain(
          gameSlug: gameSlug,
          gameName: 'Quiz',
          games: const [
            LightningQuizGameDomain(
              pairId: 1,
              sortOrder: 1,
              prompt: 'Q?',
              options: ['A', 'B'],
              correctIndex: 0,
              explanation: 'Because',
            ),
          ],
        );
  }
}

class _GetArcadeRecord implements IGetArcadeRecord {
  int bestRounds = 0;
  Object? error;

  @override
  Future<ArcadeRecordDomain> call() async {
    if (error != null) throw error!;
    return ArcadeRecordDomain(bestRounds: bestRounds);
  }
}

class _GetRandomGameRound implements IGetRandomGameRound {
  TrailGameDomain? result = const LightningQuizGameDomain(
    pairId: 42,
    sortOrder: 1,
    prompt: 'Random?',
    options: ['A', 'B'],
    correctIndex: 0,
    explanation: 'Because',
  );
  Object? error;
  final enabledSlugs = <List<String>>[];

  @override
  Future<TrailGameDomain?> call({required List<String> enabledSlugs}) async {
    this.enabledSlugs.add(enabledSlugs);
    if (error != null) throw error!;
    return result;
  }
}

class _StartGameMatch implements IStartGameMatch {
  String matchId = 'match-1';
  final slugs = <String>[];
  Object? error;

  @override
  Future<String> call({required String gameSlug}) async {
    if (error != null) throw error!;
    slugs.add(gameSlug);
    return matchId;
  }
}

const _galleryRound = KnowledgeGalleryRound(
  questionId: 9,
  prompt: 'A qual movimento esta pintura pertence?',
  imageUrl: 'https://cdn.example/art.jpg',
  questionType: 'movement',
  options: ['Impressionismo', 'Cubismo', 'Barroco', 'Romantismo'],
  correctAnswer: 'Impressionismo',
);

class _GetKnowledgeGalleryRound implements IGetKnowledgeGalleryRound {
  final counts = <int>[];
  List<KnowledgeGalleryRound> rounds = const [_galleryRound];
  Object? error;

  @override
  Future<List<KnowledgeGalleryRound>> call({
    int count = knowledgeGalleryRoundsPerMatch,
  }) async {
    if (error != null) throw error!;
    counts.add(count);
    return rounds;
  }
}

class _KnowledgeGalleryMatch implements IKnowledgeGalleryMatch {
  var starts = 0;
  String matchId = 'gallery-match';
  final finishes =
      <({String matchId, int score, int correctCount, int total})>[];

  @override
  Future<String> start() async {
    starts++;
    return matchId;
  }

  @override
  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = knowledgeGalleryRoundsPerMatch,
    int? durationSeconds,
  }) async {
    finishes.add((
      matchId: matchId,
      score: score,
      correctCount: correctCount,
      total: totalQuestions,
    ));
    return const FinishedGameMatchDomain();
  }
}

class _RemoteConfig implements IRemoteConfig {
  bool arcade = true;
  bool achievements = false;
  Set<String> slugs = RemoteConfigDefaults.enabledGameSlugsDefault;

  @override
  bool get arcadeEnabled => arcade;

  @override
  bool get achievementsEnabled => achievements;

  @override
  String get achievementsFilterLayout => 'chips';

  @override
  Set<String> get enabledGameSlugs => slugs;

  @override
  Map<String, Object> get debugOverrides => const {};

  @override
  bool getBool(String key, {required bool defaultValue}) {
    if (key == RemoteConfigKeys.arcadeEnabled) return arcade;
    if (key == RemoteConfigKeys.achievementsEnabled) return achievements;
    return defaultValue;
  }

  @override
  String getString(String key, {required String defaultValue}) => defaultValue;

  @override
  Future<void> refresh() async {}

  @override
  Future<void> syncAccountId(String? accountId) async {}

  @override
  void setDebugOverride(String key, Object? value) {}
}

class _Analytics implements IAnalytics {
  final List<String> events = [];

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    events.add(name);
  }

  @override
  Future<void> setUserId(String? userId) async {}
}

void main() {
  late _GetHubGames getHubGames;
  late _GetGameRound getGameRound;
  late _GetArcadeRecord getArcadeRecord;
  late _GetRandomGameRound getRandomGameRound;
  late _StartGameMatch startGameMatch;
  late _GetKnowledgeGalleryRound getGallery;
  late _KnowledgeGalleryMatch galleryMatch;
  late _RemoteConfig remoteConfig;
  late _Analytics analytics;

  setUp(() {
    getHubGames = _GetHubGames();
    getGameRound = _GetGameRound();
    getArcadeRecord = _GetArcadeRecord();
    getRandomGameRound = _GetRandomGameRound();
    startGameMatch = _StartGameMatch();
    getGallery = _GetKnowledgeGalleryRound();
    galleryMatch = _KnowledgeGalleryMatch();
    remoteConfig = _RemoteConfig();
    analytics = _Analytics();
  });

  GamesHubBloc buildBloc() => GamesHubBloc(
    getHubGames,
    getGameRound,
    getArcadeRecord,
    DrawArcadeRound(getRandomGameRound, getGallery),
    startGameMatch,
    remoteConfig,
    analytics,
    getGallery,
    galleryMatch,
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'loads hub games into general and visual sections',
    build: () {
      remoteConfig.slugs = const {'quiz_relampago', 'giro_pelo_mundo'};
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true, showArcade: true),
      isA<GamesHubState>()
          .having((s) => s.isInitialLoading, 'isInitialLoading', isFalse)
          .having((s) => s.generalGames, 'general', hasLength(1))
          .having((s) => s.visualGames, 'visual', hasLength(1))
          .having((s) => s.showArcade, 'showArcade', isTrue),
    ],
    verify: (_) {
      expect(analytics.events, contains(AnalyticsEvents.arcadeCtaImpression));
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'omits hub games whose slug is outside the allowlist',
    build: () {
      remoteConfig.slugs = const {'quiz_relampago'};
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true, showArcade: true),
      isA<GamesHubState>()
          .having((s) => s.generalGames, 'general', hasLength(1))
          .having((s) => s.visualGames, 'visual', isEmpty),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'hides arcade when Remote Config disables it',
    build: () {
      remoteConfig.arcade = false;
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true, showArcade: false),
      isA<GamesHubState>()
          .having((s) => s.isInitialLoading, 'isInitialLoading', isFalse)
          .having((s) => s.showArcade, 'showArcade', isFalse),
    ],
    verify: (_) {
      expect(
        analytics.events,
        isNot(contains(AnalyticsEvents.arcadeCtaImpression)),
      );
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'emits error when load fails',
    build: () {
      getHubGames.error = Exception('boom');
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true, showArcade: true),
      const GamesHubState(
        isInitialLoading: false,
        initialErrorMessage: gamesHubLoadError,
        showArcade: true,
      ),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'fetches round and opens play when game is pressed',
    build: buildBloc,
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) => bloc.add(const GamesHubGamePressed('quiz_relampago')),
    expect: () => [
      const GamesHubState(isInitialLoading: false, isLoadingGame: true),
      isA<GamesHubState>()
          .having((s) => s.isLoadingGame, 'isLoadingGame', isFalse)
          .having((s) => s.openPlayRounds, 'openPlayRounds', isNotNull)
          .having((s) => s.openPlayRounds, 'round count', hasLength(1))
          .having((s) => s.openMatchId, 'openMatchId', 'match-1')
          .having((s) => s.openGameSlug, 'openGameSlug', 'quiz_relampago'),
    ],
    verify: (_) {
      expect(startGameMatch.slugs, ['quiz_relampago']);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'does not fetch a hub round for a slug outside the allowlist',
    build: () {
      remoteConfig.slugs = const {'quiz_relampago'};
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) => bloc.add(const GamesHubGamePressed('giro_pelo_mundo')),
    expect: () => [
      const GamesHubState(isInitialLoading: false, isLoadingGame: true),
      const GamesHubState(
        isInitialLoading: false,
        gameRoundErrorMessage: gamesHubRoundEmpty,
      ),
    ],
    verify: (_) {
      expect(getGameRound.slugs, isEmpty);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'emits round error when fetch fails',
    build: () {
      getGameRound.error = Exception('boom');
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) => bloc.add(const GamesHubGamePressed('quiz_relampago')),
    expect: () => [
      const GamesHubState(isInitialLoading: false, isLoadingGame: true),
      const GamesHubState(
        isInitialLoading: false,
        gameRoundErrorMessage: gamesHubRoundLoadError,
      ),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'arcade press loads the record and the opening round',
    build: () {
      getArcadeRecord.bestRounds = 7;
      remoteConfig.slugs = const {'quiz_relampago'};
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false, showArcade: true),
    act: (bloc) => bloc.add(const GamesHubArcadePressed()),
    expect: () => [
      const GamesHubState(
        isInitialLoading: false,
        isLoadingGame: true,
        showArcade: true,
      ),
      isA<GamesHubState>()
          .having((s) => s.isLoadingGame, 'isLoadingGame', isFalse)
          .having((s) => s.arcadeRecord, 'arcadeRecord', 7)
          .having((s) => s.openArcadeRounds, 'openArcadeRounds', hasLength(1))
          .having((s) => s.openArcadeRounds!.first.id, 'first round id', '42'),
    ],
    verify: (_) {
      expect(analytics.events, contains(AnalyticsEvents.arcadeOpened));
      expect(getRandomGameRound.enabledSlugs.single.toSet(), {
        'quiz_relampago',
      });
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'arcade press surfaces an error when no game is available',
    build: () {
      getRandomGameRound.result = null;
      remoteConfig.slugs = const {};
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false, showArcade: true),
    act: (bloc) => bloc.add(const GamesHubArcadePressed()),
    expect: () => [
      const GamesHubState(
        isInitialLoading: false,
        isLoadingGame: true,
        showArcade: true,
      ),
      const GamesHubState(
        isInitialLoading: false,
        gameRoundErrorMessage: gamesHubRoundEmpty,
        showArcade: true,
      ),
    ],
    verify: (_) {
      expect(getRandomGameRound.enabledSlugs, [<String>[]]);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'hides the gallery tile when its slug is outside the allowlist',
    build: () {
      remoteConfig.slugs = const {'quiz_relampago'};
      getHubGames.result = [
        ...getHubGames.result,
        const HubGameDomain(
          id: '3',
          slug: knowledgeGalleryGameSlug,
          name: 'Galeria do Conhecimento',
          description: 'Visual',
          icon: 'Image',
          colorHex: '#7BC8A4',
          hubSection: HubSection.visual,
          orderIndex: 2,
        ),
      ];
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    verify: (bloc) {
      expect(
        bloc.state.games.map((game) => game.slug),
        isNot(contains(knowledgeGalleryGameSlug)),
      );
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'starts a five-question gallery match without get_game_round',
    build: () {
      remoteConfig.slugs = const {knowledgeGalleryGameSlug};
      getGallery.rounds = List.filled(5, _galleryRound);
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) =>
        bloc.add(const GamesHubGamePressed(knowledgeGalleryGameSlug)),
    verify: (bloc) {
      expect(getGallery.counts, [knowledgeGalleryRoundsPerMatch]);
      expect(getGameRound.slugs, isEmpty);
      expect(startGameMatch.slugs, isEmpty);
      expect(galleryMatch.starts, 1);
      expect(bloc.state.openPlayRounds, isNull);
      expect(bloc.state.openGalleryRounds, hasLength(5));
      expect(bloc.state.openMatchId, 'gallery-match');
      expect(bloc.state.openGameSlug, knowledgeGalleryGameSlug);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'does not load gallery rounds when the slug is outside the allowlist',
    build: () {
      remoteConfig.slugs = const {'quiz_relampago'};
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) =>
        bloc.add(const GamesHubGamePressed(knowledgeGalleryGameSlug)),
    verify: (_) {
      expect(getGallery.counts, isEmpty);
      expect(getGameRound.slugs, isEmpty);
      expect(galleryMatch.starts, 0);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'arcade can open a gallery question when the slug is allowlisted',
    build: () {
      remoteConfig.slugs = const {knowledgeGalleryGameSlug};
      getGallery.rounds = const [_galleryRound];
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false, showArcade: true),
    act: (bloc) => bloc.add(const GamesHubArcadePressed()),
    verify: (bloc) {
      expect(getGallery.counts, [1]);
      expect(getRandomGameRound.enabledSlugs, isEmpty);
      expect(bloc.state.openArcadeRounds, hasLength(1));
      expect(bloc.state.openArcadeRounds!.single.id, '9');
      expect(bloc.state.openArcadeRounds!.single.gallery, _galleryRound);
    },
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'arcade does not fall through to trail games when gallery has no items',
    build: () {
      remoteConfig.slugs = const {knowledgeGalleryGameSlug};
      getGallery.rounds = const [];
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false, showArcade: true),
    act: (bloc) => bloc.add(const GamesHubArcadePressed()),
    verify: (bloc) {
      expect(getRandomGameRound.enabledSlugs, isEmpty);
      expect(bloc.state.openArcadeRounds, isNull);
      expect(bloc.state.gameRoundErrorMessage, gamesHubRoundEmpty);
    },
  );
}

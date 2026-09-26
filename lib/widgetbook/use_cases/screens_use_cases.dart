import 'package:flutter/material.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_body.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_body.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_state.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_body.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_body.dart';
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_state.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_body.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_body.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_tab_placeholder.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_body.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_body.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_body.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_body.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_body.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noop() {}
void _noopString(String _) {}
void _noopInt(int _) {}

// --- Login ------------------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Login',
  name: 'Sign in',
  type: LoginBody,
)
Widget loginSignIn(BuildContext context) {
  return LoginBody(
    state: const LoginState(
      mode: LoginMode.login,
      email: 'demo@lume.app',
      password: 'secret1',
    ),
    onEmailChanged: _noopString,
    onPasswordChanged: _noopString,
    onSubmit: _noop,
    onForgotPassword: _noop,
    onToggleMode: _noop,
    onWhatIsLume: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Login',
  name: 'Sign up',
  type: LoginBody,
)
Widget loginSignUp(BuildContext context) {
  return LoginBody(
    state: const LoginState(mode: LoginMode.signup),
    onEmailChanged: _noopString,
    onPasswordChanged: _noopString,
    onSubmit: _noop,
    onForgotPassword: _noop,
    onToggleMode: _noop,
    onWhatIsLume: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Login',
  name: 'Submitting',
  type: LoginBody,
)
Widget loginSubmitting(BuildContext context) {
  return LoginBody(
    state: const LoginState(
      email: 'demo@lume.app',
      password: 'secret1',
      isSubmitting: true,
    ),
    onEmailChanged: _noopString,
    onPasswordChanged: _noopString,
    onSubmit: _noop,
    onForgotPassword: _noop,
    onToggleMode: _noop,
    onWhatIsLume: _noop,
  );
}

// --- Confirm email ----------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Confirm email',
  name: 'Default',
  type: ConfirmEmailBody,
)
Widget confirmEmailDefault(BuildContext context) {
  return ConfirmEmailBody(
    state: const ConfirmEmailState(email: 'demo@lume.app'),
    onBack: _noop,
    onEmailChanged: _noopString,
    onResend: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Confirm email',
  name: 'Resending',
  type: ConfirmEmailBody,
)
Widget confirmEmailResending(BuildContext context) {
  return ConfirmEmailBody(
    state: const ConfirmEmailState(email: 'demo@lume.app', isSubmitting: true),
    onBack: _noop,
    onEmailChanged: _noopString,
    onResend: _noop,
  );
}

// --- Recover password -------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Recover password',
  name: 'Request form',
  type: RecoverPasswordBody,
)
Widget recoverPasswordForm(BuildContext context) {
  return RecoverPasswordBody(
    state: const RecoverPasswordState(email: 'demo@lume.app'),
    onBack: _noop,
    onEmailChanged: _noopString,
    onSubmit: _noop,
    onGoToLogin: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Recover password',
  name: 'Email sent',
  type: RecoverPasswordBody,
)
Widget recoverPasswordSent(BuildContext context) {
  return RecoverPasswordBody(
    state: const RecoverPasswordState(email: 'demo@lume.app', sent: true),
    onBack: _noop,
    onEmailChanged: _noopString,
    onSubmit: _noop,
    onGoToLogin: _noop,
  );
}

// --- Define password --------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Define password',
  name: 'Checking',
  type: DefinePasswordBody,
)
Widget definePasswordChecking(BuildContext context) {
  return DefinePasswordBody(
    state: const DefinePasswordState(status: DefinePasswordStatus.checking),
    onPasswordChanged: _noopString,
    onConfirmChanged: _noopString,
    onSubmit: _noop,
    onRequestNewLink: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Define password',
  name: 'Ready',
  type: DefinePasswordBody,
)
Widget definePasswordReady(BuildContext context) {
  return DefinePasswordBody(
    state: const DefinePasswordState(status: DefinePasswordStatus.ready),
    onPasswordChanged: _noopString,
    onConfirmChanged: _noopString,
    onSubmit: _noop,
    onRequestNewLink: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Define password',
  name: 'Invalid link',
  type: DefinePasswordBody,
)
Widget definePasswordInvalid(BuildContext context) {
  return DefinePasswordBody(
    state: const DefinePasswordState(status: DefinePasswordStatus.invalid),
    onPasswordChanged: _noopString,
    onConfirmChanged: _noopString,
    onSubmit: _noop,
    onRequestNewLink: _noop,
  );
}

// --- Onboarding -------------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Onboarding',
  name: 'Slide 1',
  type: OnboardingBody,
)
Widget onboardingSlide1(BuildContext context) {
  return const _OnboardingPreview(initialIndex: 0);
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Onboarding',
  name: 'Slide 2 (last)',
  type: OnboardingBody,
)
Widget onboardingSlide2(BuildContext context) {
  return const _OnboardingPreview(initialIndex: 1);
}

class _OnboardingPreview extends StatefulWidget {
  const _OnboardingPreview({required this.initialIndex});

  final int initialIndex;

  @override
  State<_OnboardingPreview> createState() => _OnboardingPreviewState();
}

class _OnboardingPreviewState extends State<_OnboardingPreview> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingBody(
      pageController: _controller,
      index: _index,
      isLast: _index >= 1,
      onSkip: _noop,
      onNext: () {
        if (_index < 1) {
          setState(() => _index = 1);
          _controller.animateToPage(
            1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      },
      onPageChanged: (index) => setState(() => _index = index),
    );
  }
}

// --- Personal info ----------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Personal info',
  name: 'Default',
  type: PersonalInfoBody,
)
Widget personalInfoDefault(BuildContext context) {
  return PersonalInfoBody(
    state: const PersonalInfoState(
      firstName: 'Ada',
      lastName: 'Lovelace',
      age: '28',
    ),
    onFirstNameChanged: _noopString,
    onLastNameChanged: _noopString,
    onAgeChanged: _noopString,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Personal info',
  name: 'Submitting',
  type: PersonalInfoBody,
)
Widget personalInfoSubmitting(BuildContext context) {
  return PersonalInfoBody(
    state: const PersonalInfoState(
      firstName: 'Ada',
      lastName: 'Lovelace',
      age: '28',
      isSubmitting: true,
    ),
    onFirstNameChanged: _noopString,
    onLastNameChanged: _noopString,
    onAgeChanged: _noopString,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Personal info',
  name: 'Empty',
  type: PersonalInfoBody,
)
Widget personalInfoEmpty(BuildContext context) {
  return PersonalInfoBody(
    state: const PersonalInfoState(),
    onFirstNameChanged: _noopString,
    onLastNameChanged: _noopString,
    onAgeChanged: _noopString,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Personal info',
  name: 'Settings prefilled',
  type: PersonalInfoBody,
)
Widget personalInfoSettingsPrefilled(BuildContext context) {
  return PersonalInfoBody(
    state: const PersonalInfoState(
      entry: PersonalInfoEntry.settings,
      firstName: 'Ada',
      lastName: 'Lovelace',
      age: '28',
    ),
    onBack: _noop,
    onFirstNameChanged: _noopString,
    onLastNameChanged: _noopString,
    onAgeChanged: _noopString,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Personal info',
  name: 'Settings loading',
  type: PersonalInfoBody,
)
Widget personalInfoSettingsLoading(BuildContext context) {
  return PersonalInfoBody(
    state: const PersonalInfoState(
      entry: PersonalInfoEntry.settings,
      status: PersonalInfoStatus.loading,
    ),
    onBack: _noop,
    onFirstNameChanged: _noopString,
    onLastNameChanged: _noopString,
    onAgeChanged: _noopString,
    onSubmit: _noop,
  );
}

// --- Select category --------------------------------------------------------

const _sampleCategories = [
  CategoryDomain(id: 1, name: 'História'),
  CategoryDomain(id: 2, name: 'Filosofia'),
  CategoryDomain(id: 3, name: 'Arte'),
  CategoryDomain(id: 4, name: 'Ciência'),
  CategoryDomain(id: 5, name: 'Música'),
];

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Select category',
  name: 'Onboarding ready',
  type: SelectCategoryBody,
)
Widget selectCategoryOnboardingReady(BuildContext context) {
  return SelectCategoryBody(
    state: SelectCategoryState(
      entry: SelectCategoryEntry.onboarding,
      status: SelectCategoryStatus.ready,
      categories: _sampleCategories,
      selectedIds: {1, 3},
    ),
    onRetry: _noop,
    onToggle: _noopInt,
    onSelectAllToggled: _noop,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Select category',
  name: 'Profile ready',
  type: SelectCategoryBody,
)
Widget selectCategoryProfileReady(BuildContext context) {
  return SelectCategoryBody(
    state: SelectCategoryState(
      entry: SelectCategoryEntry.profile,
      status: SelectCategoryStatus.ready,
      categories: _sampleCategories,
      selectedIds: {1, 3},
    ),
    onRetry: _noop,
    onToggle: _noopInt,
    onSelectAllToggled: _noop,
    onSubmit: _noop,
    onBack: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Select category',
  name: 'Loading',
  type: SelectCategoryBody,
)
Widget selectCategoryLoading(BuildContext context) {
  return SelectCategoryBody(
    state: const SelectCategoryState(),
    onRetry: _noop,
    onToggle: _noopInt,
    onSelectAllToggled: _noop,
    onSubmit: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Select category',
  name: 'Profile loading',
  type: SelectCategoryBody,
)
Widget selectCategoryProfileLoading(BuildContext context) {
  return SelectCategoryBody(
    state: const SelectCategoryState(
      entry: SelectCategoryEntry.profile,
      status: SelectCategoryStatus.loading,
    ),
    onRetry: _noop,
    onToggle: _noopInt,
    onSelectAllToggled: _noop,
    onSubmit: _noop,
    onBack: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Select category',
  name: 'Error',
  type: SelectCategoryBody,
)
Widget selectCategoryError(BuildContext context) {
  return SelectCategoryBody(
    state: const SelectCategoryState(
      status: SelectCategoryStatus.error,
      errorMessage: selectCategoryLoadError,
    ),
    onRetry: _noop,
    onToggle: _noopInt,
    onSelectAllToggled: _noop,
    onSubmit: _noop,
  );
}

// --- Dashboard --------------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Dashboard',
  name: 'Shell with Trilha',
  type: DashboardBody,
)
Widget dashboardShellTrail(BuildContext context) {
  final showAchievements = context.knobs.boolean(
    label: 'Show Achievements',
    initialValue: false,
  );
  final titles = [
    dashboardTabTrail,
    dashboardTabGames,
    if (showAchievements) dashboardTabAchievements,
    dashboardTabProfile,
  ];
  final selected = context.knobs.int.slider(
    label: 'Tab',
    initialValue: 0,
    min: 0,
    max: titles.length - 1,
  );
  return DashboardBody(
    selectedIndex: selected,
    onTabSelected: _noopInt,
    showAchievements: showAchievements,
    child: DashboardTabPlaceholder(
      title: titles[selected],
      isSigningOut: false,
      onSignOut: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Dashboard',
  name: 'Tab placeholder',
  type: DashboardTabPlaceholder,
)
Widget dashboardTabPlaceholder(BuildContext context) {
  return DashboardTabPlaceholder(
    title: context.knobs.string(
      label: 'Title',
      initialValue: dashboardTabTrail,
    ),
    isSigningOut: context.knobs.boolean(label: 'Signing out'),
    onSignOut: _noop,
  );
}

// --- Achievements -----------------------------------------------------------

const _sampleAchievements = [
  AchievementListItemUi(
    id: '1',
    title: 'Arcade 50',
    description: 'Alcance 50 pontos em uma partida no Arcade.',
    status: AchievementListItemStatus.locked,
    progress: 0,
    target: 50,
  ),
  AchievementListItemUi(
    id: '2',
    title: 'Explorador',
    description: 'Complete 5 submódulos na trilha.',
    status: AchievementListItemStatus.inProgress,
    progress: 3,
    target: 5,
  ),
  AchievementListItemUi(
    id: '3',
    title: 'Primeiro passo',
    description: 'Complete 1 submódulo na trilha.',
    status: AchievementListItemStatus.completed,
    progress: 1,
    target: 1,
    icon: Icons.explore_rounded,
  ),
];

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Ready',
  type: AchievementsBody,
)
Widget achievementsReady(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.ready,
      items: _sampleAchievements,
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Filters — completed + locked',
  type: AchievementsBody,
)
Widget achievementsFiltersMulti(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.ready,
      items: _sampleAchievements,
      selectedStatusFilters: {
        AchievementListItemStatus.completed,
        AchievementListItemStatus.locked,
      },
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Filters — empty match',
  type: AchievementsBody,
)
Widget achievementsFiltersEmpty(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.ready,
      items: [
        AchievementListItemUi(
          id: '1',
          title: 'Arcade 50',
          description: 'Alcance 50 pontos em uma partida no Arcade.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 50,
        ),
        AchievementListItemUi(
          id: '2',
          title: 'Explorador',
          description: 'Complete 5 submódulos na trilha.',
          status: AchievementListItemStatus.inProgress,
          progress: 3,
          target: 5,
        ),
      ],
      selectedStatusFilters: {AchievementListItemStatus.completed},
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Filters — empty match + inline error',
  type: AchievementsBody,
)
Widget achievementsFiltersEmptyWithError(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.ready,
      items: [
        AchievementListItemUi(
          id: '1',
          title: 'Arcade 50',
          description: 'Alcance 50 pontos em uma partida no Arcade.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 50,
        ),
      ],
      selectedStatusFilters: {AchievementListItemStatus.completed},
      errorMessage: achievementsLoadError,
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Loading',
  type: AchievementsBody,
)
Widget achievementsLoading(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(),
    onRetry: _noop,
    onFilterToggled: (_) {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Empty',
  type: AchievementsBody,
)
Widget achievementsEmpty(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(status: AchievementsStatus.ready),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Error',
  type: AchievementsBody,
)
Widget achievementsError(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.error,
      errorMessage: achievementsLoadError,
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Achievements',
  name: 'Inline error',
  type: AchievementsBody,
)
Widget achievementsInlineError(BuildContext context) {
  return AchievementsBody(
    state: const AchievementsState(
      status: AchievementsStatus.ready,
      items: _sampleAchievements,
      errorMessage: achievementsLoadError,
    ),
    onRetry: _noop,
    onFilterToggled: (_) {},
    onRefresh: () async {},
  );
}

// --- Trail home -------------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Home',
  name: 'Ready',
  type: HomeBody,
)
Widget trailHomeReady(BuildContext context) {
  return HomeBody(
    state: const HomeState(
      status: HomeStatus.ready,
      greetingName: 'Pedro',
      trails: [
        HomeTrailCardUi(
          trailId: 1,
          title: 'História do Brasil',
          emoji: '🇧🇷',
          completedSubmodules: 2,
          totalSubmodules: 8,
          progressPercent: 25,
        ),
      ],
    ),
    onRetry: _noop,
    onTrailPressed: _noopInt,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Home',
  name: 'Loading',
  type: HomeBody,
)
Widget trailHomeLoading(BuildContext context) {
  return HomeBody(
    state: const HomeState(),
    onRetry: _noop,
    onTrailPressed: _noopInt,
  );
}

// --- Games hub --------------------------------------------------------------

const _sampleHubGames = [
  GamesHubCardUi(
    id: '1',
    slug: 'quiz_relampago',
    title: 'Quiz Relâmpago',
    description: 'Perguntas rápidas de todas as trilhas',
    colorHex: '#F5A623',
    hubSection: HubSection.general,
  ),
  GamesHubCardUi(
    id: '2',
    slug: 'verdade_ou_mito',
    title: 'Verdade ou Mito',
    description: 'Acerte mitos populares em segundos',
    colorHex: '#22C55E',
    hubSection: HubSection.general,
  ),
  GamesHubCardUi(
    id: '3',
    slug: 'giro_pelo_mundo',
    title: 'Giro pelo Mundo',
    description: 'Explore o planeta, um desafio por vez',
    colorHex: '#7BC8A4',
    hubSection: HubSection.visual,
  ),
  GamesHubCardUi(
    id: '4',
    slug: 'galeria_conhecimento',
    title: 'Galeria do Conhecimento',
    description: 'Descubra as obras que moldaram o mundo',
    colorHex: '#C4A6D6',
    hubSection: HubSection.visual,
  ),
];

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Ready',
  type: GamesHubBody,
)
Widget gamesHubReady(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(isInitialLoading: false, games: _sampleHubGames),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Arcade hidden',
  type: GamesHubBody,
)
Widget gamesHubArcadeHidden(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(
      isInitialLoading: false,
      games: _sampleHubGames,
      showArcade: false,
    ),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Loading',
  type: GamesHubBody,
)
Widget gamesHubLoading(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Error',
  type: GamesHubBody,
)
Widget gamesHubError(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(
      isInitialLoading: false,
      initialErrorMessage: 'Não foi possível carregar os jogos.',
    ),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Empty',
  type: GamesHubBody,
)
Widget gamesHubEmpty(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(isInitialLoading: false),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games Hub',
  name: 'Fetching round',
  type: GamesHubBody,
)
Widget gamesHubFetchingRound(BuildContext context) {
  return GamesHubBody(
    state: const GamesHubState(isInitialLoading: false, games: _sampleHubGames),
    onRetry: _noop,
    onGamePressed: _noopString,
    onArcadePressed: _noop,
  );
}

// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:lume/widgetbook/use_cases/badges_use_cases.dart'
    as _lume_widgetbook_use_cases_badges_use_cases;
import 'package:lume/widgetbook/use_cases/button_use_cases.dart'
    as _lume_widgetbook_use_cases_button_use_cases;
import 'package:lume/widgetbook/use_cases/chips_and_progress_use_cases.dart'
    as _lume_widgetbook_use_cases_chips_and_progress_use_cases;
import 'package:lume/widgetbook/use_cases/colors_use_cases.dart'
    as _lume_widgetbook_use_cases_colors_use_cases;
import 'package:lume/widgetbook/use_cases/feedback_dialog_use_cases.dart'
    as _lume_widgetbook_use_cases_feedback_dialog_use_cases;
import 'package:lume/widgetbook/use_cases/game_use_cases.dart'
    as _lume_widgetbook_use_cases_game_use_cases;
import 'package:lume/widgetbook/use_cases/input_and_icon_button_use_cases.dart'
    as _lume_widgetbook_use_cases_input_and_icon_button_use_cases;
import 'package:lume/widgetbook/use_cases/navigation_use_cases.dart'
    as _lume_widgetbook_use_cases_navigation_use_cases;
import 'package:lume/widgetbook/use_cases/progress_bar_use_cases.dart'
    as _lume_widgetbook_use_cases_progress_bar_use_cases;
import 'package:lume/widgetbook/use_cases/screens_use_cases.dart'
    as _lume_widgetbook_use_cases_screens_use_cases;
import 'package:lume/widgetbook/use_cases/stat_chip_use_cases.dart'
    as _lume_widgetbook_use_cases_stat_chip_use_cases;
import 'package:lume/widgetbook/use_cases/tiles_and_loader_use_cases.dart'
    as _lume_widgetbook_use_cases_tiles_and_loader_use_cases;
import 'package:lume/widgetbook/use_cases/trail_screens_use_cases.dart'
    as _lume_widgetbook_use_cases_trail_screens_use_cases;
import 'package:lume/widgetbook/use_cases/trail_use_cases.dart'
    as _lume_widgetbook_use_cases_trail_use_cases;
import 'package:lume/widgetbook/use_cases/typography_use_cases.dart'
    as _lume_widgetbook_use_cases_typography_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Lume',
    children: [
      _widgetbook.WidgetbookCategory(
        name: 'Screens',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'Confirm email',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'ConfirmEmailBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .confirmEmailDefault,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Resending',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .confirmEmailResending,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Dashboard',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'DashboardBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Shell with Trilha',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .dashboardShellTrail,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'DashboardTabPlaceholder',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Tab placeholder',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .dashboardTabPlaceholder,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Define password',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'DefinePasswordBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Checking',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .definePasswordChecking,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Invalid link',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .definePasswordInvalid,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Ready',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .definePasswordReady,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Games]',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'Battle of Curiosities',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'BattleOfCuriositiesBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .battleIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Complete Sentence',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'CompleteSentenceBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .completeSentenceIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Connections',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'ConnectionsBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Playing',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .connectionsPlaying,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Lightning Quiz',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'LightningQuizBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Answered correct',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .lightningQuizCorrect,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .lightningQuizIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Mysterious Word',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'MysteriousWordBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Playing',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .mysteriousWordPlaying,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Shared',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'ChoiceGameBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Choice answered',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .choiceGameAnswered,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Choice idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .choiceGameIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Timeline',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'TimelineBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .timelineIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'True or Myth',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'TrueOrMythBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Idle',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .trueOrMythIdle,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'Who Am I',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'WhoAmIBody',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Answered',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .whoAmIAnswered,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Playing',
                        builder:
                            _lume_widgetbook_use_cases_trail_screens_use_cases
                                .whoAmIPlaying,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Login',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'LoginBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sign in',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .loginSignIn,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sign up',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .loginSignUp,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Submitting',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .loginSubmitting,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Onboarding',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'OnboardingBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Slide 1',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .onboardingSlide1,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Slide 2 (last)',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .onboardingSlide2,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Recover password',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'RecoverPasswordBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Email sent',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .recoverPasswordSent,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Request form',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .recoverPasswordForm,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Select category',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SelectCategoryBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Error',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .selectCategoryError,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .selectCategoryLoading,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Ready',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .selectCategoryReady,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Submodule Complete',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SubmoduleCompleteBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .submoduleCompleted,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Submodule Play',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SubmodulePlayBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Playing',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .submodulePlaying,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Submodule Preview',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SubmodulePreviewBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .submodulePreview,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Error',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .submodulePreviewError,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .submodulePreviewLoading,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Trail Detail',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'TrailDetailBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Error',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .trailDetailError,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .trailDetailLoading,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Ready',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .trailDetailReady,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'Trail Home',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'HomeBody',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Empty',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .trailHomeEmpty,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Error',
                    builder: _lume_widgetbook_use_cases_trail_screens_use_cases
                        .trailHomeError,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .trailHomeLoading,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Ready',
                    builder: _lume_widgetbook_use_cases_screens_use_cases
                        .trailHomeReady,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'molecules',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'badges',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AmountBadge',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_badges_use_cases
                    .amountBadgeInteractive,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'LumeBadge',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All variants',
                builder:
                    _lume_widgetbook_use_cases_badges_use_cases.lumeBadgeAll,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom colors',
                builder: _lume_widgetbook_use_cases_badges_use_cases
                    .lumeBadgeCustomColors,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'buttons',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'LumeButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All variants',
                builder: _lume_widgetbook_use_cases_button_use_cases
                    .buttonAllVariants,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder:
                    _lume_widgetbook_use_cases_button_use_cases.buttonDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Expanded',
                builder:
                    _lume_widgetbook_use_cases_button_use_cases.buttonExpanded,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_button_use_cases
                    .buttonInteractive,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Sizes',
                builder:
                    _lume_widgetbook_use_cases_button_use_cases.buttonSizes,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Success trait',
                builder: _lume_widgetbook_use_cases_button_use_cases
                    .buttonSuccessTrait,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With icons',
                builder:
                    _lume_widgetbook_use_cases_button_use_cases.buttonWithIcons,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'LumeIconButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All variants',
                builder:
                    _lume_widgetbook_use_cases_input_and_icon_button_use_cases
                        .iconButtonAll,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'chips',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'ChipPicker',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .chipPickerInteractive,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SelectableChip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Selected and unselected',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .selectableChipStates,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SelectableChipGroup',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Multi-select with select all',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .selectableChipGroupInteractive,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'StatChip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Showcase',
                builder: _lume_widgetbook_use_cases_stat_chip_use_cases
                    .statChipShowcase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'StatusChip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All states',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .statusChipAll,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'input_fields',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'InputField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _lume_widgetbook_use_cases_input_and_icon_button_use_cases
                        .inputFieldDefault,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'loaders',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'CircularLoader',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Sizes',
                builder: _lume_widgetbook_use_cases_tiles_and_loader_use_cases
                    .circularLoaderSizes,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'progress',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'LumeProgressBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_progress_bar_use_cases
                    .progressBarInteractive,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Multiple bars',
                builder: _lume_widgetbook_use_cases_progress_bar_use_cases
                    .progressBarMultiple,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With leading badge',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .progressBarWithLeading,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'StepProgressBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_chips_and_progress_use_cases
                    .stepProgressInteractive,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'tiles',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FeedbackTile',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All states',
                builder: _lume_widgetbook_use_cases_tiles_and_loader_use_cases
                    .feedbackTileAll,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'ScoreTile',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Showcase',
                builder: _lume_widgetbook_use_cases_tiles_and_loader_use_cases
                    .scoreTileShowcase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'organisms',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'dialogs',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'CelebrationDialog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Celebration',
                builder: _lume_widgetbook_use_cases_feedback_dialog_use_cases
                    .celebrationDialogDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Dialog tones',
                builder: _lume_widgetbook_use_cases_feedback_dialog_use_cases
                    .lumeDialogTones,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'feedback',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FloatingNotice',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Amount',
                builder: _lume_widgetbook_use_cases_feedback_dialog_use_cases
                    .floatingNoticeAmount,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'ResultBanner',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Tones',
                builder: _lume_widgetbook_use_cases_feedback_dialog_use_cases
                    .resultBannerTones,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'game',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'ChoiceGroup',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'States',
                builder:
                    _lume_widgetbook_use_cases_game_use_cases.choiceGroupStates,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'PromptCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _lume_widgetbook_use_cases_game_use_cases.promptCardDefault,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SessionTimer',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_game_use_cases
                    .sessionTimerInteractive,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'navigation',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'BottomNavBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _lume_widgetbook_use_cases_navigation_use_cases
                    .bottomNavInteractive,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'PageHeader',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _lume_widgetbook_use_cases_navigation_use_cases
                    .pageHeaderDefault,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'ScreenHeader',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _lume_widgetbook_use_cases_navigation_use_cases
                    .screenHeaderDefault,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'trail',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'ContentCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _lume_widgetbook_use_cases_trail_use_cases
                    .contentCardDefault,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'PathNode',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Path',
                builder:
                    _lume_widgetbook_use_cases_trail_use_cases.pathNodePath,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgetbook',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'use_cases',
        children: [
          _widgetbook.WidgetbookComponent(
            name: '_ColorCatalog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Brand & Semantic',
                builder: _lume_widgetbook_use_cases_colors_use_cases
                    .colorBrandAndSemantic,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Extra & Spectrum',
                builder: _lume_widgetbook_use_cases_colors_use_cases.colorExtra,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: '_TypographyCatalog',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Body',
                builder:
                    _lume_widgetbook_use_cases_typography_use_cases.typoBody,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Headlines',
                builder: _lume_widgetbook_use_cases_typography_use_cases
                    .typoHeadlines,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Labels & Tags',
                builder:
                    _lume_widgetbook_use_cases_typography_use_cases.typoLabels,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];

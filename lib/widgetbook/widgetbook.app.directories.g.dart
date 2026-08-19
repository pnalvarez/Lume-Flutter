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
import 'package:lume/widgetbook/use_cases/stat_chip_use_cases.dart'
    as _lume_widgetbook_use_cases_stat_chip_use_cases;
import 'package:lume/widgetbook/use_cases/tiles_and_loader_use_cases.dart'
    as _lume_widgetbook_use_cases_tiles_and_loader_use_cases;
import 'package:lume/widgetbook/use_cases/trail_use_cases.dart'
    as _lume_widgetbook_use_cases_trail_use_cases;
import 'package:lume/widgetbook/use_cases/typography_use_cases.dart'
    as _lume_widgetbook_use_cases_typography_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
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
                name: 'Sizes',
                builder:
                    _lume_widgetbook_use_cases_button_use_cases.buttonSizes,
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

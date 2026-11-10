# Auror-specific (when `pubspec.yaml` name is `auror`)

Do not apply Lume widget/Bloc filenames here.

- Screen folder: concatenated lowercase (`knowledgecard/`); files snake_case
- Template: `dart run tool/create_screen_template.dart` when present
- Buttons: `PrimaryButton` / `SecondaryButton` / `TertiaryButton`, callback `action`
- `Ds*` prefix only to avoid Flutter name clashes
- Theme: `mainLaunchDarkTheme()` / `AppThemedPage`
- Strings: `lib/common/strings/<feature>_strings.dart`
- Presentation must not import `layers/data` (login exception-type leak is legacy)
- Widgetbook stays in `widgetbook_workspace/` (excluded from app `flutter analyze`)
- After Freezed / injectable / auto_route / mockito changes: `dart run build_runner build --delete-conflicting-outputs`

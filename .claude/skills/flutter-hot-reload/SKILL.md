---
name: flutter-hot-reload
description: Hot reload or hot restart the running `flutter run` session for Lume. Use when the user says "hot reload", "hot restart", "reload the app", or wants to see a Dart change on the simulator.
---

# Flutter hot reload

`flutter run` started by Claude (or backgrounded) has no stdin, so `r` / `R` can't be typed. The Flutter tool listens for signals instead:

- Hot reload: `SIGUSR1`
- Hot restart: `SIGUSR2` (needed for `main()`, DI registration, const/static initializers, enum changes)

## Steps

1. Run `bash .claude/hooks/flutter-hot-reload.sh --manual` (add `--restart` for a hot restart). It signals only a `flutter run` started from this project and prints nothing if none is running.
2. Confirm in the run's output file: look for `Reloaded N of M libraries` or `Restarted application`.
3. If no `flutter run` is running, tell the user and offer `flutter run -d "<device>"` — do not start a second copy while one is running.

## Automatic reload

`.claude/settings.json` has a `PostToolUse` hook (`Edit|Write|MultiEdit`) that runs the same script after Claude saves a `.dart` file (generated `*.g.dart` / `*.freezed.dart` are skipped). It does not see edits made in the user's own editor; those use the editor's save-reload or this skill.

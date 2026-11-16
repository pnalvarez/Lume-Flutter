#!/usr/bin/env bash
# Stop: if Dart files changed, run `flutter analyze`. On errors, exit 2 so
# Claude keeps working and fixes them. Only errors are fatal (not infos/warnings).
input=$(cat)
# Avoid an infinite loop: if we already forced a continuation, let it stop.
[ "$(jq -r '.stop_hook_active // false' <<<"$input")" = "true" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git status --porcelain | grep -q '\.dart$' || exit 0

if ! out=$(flutter analyze --no-fatal-infos --no-fatal-warnings 2>&1); then
  {
    echo "flutter analyze reported errors. Fix them before finishing:"
    echo "$out" | tail -40
  } >&2
  exit 2
fi
exit 0

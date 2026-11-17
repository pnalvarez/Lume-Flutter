#!/usr/bin/env bash
# PostToolUse hook (Edit|Write|MultiEdit): hot reload the running `flutter run`
# after Claude saves a .dart file. Also usable by hand: flutter-hot-reload.sh --manual [--restart]
# SIGUSR1 = hot reload, SIGUSR2 = hot restart (Flutter tool signal handlers).
set -u

signal=USR1
if [[ "${1:-}" == "--manual" ]]; then
  [[ "${2:-}" == "--restart" ]] && signal=USR2
else
  file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
  [[ "$file" == *.dart ]] || exit 0
  [[ "$file" == *.g.dart || "$file" == *.freezed.dart ]] && exit 0
fi

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
reloaded=0
for pid in $(pgrep -f "flutter_tools.snapshot run"); do
  # Only signal a `flutter run` started from this project.
  cwd=$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p')
  [[ "$cwd" == "$project_dir"* ]] || continue
  kill -"$signal" "$pid" && reloaded=1
done

[[ $reloaded -eq 1 ]] && echo "flutter: sent SIG$signal" >&2
exit 0

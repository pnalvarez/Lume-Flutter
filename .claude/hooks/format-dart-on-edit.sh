#!/usr/bin/env bash
# PostToolUse (Edit|Write|MultiEdit): format the Dart file that was just written.
f=$(jq -r '.tool_input.file_path // ""')
case "$f" in
  *.g.dart|*.freezed.dart|*.gr.dart) exit 0 ;;
  *.dart) [ -f "$f" ] && dart format "$f" >&2 ;;
esac
exit 0

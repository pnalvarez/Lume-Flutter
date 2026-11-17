#!/usr/bin/env bash
# PreToolUse (Bash, only `git commit*`): run the mechanical architecture check
# and block the commit (exit 2) if it fails. Same script CI runs.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
if ! out=$(bash tool/check_architecture.sh 2>&1); then
  {
    echo "Architecture check failed. Fix these before committing:"
    echo "$out"
  } >&2
  exit 2
fi
exit 0

#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit|Bash): block touching secret/signing files.
# Exit 2 = block, stderr is shown to Claude.
input=$(cat)
tool=$(jq -r '.tool_name // ""' <<<"$input")
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Secret-looking basenames. *.example / *.sample templates are allowed.
is_secret() {
  local name; name=$(basename "$1")
  case "$name" in
    *.example|*.sample|*.template) return 1 ;;
    .env|.env.*|google-services.json|GoogleService-Info.plist) return 0 ;;
    *.jks|*.jks.bak|*.keystore|*.p8|*.p12|*.pem|*.mobileprovision) return 0 ;;
    key.properties|service-account*.json) return 0 ;;
  esac
  return 1
}

block() { echo "Blocked: $1 looks like a secret/signing file. Ask the user to do this manually." >&2; exit 2; }

case "$tool" in
  Edit|Write|MultiEdit)
    f=$(jq -r '.tool_input.file_path // ""' <<<"$input")
    is_secret "$f" && block "$f"
    ;;
  Bash)
    cmd=$(jq -r '.tool_input.command // ""' <<<"$input")
    # 1) Secret files named anywhere in the command (git add/commit, cat, cp...).
    for word in $cmd; do
      w=${word//[\"\';]/}
      is_secret "$w" && block "$w"
    done
    # 2) Broad adds (`git add .`, -A, -u) that would sweep up untracked secrets.
    if grep -Eq 'git[[:space:]]+add[[:space:]]+(-A|--all|-u|\.)([[:space:]]|$)' <<<"$cmd"; then
      while IFS= read -r f; do
        is_secret "$f" && block "$f (untracked, would be staged by a broad git add)"
      done < <(git ls-files --others --exclude-standard)
    fi
    ;;
esac
exit 0

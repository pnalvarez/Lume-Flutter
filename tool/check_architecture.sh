#!/usr/bin/env bash
# Mechanical Lume architecture checks. Not AI — import and placement only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail=0
violations=()

note() { violations+=("$1"); fail=1; }

# Allowlisted domain → data leaks (do not add files here without a migration).
domain_data_allowlist='
lib/layers/domain/mappers/trail_game_mapper.dart
lib/layers/domain/models/trail/trail_catalog_domain.dart
lib/layers/domain/models/trail_game/trail_game.dart
'

is_allowlisted() {
  local file="$1"
  local list="$2"
  grep -qxF "$file" <<<"$list"
}

check_grep_in() {
  local dir="$1"
  local pattern="$2"
  local message="$3"
  local extra_allow="${4:-}"

  [[ -d "$dir" ]] || return 0
  while IFS= read -r -d '' file; do
    rel="${file#"$ROOT/"}"
    if [[ -n "$extra_allow" ]] && is_allowlisted "$rel" "$extra_allow"; then
      continue
    fi
    if grep -nE "$pattern" "$file" >/dev/null 2>&1; then
      hits="$(grep -nE "$pattern" "$file" | head -n 5)"
      note "$message
  $rel
$hits"
    fi
  done < <(find "$dir" -name '*.dart' -print0)
}

echo "== Lume architecture check =="

check_grep_in lib/layers/presentation \
  "package:lume/layers/data" \
  "BLOCKER: presentation must not import layers/data"

check_grep_in lib/layers/presentation \
  "package:(dio|supabase_flutter)/" \
  "BLOCKER: presentation must not import Dio or supabase_flutter"

check_grep_in lib/layers/data \
  "package:(flutter|dio|supabase_flutter)/" \
  "BLOCKER: data must not import Flutter, Dio, or supabase_flutter"

check_grep_in lib/layers/data \
  "package:lume/layers/presentation" \
  "BLOCKER: data must not import presentation"

check_grep_in lib/layers/domain \
  "package:lume/layers/data" \
  "BLOCKER: domain must not import layers/data (new files)" \
  "$domain_data_allowlist"

check_grep_in lib/layers/domain \
  "package:flutter/" \
  "BLOCKER: domain must not import Flutter"

check_grep_in packages/lume_design_system \
  "package:lume/" \
  "BLOCKER: lume_design_system must not import package:lume"

# supabase_flutter only in approved files
while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  case "$rel" in
    lib/bootstrap.dart|lib/core/auth/auth_service.dart) continue ;;
  esac
  if grep -q 'package:supabase_flutter/' "$file"; then
    note "BLOCKER: supabase_flutter only allowed in bootstrap.dart and auth_service.dart
  $rel"
  fi
done < <(find lib -name '*.dart' -print0)

# dio only under core/network
while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  case "$rel" in
    lib/core/network/*) continue ;;
  esac
  if grep -q 'package:dio/' "$file"; then
    note "BLOCKER: dio only allowed under lib/core/network/
  $rel"
  fi
done < <(find lib -name '*.dart' -print0)

# Material buttons in app layers (DS owns them)
while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  if grep -nE '\b(ElevatedButton|TextButton|OutlinedButton)\b' "$file" >/dev/null; then
    hits="$(grep -nE '\b(ElevatedButton|TextButton|OutlinedButton)\b' "$file" | head -n 5)"
    note "SHOULD FIX: use LumeButton in app screens, not Material buttons
  $rel
$hits"
  fi
done < <(find lib/layers/presentation -name '*.dart' -print0)

# getIt in presentation only in *_page.dart
while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  base="$(basename "$rel")"
  case "$base" in
    *_page.dart) continue ;;
  esac
  if grep -q 'getIt<' "$file"; then
    note "SHOULD FIX: getIt belongs in *_page.dart, not $rel"
  fi
done < <(find lib/layers/presentation -name '*.dart' -print0)

# blocs must not import auto_route
while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  if grep -q 'package:auto_route/' "$file"; then
    note "BLOCKER: blocs must not import auto_route (navigate from the page via state)
  $rel"
  fi
done < <(find lib/layers/presentation -name '*_bloc.dart' -print0)

if (( fail )); then
  echo
  echo "Architecture disagreements:"
  printf '\n%s\n' "${violations[@]}"
  echo
  echo "See .cursor/skills/lume-auror-architecture/SKILL.md"
  exit 1
fi

echo "OK — no architecture disagreements (mechanical rules)."

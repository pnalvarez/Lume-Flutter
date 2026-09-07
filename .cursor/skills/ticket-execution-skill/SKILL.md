---
name: ticket-execution-skill
description: >-
  Implements a GitHub issue from the Lume-Flutter board on a new branch from
  main, dart-formats, commits, pushes, and opens a PR. Use when the user asks
  to execute, implement, or work a ticket/issue, or mentions ticket-execution-skill,
  issue-<number>, or a GitHub board card.
---

# Ticket execution

End-to-end: GitHub issue → branch `issue-<number>` from `main` → implement → `dart format` → commit → push → PR.

Repo: `pnalvarez/Lume-Flutter`. Work only in this checkout.

## Input

- **issue number** (required): `42`, `#42`, or a GitHub issue URL
- Optional: extra constraints the user adds in chat

If no number is given, list open issues (`gh issue list --state open --limit 20`) and ask which one.

## Type → commit prefix

Pick **one** of `feat` | `fix` | `refactor`:

| Signal | Prefix |
|--------|--------|
| label `bug` or title `[Bug]` | `fix` |
| label `feature` or title `[Feat]` / `[Feature]` | `feat` |
| label `refactor` or title `[Refactor]` | `refactor` |

If signals conflict, prefer the **label**. If none, infer: broken behavior → `fix`; new capability → `feat`; restructure with no behavior change → `refactor`.

## Commit message

```
[<type>](<git user.name>): <imperative description>
```

- `<git user.name>`: exact output of `git config user.name` (do not substitute GitHub login)
- `<imperative description>`: short why/what from the issue; strip `[Feat]` / `[Bug]` / `[Refactor]` prefixes; no trailing period; do not put the issue number in the subject

**Examples**

- `[fix](Pedro Alvarez): fill Profile member-since with account creation timestamp`
- `[feat](Pedro Alvarez): add Settings screen with Personal Info and Edit Categories`
- `[refactor](Pedro Alvarez): extract Profile header into a dedicated body widget`

## Workflow

Copy and track:

```
Ticket Progress:
- [ ] 1. Fetch issue
- [ ] 2. Branch from main
- [ ] 3. Implement
- [ ] 4. dart format
- [ ] 5. Architecture check
- [ ] 6. Commit
- [ ] 7. Push
- [ ] 8. Open PR
```

### 1. Fetch issue

```bash
gh issue view <number> --repo pnalvarez/Lume-Flutter
```

Or GitHub MCP `issue_read` (`owner: pnalvarez`, `repo: Lume-Flutter`, `method: get`). Also read comments if they change scope.

**Stop** if the issue is closed, or already has an open PR that fully addresses it — report the URL instead of duplicating work.

Read acceptance criteria, repro steps, and scope. Do not expand beyond the ticket unless the user asked.

### 2. Branch from main

Working tree must be clean of **unrelated** changes. If dirty with other work, stop and ask; do not stash silently.

```bash
git fetch origin main
git checkout main
git pull --ff-only origin main
git checkout -b issue-<number>
```

If `issue-<number>` already exists locally or on origin, check it out and rebase/ff onto `origin/main` only when that is safe (no rewrite of a published branch the user did not ask to rewrite). Never `push --force` unless the user explicitly requests it.

### 3. Implement

1. Read and follow `.cursor/skills/lume-auror-architecture/SKILL.md` (and screen rules under `.cursor/rules/` when touching pages).
2. Implement the issue. Add or update tests when Dart logic changes (CI gates 80% coverage on changed lines).
3. Run `dart run build_runner build --delete-conflicting-outputs` when codegen is needed.
4. For UI changes, verify the affected flow (browser for Flutter web when available; otherwise tests / Widgetbook). Hunt regressions on screens that share the same state.

Do not commit secrets, `.env`, or unrelated untracked files (e.g. Xcode `swiftpm` workspace noise).

### 4. dart format

Format **changed** Dart files, excluding generated sources (same exclusions as CI):

```bash
mapfile -t files < <(
  git diff --name-only --diff-filter=ACMR origin/main |
    grep '\.dart$' |
    grep -vE '\.(g|gr|freezed|config|mocks)\.dart$' |
    grep -v 'widgetbook.app.directories.g.dart'
)
if ((${#files[@]})); then dart format "${files[@]}"; fi
```

`zsh` without `mapfile`:

```bash
files=("${(@f)$(git diff --name-only --diff-filter=ACMR origin/main | grep '\.dart$' | grep -vE '\.(g|gr|freezed|config|mocks)\.dart$' | grep -v 'widgetbook.app.directories.g.dart')}")
(( ${#files} )) && dart format "${files[@]}"
```

### 5. Architecture check

```bash
bash tool/check_architecture.sh
```

Fix every reported violation before committing.

### 6. Commit

This skill **authorizes** commit, push, and PR (do not wait for a second ask).

Follow the repo git safety rules: no `--no-verify`, no amend of others' commits, no force-push, no config changes.

```bash
git add <files related to the ticket only>
git commit -m "$(cat <<'EOF'
[<type>](<user.name>): <description>

EOF
)"
```

Use a real HEREDOC with the resolved type, name, and description (not the placeholders). One commit is enough unless the user asked to split.

### 7. Push

```bash
git push -u origin HEAD
```

Needs `all` / network permissions for SSH or HTTPS auth.

### 8. Open PR

If a PR for this head branch already exists, return its URL.

Otherwise use `gh` (not a substitute API) and fill `.github/pull_request_template.md`:

```bash
gh pr create --base main --title "<PR title>" --body "$(cat <<'EOF'
## Description

Implements #<number>.

<what changed and why — 1–3 short paragraphs or bullets>

Closes #<number>

## How to Reproduce

1. <entry point>
2. <steps a reviewer can follow>
3. Expected: <outcome>

## Evidence

- Architecture check passed
- <tests run / UI verification notes>

EOF
)"
```

**PR title:** `[<type>] <same imperative description as the commit>` (no username in the title). Example: `[feat] add Settings screen with Personal Info and Edit Categories`

Return the PR URL when done.

## Guardrails

- Branch name is exactly `issue-<number>` (no extra suffixes).
- Base is always `main`.
- Do not skip format or architecture check because CI would catch it.
- Do not close the GitHub issue yourself; `Closes #<number>` on merge is enough.
- If implementation is blocked (missing design, credentials, or an ambiguous ticket), comment on the issue or stop and ask — do not open an empty PR.

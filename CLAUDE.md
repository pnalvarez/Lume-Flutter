# Lume

## Architecture and conventions

Before writing or reviewing Dart code (including PR reviews), read and apply:

- `.claude/skills/lume-auror-architecture/SKILL.md` — layers, dependency direction, naming, DI, design-system usage, copy/strings, tests. Details: `reference.md` (allowlist, button matrix) and `auror.md` (Auror-only) in the same folder.
- `.claude/rules/dumb-screen-bodies.md` — `*_body.dart` takes state + callbacks only; decision logic lives on state/bloc.
- `.claude/rules/widgetbook-screens.md` — every screen ships a Bloc-free `*Body` plus Widgetbook `[Lume]/[Screens]` use cases.

Key blockers: presentation must not import `layers/data`, Dio or Supabase; pages never call use cases (only `getIt<FooBloc>()` + events); Supabase/Dio/Firebase SDKs only in their approved `lib/core/**` files and `bootstrap.dart`.

Mechanical check: `bash tool/check_architecture.sh` (CI Architecture job). Fix violations before committing.

To implement a GitHub issue end to end, follow `.claude/skills/ticket-execution-skill/SKILL.md`.

`.cursor/` holds the same rules for Cursor; keep both in sync when changing conventions.

## PR evidence images

Never commit screenshots/evidence images (before/after, bug repro, etc.) into the repo or a commit. Attach them to the PR body/comments only — e.g. drag-and-drop into the GitHub web UI, or ask the user before uploading anywhere (gist, image host) on their behalf. Keeps git history free of binary bloat.

# Lume

**Learn with games and trails.**

Lume is a multiplatform Flutter app for playful, structured learning. Players follow educational **trails** (levels → submodules → games), play short mini-games, earn **XP**, and level up — with an arcade mode for quick sessions outside the trail path.

| Platform | Distribution |
|----------|----------------|
| Android | Firebase App Distribution |
| iOS / macOS | TestFlight |
| Web | Vercel |
| Linux | GitHub Releases |

---

## Features

- **Auth** — email sign-up / sign-in, email confirmation, password recovery (Supabase Auth + PKCE)
- **Onboarding & preferences** — first-run flow and category selection
- **Learning trails** — bootstrap progress, trail detail, submodule sessions
- **Mini-games**
  - Lightning Quiz
  - Who Am I
  - True or Myth
  - Complete Sentence
  - Mysterious Word
  - Battle of Curiosities
  - Connections
  - Timeline
- **Games hub & arcade** — browse / play rounds and save arcade records
- **XP & level-up** — awards and a global level-up alert
- **Profile & dashboard** — player overview after authentication

---

## Tech stack

| Area | Choice |
|------|--------|
| UI | Flutter + local `lume_design_system` |
| State | `flutter_bloc` |
| Navigation | `auto_route` |
| DI | `get_it` + `injectable` |
| Backend | Supabase (`supabase_flutter`) |
| HTTP | Dio (via core network client / RPC) |
| Catalog | Widgetbook (`lib/widgetbook/`) |
| Codegen | `build_runner`, Freezed, json_serializable, injectable / auto_route generators |

### Architecture

Clean layered structure:

```
presentation → domain → (contracts)
data         → domain contracts + core
core         → Flutter / Dio / Supabase (approved surfaces only)
design system → Flutter only (no app imports)
```

Dependency direction and naming rules are enforced in CI via `tool/check_architecture.sh`.

```
lib/
├── app/                 # App shell, router
├── bootstrap.dart       # Supabase + DI + runApp
├── common/strings/      # User-facing copy
├── core/                # config, DI, network, auth, errors
├── layers/
│   ├── data/
│   ├── domain/          # models, repositories, usecases
│   └── presentation/    # screens, blocs, shared UI
└── widgetbook/          # design / screen catalog
packages/
└── lume_design_system/
```

---

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (stable; SDK `^3.11.5` per `pubspec.yaml`)
- Dart SDK bundled with Flutter
- Platform toolchains for the targets you care about (Xcode, Android SDK, etc.)

---

## Getting started

```bash
git clone https://github.com/pnalvarez/Lume-Flutter.git
cd Lume-Flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Environment

Supabase URL and anon key come from compile-time defines, with repo defaults in `AppConfig` so a plain `flutter run` works for local development:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Deep-link schemes used for auth:

- `io.lume.app://login-callback`
- `io.lume.app://reset-password`

### Widgetbook

```bash
flutter run -t lib/widgetbook/main.dart
```

---

## Development

### Code generation

After changing `@injectable`, `@RoutePage`, Freezed, or JSON models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Tests

```bash
# Unit / core / app tests
flutter test test/unit test/core test/app

# App widget smoke tests
flutter test test/widget_test.dart

# Design system
cd packages/lume_design_system && flutter test
```

CI also enforces **~80% coverage on changed Dart lines** (via `pull_request_coverage`).

### Architecture check

```bash
bash tool/check_architecture.sh
```

### Style

```bash
dart format .
flutter analyze
```

---

## Project layout (presentation)

Screens live under `lib/layers/presentation/screens/`:

| Area | Screens |
|------|---------|
| Auth | Login, confirm email, define password, recover password |
| Onboarding | Onboarding, select category |
| Trail | Home, trail detail, submodule session |
| Games | Games hub, game round (per type) |
| Account | Profile, dashboard |
| Boot | Splash |

Convention: pages resolve a **Bloc** via GetIt and dispatch events; use cases are injected into blocs, not pages. Screen bodies stay Bloc-/router-free for Widgetbook and tests.

---

## CI & deploy

### CI (every PR / push to `main`)

Workflow: [`.github/workflows/ci.yml`](.github/workflows/ci.yml)

- Unit tests + changed-line coverage
- UI / widget tests (app + design system)
- Format + analyze
- Architecture script
- Release build smoke (Android APK, iOS no codesign)

### Deploy

Workflow: [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)  
Full secrets & platform notes: **[docs/deploy.md](docs/deploy.md)**

| Trigger | Effect |
|---------|--------|
| Tag `v*` (e.g. `v1.0.1`) | Deploy Android + iOS + macOS + Web + Linux |
| Manual `workflow_dispatch` | Choose platforms |

Typical release flow:

1. Merge to `main` (CI green)
2. Bump marketing version in `pubspec.yaml` if needed
3. Tag and push:

```bash
git tag v1.0.1
git push origin main --tags
```

---

## Contributing

1. Create a branch from `main`
2. Keep presentation / domain / data boundaries intact
3. Put user copy in `lib/common/strings/`
4. Prefer design-system components (`LumeButton`, tokens, etc.)
5. Add or update tests for changed logic
6. Open a PR using the template in `.github/pull_request_template.md`

---

## License

Proprietary — all rights reserved.

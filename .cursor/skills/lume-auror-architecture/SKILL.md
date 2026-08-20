---
name: lume-auror-architecture
description: >-
  Verifies Flutter code against Lume and Auror layer architecture, naming,
  DI, design-system usage, and copy conventions. Use when writing or reviewing
  Lume/Auror Dart, PRs, new screens, blocs/view models, repositories, or when
  the user mentions architecture, styleguide, layers, or CI architecture checks.
---

# Lume / Auror architecture

Two apps share **layers + injectable + AutoRoute + flutter_bloc + atomic DS**.
They do **not** share widget names or the Bloc class filename.

| | **Lume** | **Auror** |
|---|---|---|
| Screen logic | `FooBloc` in `foo_bloc.dart` | `FooViewModel extends Bloc` in `foo_view_model.dart` |
| Primary button | `LumeButton` + `trait` / `type` | `PrimaryButton` + `action:` |
| Widgetbook | `lib/widgetbook/` | `widgetbook_workspace/` |
| Failures | `AuthFailure` types | exceptions mapped in presentation |

Detect the repo (`pubspec.yaml` `name:`) and apply **that** column. Never mix `LumeButton` into Auror or `PrimaryButton` into Lume.

## Workflow

1. Run the mechanical checker (Lume):

```bash
bash tool/check_architecture.sh
```

Fix every reported violation (unless it is on the allowlist in that script).

2. Apply the judgment checklist below to **new/changed** files only.
3. Report as:
   - **Blocker** — layer leak, SDK in the wrong package, new allowlisted exception
   - **Should fix** — naming, strings, DS tokens, Bloc in the page
   - **Nit** — taste (body vs page split)

## Dependency direction

```
presentation → domain (usecases, models) + common/strings + design system + core/di + core/errors
usecases     → domain repositories + domain models
data         → domain contracts + core (IApiClient, IAuthService, IStorageClient)
core         → Flutter / Dio / Supabase only in approved files
design system → Flutter only; never `package:lume/` or `package:auror/`
```

**Never**

- Presentation → `layers/data`, `package:dio`, `package:supabase_flutter`
- Data → `package:flutter`, Dio/Supabase directly, `presentation`
- Domain → `layers/data` (Lume has three legacy leaks; do not add more — see script allowlist)
- Supabase outside `lib/core/auth/auth_service.dart` and `lib/bootstrap.dart` (Lume)
- Dio outside `lib/core/network/**` (Lume)

## Naming (Lume)

- Contract + impl in the **same file**: `abstract interface class IFoo` + `@Injectable(as: IFoo) final class Foo`
- Use case: `ISignInWithEmail` / `SignInWithEmail` with `call(...)`
- Data DTO: `*_data.dart` + `@JsonSerializable`; domain: no `json_annotation`
- Mapper in **data**: `FooMapper.toDomain`
- Screen: `@RoutePage()` `FooPage` → `BlocProvider` → private `_*View`
- Bloc: `{feature}_bloc.dart` + `_event.dart` + `_state.dart` (hand-written `@immutable`, not Freezed)
- Blocs are **not** injectable; construct in the page with `getIt<IUseCase>()`
- `getIt` only in `*_page.dart` (and `bootstrap` / `di`)
- Blocs must not import `auto_route`; navigation via state flags + `BlocListener`

## Naming (Auror)

- Logic class is `*ViewModel` still extending `Bloc`; `@injectable`; `getIt<FooViewModel>()` on the page
- Prefer `*_body.dart` without router/GetIt (testable in `test/ui/`)
- Events/states: Freezed
- Extra GetIt params: wrap in a factory-args class (max two `@factoryParam`)

## Presentation UX (Lume)

- User copy: `lib/common/strings/*.dart` consts — no magic Portuguese/English in widgets
- App screens: `LumeButton`, never raw `ElevatedButton`/`TextButton`/`OutlinedButton`
- Tokens: `AppSpacings`, `AppRadius`, `AppSizes`, `typ.*`, `Theme.of(context).colorScheme`
- DS imports: concrete files (`.../lume_button.dart`), not the package barrel
- Chrome:
  - Login / define password → `AuthScaffold`
  - Confirm email / recover password → `ScreenHeader` + `Scaffold`
  - Authenticated shells → `PageHeader` as `appBar`

## Data (Lume)

- HTTP: `IApiClient.rpc` (prefer RPC over raw REST)
- Auth SDK: only `IAuthService`
- Cache: `IStorageClient` + `*Data.fromJson`

## Tests

- Lume: `test/unit/{data,domain,presentation}`, `test/core`, `test/app`, `test/widget_test.dart`, DS `packages/lume_design_system/test/`
- Auror: ViewModels in `test/unit/presentation`, bodies in `test/ui/`
- Fakes/mocks in `test/helpers/`; mock **interfaces**

## CI

`tool/check_architecture.sh` is the GitHub **Architecture** job. It cannot run this skill (no AI on Actions). It only greps **import and placement** rules. You still apply judgment here.

## More

- Layer leaks and allowlist: [reference.md](reference.md)
- Auror-only notes: [auror.md](auror.md)

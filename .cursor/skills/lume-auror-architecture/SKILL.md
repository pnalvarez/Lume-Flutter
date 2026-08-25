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
- **`*_page.dart` / screen views → use cases** (`layers/domain/usecases`, `getIt<I…UseCase>()`, calling `ISave…` / `IGet…` directly). Pages only `getIt` the feature **Bloc** / **ViewModel** and dispatch **events**. Use cases are injected into the bloc/ViewModel via DI.
- Data → `package:flutter`, Dio/Supabase directly, `presentation`
- Domain → `layers/data` (no allowlisted leaks; keep it that way)
- Supabase outside `lib/core/auth/auth_service.dart` and `lib/bootstrap.dart` (Lume)
- Dio outside `lib/core/network/**` (Lume)

## Naming (Lume)

- Contract + impl in the **same file**: `abstract interface class IFoo` + `@Injectable(as: IFoo) final class Foo`
- Use case: `ISignInWithEmail` / `SignInWithEmail` with `call(...)`
- Data DTO: `*_data.dart` + `@JsonSerializable`; domain: no `json_annotation`
- Mapper in **data**: `FooMapper.toDomain`
- Screen: `@RoutePage()` `FooPage` → `BlocProvider` → private `_*View`
- Bloc: `{feature}_bloc.dart` + `_event.dart` + `_state.dart` (hand-written `@immutable`, not Freezed)
- Blocs are `@injectable`; pages only `getIt<FooBloc>()` (pass route args via start events, not `@factoryParam`)
- **Blocker — no use cases in pages:** do not import `layers/domain/usecases` or resolve use-case interfaces with `getIt` from `*_page.dart` (or nested `_*View` in that file). Inject use cases into the **bloc**; user interactions become **bloc events** (including persistence / save callbacks that would otherwise call a use case from the page).
- `getIt` only in `*_page.dart` (and `bootstrap` / `di`) — and only for **blocs**, never for use cases
- Blocs must not import `auto_route`; navigation via state flags + `BlocListener`

## Naming (Auror)

- Logic class is `*ViewModel` still extending `Bloc`; `@injectable`; `getIt<FooViewModel>()` on the page
- Prefer `*_body.dart` without router/GetIt (testable in `test/ui/`)
- Events/states: Freezed
- Extra GetIt params: wrap in a factory-args class (max two `@factoryParam`)
- Same **no use cases in pages** rule as Lume: inject use cases into the ViewModel; pages only dispatch events

## Presentation UX (Lume)

- User copy: `lib/common/strings/*.dart` consts — no magic Portuguese/English in widgets
- App screens: `LumeButton`, never raw `ElevatedButton`/`TextButton`/`OutlinedButton`
- Tokens: `AppSpacings`, `AppRadius`, `AppSizes`, `typ.*`, `Theme.of(context).colorScheme`
- DS imports: concrete files (`.../lume_button.dart`), not the package barrel
- Chrome:
  - Login / define password → `AuthScaffold`
  - Confirm email / recover password → `ScreenHeader` + `Scaffold`
  - Authenticated shells → `PageHeader` as `appBar`
- **Screen bodies + Widgetbook:** every product screen exposes a Bloc-free `*Body` (state + callbacks; no GetIt / AutoRoute / feature Bloc). Catalog it under Widgetbook path `[Lume]/[Screens]/…` with the main visual states. See `.cursor/rules/widgetbook-screens.mdc`.
- **Bodies stay dumb:** no feature decision logic in `*_body.dart` / widgets. Selection correctness, `ChoiceVisualState` (and similar chip visuals), enablement flags (`canSubmit`, `allLinked`, …), sorted/filtered game lists, and prompt assembly belong on `*_state.dart` (getters / helpers) or the bloc. Bodies only compose UI from state + callbacks. Nested private *widgets* for layout/styling are fine; private *methods* that decide game/UI state are not.

## Data (Lume)

- HTTP: `IApiClient.rpc` (prefer RPC over raw REST)
- Auth SDK: only `IAuthService`
- Cache: `IStorageClient` + `*Data.fromJson`

## Tests

- Lume: `test/unit/{data,domain,presentation}`, `test/core`, `test/app`, `test/widget_test.dart`, DS `packages/lume_design_system/test/`
- Auror: ViewModels in `test/unit/presentation`, bodies in `test/ui/`
- Fakes/mocks in `test/helpers/`; mock **interfaces**

## CI

`tool/check_architecture.sh` is the GitHub **Architecture** job. It cannot run this skill (no AI on Actions). It only greps **import and placement** rules (including dumb `*_body.dart` visual helpers). You still apply judgment here.

## More

- Layer leaks and allowlist: [reference.md](reference.md)
- Auror-only notes: [auror.md](auror.md)

# Lume mechanical rules

The CI script `tool/check_architecture.sh` encodes these. Known debt is allowlisted so **new** files cannot copy it.

## Allowlisted (do not grow)

None currently. Prefer fixing leaks over adding allowlist entries.

## Preferred new-code patterns

- Register every use case with `@Injectable(as: IFoo)`.
- Screen blocs are `@injectable`; pages only `getIt<FooBloc>()` (no use-case wiring in the page).
- Keep `GameType` (or equivalent) in **domain**; data maps to it (converter / wire value in data).
- Mappers that touch `*Data` live under `layers/data/mappers/`.
- Do not add `*_repository_impl.dart`; impl name matches the interface minus `I`.
- Prefer `@preResolve` for async singletons (e.g. `SharedPreferences`) so page `getIt` stays sync.
- Put derived game/UI decisions on `*_state.dart` (or the bloc), not in `*_body.dart`. Bodies must not define methods that return `ChoiceVisualState` / chip visual enums (see CI).

## Button matrix (Lume)

- `trait`: `brand` \| `secondary` \| `success` \| `destructive`
- `type`: `elevated` \| `outlined` \| `text` \| `link`
- Form primary CTA: `size: lg`, `isExpanded: true`
- Loading + `isEnabled: true`: keep enabled colors, spinner centered, ignore taps

# Lume mechanical rules

The CI script `tool/check_architecture.sh` encodes these. Known debt is allowlisted so **new** files cannot copy it.

## Allowlisted (do not grow)

None currently. Prefer fixing leaks over adding allowlist entries.

## Preferred new-code patterns

- Register every use case with `@Injectable(as: IFoo)`; pages only `getIt<IFoo>()`.
- Keep `GameType` (or equivalent) in **domain**; data maps to it (converter / wire value in data).
- Mappers that touch `*Data` live under `layers/data/mappers/`.
- Do not add `*_repository_impl.dart`; impl name matches the interface minus `I`.

## Button matrix (Lume)

- `trait`: `brand` \| `secondary` \| `destructive`
- `type`: `elevated` \| `outlined` \| `text` \| `link`
- Form primary CTA: `size: lg`, `isExpanded: true`
- Loading + `isEnabled: true`: keep enabled colors, spinner centered, ignore taps

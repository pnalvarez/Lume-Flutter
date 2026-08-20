# Lume mechanical rules

The CI script `tool/check_architecture.sh` encodes these. Known debt is allowlisted so **new** files cannot copy it.

## Allowlisted (do not grow)

| File | Issue |
|---|---|
| `lib/layers/domain/mappers/trail_game_mapper.dart` | Domain mapper imports data models |
| `lib/layers/domain/models/trail/trail_catalog_domain.dart` | Domain imports `game_type.dart` from data |
| `lib/layers/domain/models/trail_game/trail_game.dart` | Same |
| `lib/core/network/dio_api_client.dart` | Unused Dio leftover — do not use for new code |
| `lib/layers/presentation/screens/auth/define_password/define_password_page.dart` | Constructs `ClearPasswordRecovery(getIt<IAuthRepository>())` instead of an injectable use case |

## Preferred new-code patterns

- Register every use case with `@Injectable(as: IFoo)`; pages only `getIt<IFoo>()`.
- Keep `GameType` (or equivalent) in **domain**; data maps to it.
- Mappers that touch `*Data` live under `layers/data/mappers/`.
- Do not add `*_repository_impl.dart`; impl name matches the interface minus `I`.

## Button matrix (Lume)

- `trait`: `brand` \| `secondary` \| `destructive`
- `type`: `elevated` \| `outlined` \| `text` \| `link`
- Form primary CTA: `size: lg`, `isExpanded: true`
- Loading + `isEnabled: true`: keep enabled colors, spinner centered, ignore taps

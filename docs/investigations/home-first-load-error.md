# Home first-load error investigation

**Date:** 2026-09-19  
**Scope:** Flutter Lume — Home screen (`HomePage` / `HomeBloc` → game trails + trail progress)  
**Symptom:** On first open after app launch (cold start), Home shows the error UI (“Não foi possível carregar suas trilhas.”). Retry succeeds and trails load normally. Modules also never appear instantly.

---

## Verdict

Home is **not designed for instant module load**: trail modules always come from a live `get_game_trails` RPC (intentionally uncached). The error UI is **not** “empty treated as error” — it is any thrown exception from trails or progress (profile failures are swallowed). Retry often works because it is a **second network attempt**.

---

## Flow

```
HomePage
  → HomeBloc + HomeStarted(forceRefresh: false)
  → IGetGameTrails → TrailRepository → TrailDataSource.fetchGameTrails
      → always DELETE cache + rpc('get_game_trails')   // NEVER cached
  → IGetTrailProgress → … → fetchProgress
      → cache hit OR rpc('get_trail_progress')
  → IGetProfile (errors ignored)
  → emit ready | on any Object → HomeStatus.error
HomeBody switch(status): loading | error + Retry | ready (empty list OK)
```

Key files:

| Layer | Path |
|---|---|
| Page | `lib/layers/presentation/screens/trail/home/home_page.dart` |
| Bloc | `lib/layers/presentation/screens/trail/home/home_bloc.dart` |
| Body / UI | `lib/layers/presentation/screens/trail/home/home_body.dart` |
| Data source | `lib/layers/data/datasource/trail_data_source.dart` |
| Mapper | `lib/layers/data/mappers/trail_mapper.dart` → `TrailGameMapper.parseAll` |
| RPC (DB) | `get_game_trails` / `get_trail_progress` (Supabase, authenticated-only) |

---

## Why modules never load instantly

`fetchGameTrails` never uses cache (payloads are shuffled server-side). Every Home open waits on the network:

```dart
// trail_data_source.dart
Future<List<GameTrailData>> fetchGameTrails({bool forceRefresh = false}) async {
  // Never cache: nested game_payload options are shuffled per RPC response.
  await _storage.delete(CacheKeys.gameTrails);
  final raw = await _apiClient.rpc<List<dynamic>>('get_game_trails');
  return parseJsonList(raw, GameTrailData.fromJson);
}
```

That RPC is expensive: full trail tree including every `game_payload`, marked **VOLATILE** (shuffle). Home only needs titles / emoji / submodule counts + pair IDs for progress cards, but still downloads and fully parses every game.

Loads are **sequential** (trails → progress → profile), so first paint waits on at least one (often two) RPCs. Dio connect/receive timeouts are **15s**.

---

There is no logging of the underlying exception, which makes field debugging harder.

---

## Likely root causes (ranked)

### 1. Missing module cache + heavy authenticated RPC (highest)

**Category:** missing cache + slow/failed network

- `get_game_trails` is authenticated-only (`GRANT … TO authenticated`, `_require_auth_uid()`).
- Large nested JSON + VOLATILE shuffle → cold-start latency / timeout risk.
- `forceRefresh` on retry does **nothing** for trails (already uncached); retry = try the network again.
- Fits “first attempt fails, Retry works” (transient timeout / flaky network).

### 4. Empty or corrupt progress cache (secondary)

**Category:** missing / bad cache

- Progress *can* be cached; first install has none → second RPC on first open.
- Progress failures also become `HomeStatus.error` (unlike profile).
- Retry with `forceRefresh: true` bypasses a **corrupt** progress cache (`FormatException` on read) — another “first open fails, Retry works” pattern when bad cache exists.

Usually fails **every** retry (persistent data bug), unless the first failure was network/timeout before parse completed.

---

## Ruled out / low

| Hypothesis | Finding |
|---|---|
| UI treats loading/empty as error | **No.** Loading = shimmer; empty = ready + empty copy. |
| Remote config blocks modules | **No.** Remote config is arcade/hub only. |
| Instant load from local modules | **Impossible by design** — modules never cached. |

---

## How to confirm in a repro

| Symptom on first failing request | Likely cause |
|---|---|
| Timeout / slow `rpc/get_game_trails` | Heavy payload (#1) |
| HTTP 401 / DB `not authenticated` | JWT race (#3) |
| Client `FormatException: Missing game_payload…` / unsupported `game_format` | Parse (#5) |
| Splash already logged a profile/prefs failure | Splash continue-on-failure (#2) |
| Progress cache `FormatException`, retry with forceRefresh works | Corrupt progress cache (#4) |

---

## Mitigations in place

- **Data-layer RPC retries (2026-09-19):** `TrailDataSource` wraps `get_game_trails`, `get_trail_progress`, and `get_trail_bootstrap` with `withRpcRetries` (up to **3 attempts**, 300ms apart) for transient failures (timeout, network, 401/403/408/429/5xx). See `lib/core/network/rpc_retry.dart`.

## Further fix directions

1. **Don’t use `get_game_trails` for Home** — prefer cached `get_trail_bootstrap` (or a lighter modules RPC) so Home can render from cache and only needs structure + pair IDs.
2. **Ensure a fresh JWT before Home loads** (refresh on splash restore; or Dio wait/retry on 401 after refresh).
3. **Stop `parseAll` on Home** — map structure/pair IDs without full game payload parsing.
4. **Log the real exception** in `HomeBloc` instead of swallowing to a generic string.
5. Optionally **parallelize** trails + progress fetches once the data path is lighter.

---

## Related tests

| File | What it documents |
|---|---|
| `test/unit/data/trail_data_source_test.dart` | `fetchGameTrails` calls RPC twice when called twice — never cached |
| `test/unit/presentation/trail_loading_ui_test.dart` | Default `HomeState` → loading shimmer |
| `test/unit/data/game_type_test.dart` | Unsupported `game_format` → `FormatException` |
| `test/unit/domain/usecases/get_game_trails_test.dart` | Use case forwards to repository |
| **No `HomeBloc` unit tests** | Error/retry/first-load behavior not covered |

Widgetbook separates Error vs Empty for `HomeBody` under trail home use cases.

---

## Bottom line

| Question | Answer |
|---|---|
| Why not instant? | Modules intentionally uncached; every visit waits on `get_game_trails` (+ often progress). |
| Why error first time? | Most likely transient RPC/network/timeout (or splash already saw a failed fetch); less often corrupt progress cache, JWT race, or nested game parse. |
| Primary category | **Missing cache + network.** Secondary: splash continue-on-failure. Auth race lower. **Not** empty-as-error UI. |

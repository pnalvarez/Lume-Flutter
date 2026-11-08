# History pivot (epic #161)

SQL for making Lume History-only. Applied to the shared Supabase project `mizgtuwtuaculchwizkm`.
**Nothing is deleted:** non-History content is hidden by RPC filters and `is_active = false`.

## Layout

- `snapshots/` — pre-pivot definitions and data. Running a snapshot file restores the old behaviour.
- `NN_<name>.sql` — forward migrations, numbered in apply order.
- `NN_<name>.rollback.sql` — the undo for the matching forward file.
- `AUTHORING.md` + `_trail_seed_skeleton.sql` — Phase 5 (#181) trail authoring template and mix targets.
- `NN_trail_<slug>.sql` — one seed per new History trail (#182–#187), after `03_…`.

## Conventions

1. **Snapshot before you change.** Every forward file that replaces an RPC or updates rows needs its snapshot in `snapshots/` first.
2. **Idempotent.** Use `CREATE OR REPLACE`, `WHERE NOT EXISTS`, and `UPDATE ... WHERE <not already set>` so a file can be re-run safely.
3. **One transaction per file** (`BEGIN; ... COMMIT;`), so a failure leaves nothing half-applied.
4. **Hide, never delete.** Use `is_active = false` or an RPC filter. No `DELETE` or `DROP` on content tables.
5. **Back up before rewriting user data** (e.g. `user_achievements` progress): copy the rows to a `_bak_history_pivot_*` table first.
6. **Apply Phase 1 and Phase 2 together.** Otherwise users see History-only trails next to achievements for hidden content.
7. **Verify after every apply** with the queries listed at the bottom of the forward file.

## Apply and rollback

```bash
supabase db query --linked -f tool/seeds/history_pivot/NN_name.sql
supabase db query --linked -f tool/seeds/history_pivot/NN_name.rollback.sql   # undo
```

## Snapshot index

| File | Contents |
| --- | --- |
| `snapshots/00_pre_pivot_rpcs.sql` | `get_game_trails`, `get_trail_bootstrap`, `get_game_round`, `get_random_game_round`, `get_submodule_games` |
| `snapshots/01_pre_pivot_achievements.sql` | `check_achievements`, `get_profile` |

## Apply order (Phase 1 + 2 together)

1. `01_history_scope_rpcs.sql`
2. `02_history_scope_achievements.sql` (needs `_is_app_modulo` from step 1)
3. `03_fix_history_connections.sql` (optional editorial; can follow)

## Phase 5 — new trails (after owner go-ahead)

See `AUTHORING.md`. Apply order:

4. `04_trail_grecia_roma.sql` (#182)
5. `05_trail_idade_media.sql` (#183)
6. `06_trail_renascimento_navegacoes.sql` (#184)
7. `07_trail_era_revolucoes.sql` (#185)
8. `08_trail_brasil_republica.sql` (#186)
9. `09_trail_seculo_xx_guerras.sql` (#187)
10. `10_achievements_new_trails.sql` (#188) — needs the six modules present
11. `11_set_trail_images.sql` — cover `imagem_url`s (binaries live in Storage only)
12. `12_restrict_trilhas_imagens_policies.sql` (#192) — drop temp public write; keep public read

Rollback a trail with its matching `.rollback.sql` (deletes that trail’s rows only).
Rollback Phase 1+2 is the reverse: snapshot `01_…` then `02_…rollback`, then snapshot `00_…` then `01_…rollback`.

**Applied to production** on 2026-11-08 (01→11). New History modules: ids 34–39.

## Inventory notes (captured 2026-11-07)

- Category `1` is História. Modules in it: 7 (Brasil 1500–1889), 8 (Música), 21 (Arte), 22 (Mundial).
- Modules 2, 4, 6 have `categoria_id = NULL`. A strict `= 1` filter hides them (including "História da Computação").
- Functions that call `check_achievements`: `complete_card`, `complete_review_quiz`, `finish_game_match`, `save_pair_progress`, `save_arcade_round`, `save_arcade_record`.
- Achievements `onipresente` (`game_category_variety`) and `distinct_games_all` (target 10) depend on category/game counts and need review in #168.
- Per-module achievements exist as `mod_<id>_first_sub` and `mod_<id>_complete` for every module (19 modules), so only 4 modules' pairs stay active.

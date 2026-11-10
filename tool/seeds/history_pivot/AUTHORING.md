# History trail authoring (#181)

How to author a new History trail so it appears in the app after migrations `01`/`02` are applied. Nothing here is applied by itself — each trail is its own numbered seed file.

## Shape (fixed)

| Layer | Count | Notes |
| --- | --- | --- |
| Module (`modulos`) | 1 | `categoria_id = 1`, unique `titulo`, emoji, cor, descricao, `ordem` |
| Levels (`niveis`) | 4 | `ordem` 1..4, title like `Nível 1 - …` |
| Submodules (`submodulos`) | 12 | 3 per level; `ordem` 1..12; set both `modulo_id` and `nivel_id` |
| Lessons (`licoes`) | 12 | 1 per submodule; `conteudo` must include `preview` (text) |
| Concepts (`concepts`) | 48 | 1 per pair; `status = 'active'` |
| Game items (`concept_game_items`) | 48 | 1 per concept; `active = true`; payload in `question_data` |
| Pairs (`submodulo_pares`) | 48 | 4 per submodule; join key is `(concept_id, game_type)` |

Images: `submodulos.imagem_url` points at the public bucket `trilhas-imagens`, e.g.
`https://mizgtuwtuaculchwizkm.supabase.co/storage/v1/object/public/trilhas-imagens/<slug>/<file>.png`.
Do **not** commit image binaries to the repo. Ask before uploading.

## Per-trail format mix (48 pairs)

| `game_type` | Count | Why |
| --- | --- | --- |
| `quiz-relampago` | 6 | Fast facts |
| `verdade-mito` | 6 | Myth-busting (Lume voice) |
| `linha-do-tempo` | 8 | Causality / sequence |
| `quem-sou-eu` | 8 | People & roles |
| `palavra_misteriosa` | 6 | Key terms |
| `completar_frase` | 6 | Structured recall |
| `batalha` | 4 | Thin today — lift intentionally |
| `conexao` | 4 | Thin today — lift intentionally |

Spread the 4 battles and 4 connections across different levels (not all in level 1).

### Expected History pool after 6 new trails

Existing (~192) + 6×48 = **480** items. Target totals from #181:

| Format | Target |
| --- | --- |
| quiz-relampago | 83 |
| verdade-mito | 73 |
| linha-do-tempo | 72 |
| quem-sou-eu | 71 |
| palavra_misteriosa | 55 |
| completar_frase | 54 |
| batalha | 40 |
| conexao | 32 |

## Payload conventions (copy from live items)

`validate_history_content.sql` is the source of truth. Summary of what `_map_game_payload` reads:

| Format | Required `question_data` keys |
| --- | --- |
| `quiz-relampago` | `enunciado`, `alternativas[]`, `correta` (**0-based index**), `explicacao` |
| `linha-do-tempo` | `situacao_inicial`, `alternativas[]`, `correta` (0-based), `tipo_relacao`, `explicacao` |
| `verdade-mito` | `texto`, `veredito` (`mito` / `verdade` / variants mapped by `_map_verdict`), `explicacao` |
| `quem-sou-eu` | `header`, `dica_1`..`dica_5` (min 3), `resposta_certa`, `sinonimos_aceitos[]`, `explicacao` |
| `completar_frase` | `sentenca`, `lacunas[{ordem, opcoes[], correta}]`, `explicacao` |
| `palavra_misteriosa` | `palavra`, `descricao`, `dica`, `explicacao` |
| `batalha` | `pergunta`, `opcao_a`, `opcao_b`, `correta` (`'a'` or `'b'`), `criterio_comparacao`, `explicacao` |
| `conexao` | `titulo`, `subtitulo`, `coluna_esquerda[{id,texto}]`, `coluna_direita[{id,texto}]`, `pares[{esquerda_id, direita_id, explicacao}]` — **every pair needs its own `explicacao`**; a top-level `explicacao` is never shown |

Also fill the sibling columns the app still reads: `prompt`, `correct_answer`, `feedback_correct`, `feedback_incorrect`. Mirror the explanation into `feedback_correct`; use a short fallback for `feedback_incorrect` ("Revise o conceito e tente de novo.").

`submodulo_pares` also needs: `preview_hook`, `content_type` (`conceito` / `evento` / `relacao`), `cognitive_demand` (`baixa` / `media` / `alta`), and usually `licao_id`.

## File layout per trail

```
tool/seeds/history_pivot/
  NN_trail_<slug>.sql            -- BEGIN; … COMMIT; idempotent
  NN_trail_<slug>.rollback.sql   -- removes exactly the rows this trail created
```

Suggested numbering (after Phase 1–2 + Connections fix):

| File | Issue |
| --- | --- |
| `04_trail_grecia_roma.sql` | #182 |
| `05_trail_idade_media.sql` | #183 |
| `06_trail_renascimento_navegacoes.sql` | #184 |
| `07_trail_era_revolucoes.sql` | #185 |
| `08_trail_brasil_republica.sql` | #186 |
| `09_trail_seculo_xx_guerras.sql` | #187 |
| `10_achievements_new_trails.sql` | #188 |

Use a stable slug prefix on `concepts.slug` (e.g. `gr-…`, `im-…`) so rollback can `DELETE` / deactivate by prefix without touching other content. Prefer hide (`status` / `active` = false) only if user progress already references the rows; otherwise delete the trail's own rows in rollback (new content, not pivot-hidden legacy).

Copy the insert pattern from `_trail_seed_skeleton.sql`.

## Suggested chronological `modulos.ordem`

After the 6 trails exist, History home order (proposal — confirm with product):

| ordem | Trail |
| --- | --- |
| 1 | Grécia e Roma Antigas |
| 2 | Idade Média |
| 3 | Renascimento e Grandes Navegações |
| 4 | Era das Revoluções |
| 5 | História do Brasil (1500–1889) — existing id 7 |
| 6 | Brasil República (1889 até hoje) |
| 7 | Século XX e as Guerras Mundiais |
| 8 | História Mundial — existing id 22 (panorama / review) |
| 9 | História da Arte — existing id 21 |
| 10 | História da Música — existing id 8 |

Re-number existing modules in the same transaction that inserts the new ones (or in `10_…`) so Home stays chronological.

## Overlap rules

- **História Mundial (22)** is a survey. New trails go *deep* on the same eras; do not clone its submodule titles or quiz hooks.
- **História do Brasil (7)** ends at 1889. Brasil República starts at the Proclamation and must not re-teach colonial/imperial chapters.
- **História da Arte (21)** owns art-as-language themes. Renascimento trail may mention artists only as historical actors (patronage, print, science), not as an art-history course.
- **História da Música (8)** owns period music. Other trails stay off genre chronology.

## Workflow (do not skip)

1. Outline 4 levels × 3 submodules → **owner approval**.
2. Author SQL from the skeleton; keep facts accurate (pt-BR); no invented history.
3. Run `validate_history_content.sql` → zero rows.
4. Dry-run: `BEGIN; \i NN_trail_….sql` body without COMMIT, then `RAISE EXCEPTION` with a JSON summary; confirm production unchanged.
5. Show owner the summary → apply only on go-ahead.
6. Images + achievements (`10_…`) after the six seeds exist.

## Content review checklist

- [ ] Facts checked against a reliable secondary source (textbook / encyclopaedia); no invented dates or quotes
- [ ] Brazilian Portuguese, same myth-busting voice as História Mundial
- [ ] Mix counts match the table above
- [ ] Every Connections pair has its own `explicacao`; titulo + subtitulo present
- [ ] `correta` index is 0-based; batalha uses `'a'`/`'b'`
- [ ] Lesson `conteudo.preview` filled; concept `status = 'active'`
- [ ] Submodule `imagem_url` set (placeholder OK until images land)
- [ ] Validator returns zero rows for the new module
- [ ] Rollback file removes exactly this trail's rows
- [ ] Image rights cleared before upload; binaries never committed

## Dry-run pattern

```sql
BEGIN;
-- paste the trail seed body (no inner COMMIT)
DO $$
DECLARE
  v jsonb;
BEGIN
  SELECT jsonb_build_object(
    'modules', (SELECT count(*) FROM modulos WHERE titulo = '<TRAIL TITLE>'),
    'submodules', (SELECT count(*) FROM submodulos s JOIN modulos m ON m.id = s.modulo_id WHERE m.titulo = '<TRAIL TITLE>'),
    'pairs', (SELECT count(*) FROM submodulo_pares sp JOIN submodulos s ON s.id = sp.submodulo_id JOIN modulos m ON m.id = s.modulo_id WHERE m.titulo = '<TRAIL TITLE>')
  ) INTO v;
  RAISE EXCEPTION 'VERIFY_RESULT %', v;
END $$;
-- never COMMIT
```

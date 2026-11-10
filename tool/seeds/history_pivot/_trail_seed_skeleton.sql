-- History pivot (#181) — reusable trail seed skeleton.
-- Copy to NN_trail_<slug>.sql and replace every <<PLACEHOLDER>>.
-- Idempotent via slug / title guards. One transaction. Pair with NN_trail_<slug>.rollback.sql.
-- DO NOT run this file as-is.

BEGIN;

-- ── 1. Module ──────────────────────────────────────────────────────────────
INSERT INTO public.modulos (ordem, titulo, emoji, cor, categoria_id, descricao)
SELECT <<ORDEM>>, '<<TITULO>>', '<<EMOJI>>', '<<COR>>', 1, '<<DESCRICAO>>'
WHERE NOT EXISTS (
  SELECT 1 FROM public.modulos WHERE titulo = '<<TITULO>>'
);

-- Bind the module id for the rest of the file.
CREATE TEMP TABLE _seed_trail AS
SELECT id AS modulo_id FROM public.modulos WHERE titulo = '<<TITULO>>';

-- ── 2. Levels (4) ──────────────────────────────────────────────────────────
INSERT INTO public.niveis (modulo_id, ordem, titulo)
SELECT t.modulo_id, v.ordem, v.titulo
FROM _seed_trail t
CROSS JOIN (VALUES
  (1, 'Nível 1 - <<NIVEL_1>>'),
  (2, 'Nível 2 - <<NIVEL_2>>'),
  (3, 'Nível 3 - <<NIVEL_3>>'),
  (4, 'Nível 4 - <<NIVEL_4>>')
) AS v(ordem, titulo)
WHERE NOT EXISTS (
  SELECT 1 FROM public.niveis n
  WHERE n.modulo_id = t.modulo_id AND n.ordem = v.ordem
);

-- ── 3. Submodules (12) ─────────────────────────────────────────────────────
-- imagem_url may be NULL until images are uploaded to trilhas-imagens/<slug>/.
INSERT INTO public.submodulos (modulo_id, nivel_id, ordem, titulo, data_liberacao_desde_inicio, imagem_url)
SELECT t.modulo_id, n.id, v.ordem, v.titulo, 0, v.imagem_url
FROM _seed_trail t
JOIN public.niveis n ON n.modulo_id = t.modulo_id AND n.ordem = v.nivel_ordem
CROSS JOIN (VALUES
  (1, 1,  '<<SUB_01>>', NULL::text),
  (1, 2,  '<<SUB_02>>', NULL),
  (1, 3,  '<<SUB_03>>', NULL),
  (2, 4,  '<<SUB_04>>', NULL),
  (2, 5,  '<<SUB_05>>', NULL),
  (2, 6,  '<<SUB_06>>', NULL),
  (3, 7,  '<<SUB_07>>', NULL),
  (3, 8,  '<<SUB_08>>', NULL),
  (3, 9,  '<<SUB_09>>', NULL),
  (4, 10, '<<SUB_10>>', NULL),
  (4, 11, '<<SUB_11>>', NULL),
  (4, 12, '<<SUB_12>>', NULL)
) AS v(nivel_ordem, ordem, titulo, imagem_url)
WHERE NOT EXISTS (
  SELECT 1 FROM public.submodulos s
  WHERE s.modulo_id = t.modulo_id AND s.ordem = v.ordem
);

-- ── 4. Lessons (12) — conteudo.preview is required ─────────────────────────
INSERT INTO public.licoes (submodulo_id, ordem, titulo, emoji, conteudo)
SELECT s.id, 1, s.titulo, '<<EMOJI>>',
       jsonb_build_object('preview', v.preview)
FROM _seed_trail t
JOIN public.submodulos s ON s.modulo_id = t.modulo_id
JOIN (VALUES
  (1,  '<<PREVIEW_01>>'),
  (2,  '<<PREVIEW_02>>'),
  (3,  '<<PREVIEW_03>>'),
  (4,  '<<PREVIEW_04>>'),
  (5,  '<<PREVIEW_05>>'),
  (6,  '<<PREVIEW_06>>'),
  (7,  '<<PREVIEW_07>>'),
  (8,  '<<PREVIEW_08>>'),
  (9,  '<<PREVIEW_09>>'),
  (10, '<<PREVIEW_10>>'),
  (11, '<<PREVIEW_11>>'),
  (12, '<<PREVIEW_12>>')
) AS v(sub_ordem, preview) ON v.sub_ordem = s.ordem
WHERE NOT EXISTS (
  SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id
);

-- ── 5. Concepts + game items + pairs (48) ──────────────────────────────────
-- Use a stable slug prefix (e.g. 'gr-') so rollback can target this trail only.
-- One row per pair. Pattern for a lightning quiz (repeat per game_type):

/*
WITH c AS (
  INSERT INTO public.concepts (title, slug, short_explanation, full_explanation, difficulty, content_type, status)
  SELECT '<<CONCEPT_TITLE>>', '<<SLUG_PREFIX>>-001', '<<SHORT>>', '<<FULL>>', 'medio', 'conceito', 'active'
  WHERE NOT EXISTS (SELECT 1 FROM public.concepts WHERE slug = '<<SLUG_PREFIX>>-001')
  RETURNING id
),
-- if the concept already existed, pick it up:
picked AS (
  SELECT id FROM c
  UNION ALL
  SELECT id FROM public.concepts WHERE slug = '<<SLUG_PREFIX>>-001' AND NOT EXISTS (SELECT 1 FROM c)
),
item AS (
  INSERT INTO public.concept_game_items (
    concept_id, game_type, prompt, question_data, correct_answer,
    feedback_correct, feedback_incorrect, difficulty, active
  )
  SELECT p.id, 'quiz-relampago',
         '<<ENUNCIADO>>',
         jsonb_build_object(
           'tipo', 'quiz_relampago',
           'enunciado', '<<ENUNCIADO>>',
           'alternativas', jsonb_build_array('A','B','C','D'),
           'correta', 0,          -- 0-based
           'explicacao', '<<EXPLICACAO>>'
         ),
         'A',
         '<<EXPLICACAO>>',
         'Revise o conceito e tente de novo.',
         'medio', true
  FROM picked p
  WHERE NOT EXISTS (
    SELECT 1 FROM public.concept_game_items cgi
    WHERE cgi.concept_id = p.id AND cgi.game_type = 'quiz-relampago'
  )
  RETURNING concept_id
)
INSERT INTO public.submodulo_pares (
  submodulo_id, ordem, preview_hook, game_type, content_type,
  cognitive_demand, concept_id, licao_id
)
SELECT s.id, <<PAIR_ORDEM>>, '<<PREVIEW_HOOK>>', 'quiz-relampago', 'conceito',
       'media', p.id, l.id
FROM picked p
JOIN _seed_trail t ON true
JOIN public.submodulos s ON s.modulo_id = t.modulo_id AND s.ordem = <<SUB_ORDEM>>
JOIN public.licoes l ON l.submodulo_id = s.id
WHERE NOT EXISTS (
  SELECT 1 FROM public.submodulo_pares sp
  WHERE sp.submodulo_id = s.id AND sp.ordem = <<PAIR_ORDEM>>
);
*/

-- Prefer generating the 48 blocks from a VALUES list in the real seed file
-- (see AUTHORING.md for per-format question_data shapes). Keep mix counts exact:
-- quiz 6, verdade-mito 6, timeline 8, who-am-I 8, palavra 6, completar 6, batalha 4, conexao 4.

-- ── 6. Verify inside the same transaction (optional assert) ────────────────
DO $$
DECLARE
  v_mod   bigint;
  v_subs  int;
  v_pairs int;
BEGIN
  SELECT modulo_id INTO v_mod FROM _seed_trail;
  SELECT count(*) INTO v_subs  FROM public.submodulos WHERE modulo_id = v_mod;
  SELECT count(*) INTO v_pairs FROM public.submodulo_pares sp
    JOIN public.submodulos s ON s.id = sp.submodulo_id WHERE s.modulo_id = v_mod;
  IF v_subs <> 12 OR v_pairs <> 48 THEN
    RAISE EXCEPTION 'trail seed incomplete: submodules=%, pairs=% (want 12/48)', v_subs, v_pairs;
  END IF;
END $$;

DROP TABLE _seed_trail;

COMMIT;

-- After apply (separate session): run validate_history_content.sql — expect 0 rows
-- for this module_id.

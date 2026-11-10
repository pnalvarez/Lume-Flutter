-- History pivot (#161) / #178: History content payload validator. READ-ONLY (plain SELECT).
-- Returns one row per problem found. Zero rows = every History game item is well formed.
-- Run:  supabase db query --linked -f tool/seeds/history_pivot/validate_history_content.sql
--
-- It checks the raw keys that public._map_game_payload() reads for each game format, on the
-- data AFTER _enrich_question_data_for_payload() (what get_submodule_games serves).
-- Scope: modules with categoria_id = 1 (History). Also run it after authoring each new trail.

WITH items AS (
  SELECT
    sp.id AS pair_id,
    s.id  AS submodule_id,
    m.id  AS module_id,
    m.titulo AS module_title,
    sp.game_type,
    public._map_game_format(sp.game_type) AS fmt,
    CASE WHEN cgi.id IS NULL THEN NULL
         ELSE public._enrich_question_data_for_payload(
                cgi.question_data, cgi.correct_answer, cgi.feedback_correct, cgi.feedback_incorrect)
    END AS q,
    cgi.id AS item_id
  FROM public.submodulo_pares sp
  JOIN public.submodulos s ON s.id = sp.submodulo_id
  JOIN public.modulos m    ON m.id = s.modulo_id
  LEFT JOIN public.concept_game_items cgi
    ON cgi.concept_id = sp.concept_id
   AND cgi.game_type = sp.game_type
   AND COALESCE(cgi.active, true)
  WHERE m.categoria_id = 1
),
-- Length of a jsonb array, 0 when the value is missing or not an array.
len AS (
  SELECT i.*,
    CASE WHEN jsonb_typeof(i.q->'alternativas') = 'array' THEN jsonb_array_length(i.q->'alternativas') ELSE 0 END AS n_alt,
    CASE WHEN jsonb_typeof(i.q->'lacunas')      = 'array' THEN jsonb_array_length(i.q->'lacunas')      ELSE 0 END AS n_blanks,
    CASE WHEN jsonb_typeof(i.q->'coluna_esquerda') = 'array' THEN jsonb_array_length(i.q->'coluna_esquerda') ELSE 0 END AS n_left,
    CASE WHEN jsonb_typeof(i.q->'coluna_direita')  = 'array' THEN jsonb_array_length(i.q->'coluna_direita')  ELSE 0 END AS n_right,
    CASE WHEN jsonb_typeof(i.q->'pares')           = 'array' THEN jsonb_array_length(i.q->'pares')           ELSE 0 END AS n_pairs,
    CASE WHEN (i.q->>'correta') ~ '^[0-9]+$' THEN (i.q->>'correta')::int ELSE NULL END AS correta_int
  FROM items i
)
SELECT l.module_id, l.submodule_id, l.pair_id, l.game_type, v.msg AS problem
FROM len l
CROSS JOIN LATERAL (VALUES
  -- Any format
  (l.item_id IS NULL,                                   'no active concept_game_items row for this pair'),
  (l.item_id IS NOT NULL AND (l.q IS NULL OR l.q = '{}'::jsonb), 'question_data is empty'),
  (l.fmt NOT IN ('battle_of_curiosities','mysterious_word','who_am_i','connections','timeline',
                 'true_or_myth','complete_sentence','lightning_quiz'),
                                                        'unknown game format "' || l.fmt || '"'),

  -- lightning_quiz
  (l.fmt = 'lightning_quiz' AND COALESCE(l.q->>'enunciado','') = '',  'lightning_quiz: enunciado is empty'),
  (l.fmt = 'lightning_quiz' AND l.n_alt < 2,                           'lightning_quiz: needs at least 2 alternativas'),
  (l.fmt = 'lightning_quiz' AND (l.correta_int IS NULL OR l.correta_int < 0 OR l.correta_int > l.n_alt),
                                                                       'lightning_quiz: correta is not a valid index'),
  (l.fmt = 'lightning_quiz' AND COALESCE(l.q->>'explicacao', l.q->>'explanation','') = '',
                                                                       'lightning_quiz: explicacao is empty'),

  -- timeline
  (l.fmt = 'timeline' AND COALESCE(l.q->>'situacao_inicial','') = '',  'timeline: situacao_inicial is empty'),
  (l.fmt = 'timeline' AND l.n_alt < 2,                                 'timeline: needs at least 2 alternativas'),
  (l.fmt = 'timeline' AND (l.correta_int IS NULL OR l.correta_int < 0 OR l.correta_int > l.n_alt),
                                                                       'timeline: correta is not a valid index'),
  (l.fmt = 'timeline' AND COALESCE(l.q->>'explicacao', l.q->>'explanation','') = '',
                                                                       'timeline: explicacao is empty'),

  -- true_or_myth
  (l.fmt = 'true_or_myth' AND COALESCE(l.q->>'texto','') = '',         'true_or_myth: texto is empty'),
  (l.fmt = 'true_or_myth' AND COALESCE(public._map_verdict(l.q->>'veredito'),'') = '',
                                                                       'true_or_myth: veredito does not map to a verdict'),
  (l.fmt = 'true_or_myth' AND COALESCE(l.q->>'explicacao', l.q->>'explanation','') = '',
                                                                       'true_or_myth: explicacao is empty'),

  -- who_am_i
  (l.fmt = 'who_am_i' AND COALESCE(l.q->>'header','') = '',            'who_am_i: header is empty'),
  (l.fmt = 'who_am_i' AND COALESCE(l.q->>'resposta_certa', l.q->>'correct_answer','') = '',
                                                                       'who_am_i: resposta_certa is empty'),
  (l.fmt = 'who_am_i' AND (
     (CASE WHEN COALESCE(l.q->>'dica_1','') <> '' THEN 1 ELSE 0 END) +
     (CASE WHEN COALESCE(l.q->>'dica_2','') <> '' THEN 1 ELSE 0 END) +
     (CASE WHEN COALESCE(l.q->>'dica_3','') <> '' THEN 1 ELSE 0 END) +
     (CASE WHEN COALESCE(l.q->>'dica_4','') <> '' THEN 1 ELSE 0 END) +
     (CASE WHEN COALESCE(l.q->>'dica_5','') <> '' THEN 1 ELSE 0 END)) < 3,
                                                                       'who_am_i: needs at least 3 dicas'),

  -- complete_sentence
  (l.fmt = 'complete_sentence' AND COALESCE(l.q->>'sentenca','') = '', 'complete_sentence: sentenca is empty'),
  (l.fmt = 'complete_sentence' AND l.n_blanks < 1,                     'complete_sentence: needs at least 1 lacuna'),
  (l.fmt = 'complete_sentence' AND l.n_blanks >= 1 AND EXISTS (
     SELECT 1 FROM jsonb_array_elements(l.q->'lacunas') b
     WHERE jsonb_typeof(b->'opcoes') IS DISTINCT FROM 'array'
        OR jsonb_array_length(CASE WHEN jsonb_typeof(b->'opcoes') = 'array' THEN b->'opcoes' ELSE '[]'::jsonb END) < 2
        OR NOT (CASE WHEN jsonb_typeof(b->'opcoes') = 'array' THEN b->'opcoes' ELSE '[]'::jsonb END
                @> to_jsonb(b->>'correta'))),
                                                                       'complete_sentence: a lacuna has <2 opcoes or its correta is not among them'),

  -- mysterious_word
  (l.fmt = 'mysterious_word' AND COALESCE(l.q->>'palavra','') = '',    'mysterious_word: palavra is empty'),
  (l.fmt = 'mysterious_word' AND COALESCE(l.q->>'descricao','') = '',  'mysterious_word: descricao is empty'),
  (l.fmt = 'mysterious_word' AND COALESCE(l.q->>'dica','') = '',       'mysterious_word: dica is empty'),

  -- battle_of_curiosities
  (l.fmt = 'battle_of_curiosities' AND COALESCE(l.q->>'pergunta','') = '', 'battle: pergunta is empty'),
  (l.fmt = 'battle_of_curiosities' AND (COALESCE(l.q->>'opcao_a','') = '' OR COALESCE(l.q->>'opcao_b','') = ''),
                                                                       'battle: opcao_a / opcao_b is empty'),
  (l.fmt = 'battle_of_curiosities' AND lower(COALESCE(l.q->>'correta','')) NOT IN ('a','b'),
                                                                       'battle: correta must be a or b'),

  -- connections
  (l.fmt = 'connections' AND (l.n_left < 2 OR l.n_right < 2),          'connections: needs at least 2 items per column'),
  (l.fmt = 'connections' AND l.n_left <> l.n_right,                    'connections: columns have different sizes'),
  (l.fmt = 'connections' AND l.n_pairs <> l.n_left,                    'connections: number of pares differs from column size'),
  (l.fmt = 'connections' AND l.n_pairs > 0 AND EXISTS (
     SELECT 1 FROM jsonb_array_elements(l.q->'pares') p
     WHERE NOT EXISTS (SELECT 1 FROM jsonb_array_elements(COALESCE(l.q->'coluna_esquerda','[]'::jsonb)) a
                       WHERE a->>'id' = p->>'esquerda_id')
        OR NOT EXISTS (SELECT 1 FROM jsonb_array_elements(COALESCE(l.q->'coluna_direita','[]'::jsonb)) b
                       WHERE b->>'id' = p->>'direita_id')),
                                                                       'connections: a par points to an id missing from its column'),
  (l.fmt = 'connections' AND EXISTS (
     SELECT 1 FROM jsonb_array_elements(COALESCE(l.q->'coluna_esquerda','[]'::jsonb) || COALESCE(l.q->'coluna_direita','[]'::jsonb)) x
     WHERE COALESCE(x->>'texto','') = ''),
                                                                       'connections: an item has empty texto'),
  -- Standard added in #179: players must not see the generic fallback title, and every
  -- pair needs its own explicacao (the payload mapper ignores a top-level explicacao).
  (l.fmt = 'connections' AND (COALESCE(l.q->>'titulo','') = '' OR COALESCE(l.q->>'subtitulo','') = ''),
                                                                       'connections: titulo / subtitulo missing (player sees the generic fallback)'),
  (l.fmt = 'connections' AND l.n_pairs > 0 AND EXISTS (
     SELECT 1 FROM jsonb_array_elements(l.q->'pares') p WHERE COALESCE(p->>'explicacao','') = ''),
                                                                       'connections: a par has no explicacao (top-level explicacao is never shown)')
) AS v(failed, msg)
WHERE v.failed
ORDER BY l.module_id, l.submodule_id, l.pair_id, v.msg;

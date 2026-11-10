-- History pivot (#161) Phase 1: #164, #165, #166, #167.
-- Scopes the trail/game RPCs to History (categorias.id = 1). Nothing is deleted.
-- Apply TOGETHER with Phase 2 (02_*.sql). Rollback: snapshots/00_pre_pivot_rpcs.sql
-- then 01_history_scope_rpcs.rollback.sql.
--
-- Design: one rule (_app_category_id) + one helper (_is_app_modulo). Every RPC asks the
-- helper, so changing the app's scope later means editing a single function.

BEGIN;

-- #164: the single scope rule.
CREATE OR REPLACE FUNCTION public._app_category_id()
 RETURNS bigint
 LANGUAGE sql
 IMMUTABLE
AS $$ SELECT 1::bigint $$;

-- True when the module belongs to the app's category. NULL module ids and
-- category-less modules (categoria_id IS NULL) are NOT visible.
CREATE OR REPLACE FUNCTION public._is_app_modulo(p_modulo_id bigint)
 RETURNS boolean
 LANGUAGE sql
 STABLE
 SET search_path TO 'public'
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.modulos m
    WHERE m.id = p_modulo_id
      AND m.categoria_id = public._app_category_id()
  )
$$;

-- #165: get_game_trails. Only visible modules are returned.
CREATE OR REPLACE FUNCTION public.get_game_trails()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public._require_auth_uid();

  RETURN COALESCE((
    SELECT jsonb_agg(modulo_row ORDER BY sort_order)
    FROM (
      SELECT
        m.ordem AS sort_order,
        jsonb_build_object(
          'id', m.id,
          'title', m.titulo,
          'emoji', m.emoji,
          'sort_order', m.ordem,
          'levels', COALESCE((
            SELECT jsonb_agg(nivel_row ORDER BY n_ordem)
            FROM (
              SELECT
                n.ordem AS n_ordem,
                jsonb_build_object(
                  'id', n.id,
                  'title', n.titulo,
                  'sort_order', n.ordem,
                  'submodules', COALESCE((
                    SELECT jsonb_agg(sub_row ORDER BY s_ordem)
                    FROM (
                      SELECT
                        s.ordem AS s_ordem,
                        jsonb_build_object(
                          'id', s.id,
                          'title', s.titulo,
                          'sort_order', s.ordem,
                          'image_url', s.imagem_url,
                          'preview', COALESCE(
                            (
                              SELECT l.conteudo->>'preview'
                              FROM public.licoes l
                              WHERE l.submodulo_id = s.id
                                AND nullif(l.conteudo->>'preview', '') IS NOT NULL
                              ORDER BY l.ordem
                              LIMIT 1
                            ),
                            (
                              SELECT p.preview_hook
                              FROM public.submodulo_pares p
                              WHERE p.submodulo_id = s.id
                                AND nullif(p.preview_hook, '') IS NOT NULL
                              ORDER BY p.ordem
                              LIMIT 1
                            ),
                            ''
                          ),
                          'games', COALESCE((
                            SELECT jsonb_agg(jsonb_build_object(
                              'pair_id', p.id,
                              'sort_order', p.ordem,
                              'game_type', p.game_type,
                              'game_format', public._map_game_format(p.game_type),
                              'concept_id', p.concept_id,
                              'question_data', cgi.question_data,
                              'game_payload', public._map_game_payload(
                                p.game_type,
                                COALESCE(cgi.question_data, '{}'::jsonb)
                                  || jsonb_strip_nulls(jsonb_build_object('prompt', cgi.prompt))
                              )
                            ) ORDER BY p.ordem)
                            FROM public.submodulo_pares p
                            LEFT JOIN public.concept_game_items cgi
                              ON cgi.concept_id = p.concept_id
                             AND cgi.game_type = p.game_type
                             AND COALESCE(cgi.active, true)
                            WHERE p.submodulo_id = s.id
                          ), '[]'::jsonb)
                        ) AS sub_row
                      FROM public.submodulos s
                      WHERE s.nivel_id = n.id
                    ) subs
                  ), '[]'::jsonb)
                ) AS nivel_row
              FROM public.niveis n
              WHERE n.modulo_id = m.id
            ) niveis
          ), '[]'::jsonb)
        ) AS modulo_row
      FROM public.modulos m
      WHERE public._is_app_modulo(m.id)
    ) modulos
  ), '[]'::jsonb);
END;
$function$;

-- #165: get_trail_bootstrap. Modules, categories, levels, submodules, lessons, quiz
-- questions and pairs are all limited to visible modules. Progress lists are left
-- as-is (they only reference ids the client no longer receives).
CREATE OR REPLACE FUNCTION public.get_trail_bootstrap()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  uid uuid := public._require_auth_uid();
  started_at timestamptz;
BEGIN
  started_at := public.ensure_trail_start();

  RETURN jsonb_build_object(
    'trail_started_at', started_at,
    'modules', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', m.id,
        'sort_order', m.ordem,
        'title', m.titulo,
        'emoji', m.emoji,
        'color', m.cor,
        'category_id', m.categoria_id,
        'description', m.descricao
      ) ORDER BY m.ordem)
      FROM public.modulos m
      WHERE public._is_app_modulo(m.id)
    ), '[]'::jsonb),
    -- Older app versions still read this list; it now holds only the app category.
    'categories', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', c.id, 'name', c.nome) ORDER BY c.nome)
      FROM public.categorias c
      WHERE c.id = public._app_category_id()
    ), '[]'::jsonb),
    'levels', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', n.id,
        'module_id', n.modulo_id,
        'sort_order', n.ordem,
        'title', n.titulo
      ) ORDER BY n.ordem)
      FROM public.niveis n
      WHERE public._is_app_modulo(n.modulo_id)
    ), '[]'::jsonb),
    'submodules', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', s.id,
        'module_id', s.modulo_id,
        'level_id', s.nivel_id,
        'sort_order', s.ordem,
        'title', s.titulo,
        'unlock_days_from_start', s.data_liberacao_desde_inicio,
        'image_url', s.imagem_url
      ) ORDER BY s.ordem)
      FROM public.submodulos s
      WHERE public._is_app_modulo(s.modulo_id)
    ), '[]'::jsonb),
    'lessons', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', l.id,
        'submodule_id', l.submodulo_id,
        'sort_order', l.ordem,
        'title', l.titulo,
        'emoji', l.emoji,
        'content', l.conteudo,
        'main_content', l.conteudo_principal,
        'practical_example', l.exemplo_pratico,
        'common_mistake', l.erro_comum,
        'content_image_url', l.url_imagem_conteudo
      ) ORDER BY l.ordem)
      FROM public.licoes l
      WHERE EXISTS (
        SELECT 1 FROM public.submodulos s
        WHERE s.id = l.submodulo_id AND public._is_app_modulo(s.modulo_id)
      )
    ), '[]'::jsonb),
    'quiz_questions', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', q.id,
        'submodule_id', q.submodulo_id,
        'level_id', q.nivel_id,
        'sort_order', q.ordem,
        'prompt', q.enunciado,
        'options', q.opcoes,
        'image_url', q.url_imagem_quiz
      ) ORDER BY q.ordem)
      FROM public.perguntas_quiz q
      WHERE EXISTS (
        SELECT 1 FROM public.submodulos s
        WHERE s.id = q.submodulo_id AND public._is_app_modulo(s.modulo_id)
      )
      OR EXISTS (
        SELECT 1 FROM public.niveis n
        WHERE n.id = q.nivel_id AND public._is_app_modulo(n.modulo_id)
      )
    ), '[]'::jsonb),
    'submodule_pairs', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'id', p.id,
        'submodule_id', p.submodulo_id,
        'sort_order', p.ordem,
        'preview_hook', p.preview_hook,
        'game_type', p.game_type,
        'game_format', public._map_game_format(p.game_type),
        'content_type', p.content_type,
        'cognitive_demand', p.cognitive_demand,
        'concept_id', p.concept_id,
        'lesson_id', p.licao_id,
        'created_at', p.created_at
      ) ORDER BY p.ordem)
      FROM public.submodulo_pares p
      WHERE EXISTS (
        SELECT 1 FROM public.submodulos s
        WHERE s.id = p.submodulo_id AND public._is_app_modulo(s.modulo_id)
      )
    ), '[]'::jsonb),
    'lesson_progress', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'lesson_id', pl.licao_id,
        'completed_at', pl.concluido_em
      ))
      FROM public.progresso_licao pl
      WHERE pl.user_id = uid AND pl.concluido = true
    ), '[]'::jsonb),
    'level_progress', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'level_id', pn.nivel_id,
        'quiz_score', pn.quiz_acerto,
        'completed', pn.concluido,
        'completed_at', pn.concluido_em
      ))
      FROM public.progresso_nivel pn
      WHERE pn.user_id = uid
    ), '[]'::jsonb),
    'pair_progress', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'pair_id', pp.par_id,
        'preview_seen', pp.preview_visto,
        'score_pct', pp.score_pct,
        'completed', pp.concluido,
        'updated_at', pp.updated_at
      ))
      FROM public.progresso_par pp
      WHERE pp.user_id = uid
    ), '[]'::jsonb)
  );
END;
$function$;

-- #166: get_game_round. Questions are drawn only from visible submodules.
CREATE OR REPLACE FUNCTION public.get_game_round(p_game_slug text, p_limit integer DEFAULT 5)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  target_format text;
  game_row public.games%ROWTYPE;
  limit_n int := GREATEST(1, LEAST(COALESCE(p_limit, 5), 10));
BEGIN
  PERFORM public._require_auth_uid();

  IF nullif(trim(p_game_slug), '') IS NULL THEN
    RAISE EXCEPTION 'missing required parameter: p_game_slug' USING ERRCODE = '22023';
  END IF;

  SELECT * INTO game_row FROM public.games g WHERE g.slug = p_game_slug AND g.is_active = true;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'game not found' USING ERRCODE = 'P0002';
  END IF;

  target_format := public._map_hub_slug_to_format(p_game_slug);
  IF target_format IS NULL THEN
    RETURN jsonb_build_object('game_slug', game_row.slug, 'game_name', game_row.name, 'games', '[]'::jsonb);
  END IF;

  RETURN jsonb_build_object(
    'game_slug', game_row.slug,
    'game_name', game_row.name,
    'games', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'pair_id', picked.pair_id,
        'sort_order', picked.sort_order,
        'game_type', picked.game_type,
        'game_format', picked.game_format,
        'concept_id', picked.concept_id,
        'game_payload', picked.game_payload
      ) ORDER BY picked.sort_order)
      FROM (
        SELECT
          p.id AS pair_id,
          row_number() OVER (ORDER BY random())::int AS sort_order,
          p.game_type,
          public._map_game_format(p.game_type) AS game_format,
          p.concept_id,
          public._map_game_payload(
            p.game_type,
            public._enrich_question_data_for_payload(
              cgi.question_data, cgi.correct_answer, cgi.feedback_correct, cgi.feedback_incorrect
            )
          ) AS game_payload
        FROM public.submodulo_pares p
        INNER JOIN public.submodulos s ON s.id = p.submodulo_id
        INNER JOIN public.concept_game_items cgi
          ON cgi.concept_id = p.concept_id AND cgi.game_type = p.game_type AND COALESCE(cgi.active, true)
        WHERE public._map_game_format(p.game_type) = target_format
          AND cgi.question_data IS NOT NULL
          AND public._is_app_modulo(s.modulo_id)
        ORDER BY random()
        LIMIT limit_n
      ) picked
    ), '[]'::jsonb)
  );
END;
$function$;

-- #166: get_random_game_round. Both the "is this format playable?" check and the
-- final pick only consider visible submodules.
CREATE OR REPLACE FUNCTION public.get_random_game_round(p_enabled_slugs text[] DEFAULT NULL::text[])
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_format text;
  game_row public.games%ROWTYPE;
  v_empty jsonb := jsonb_build_object(
    'game_slug', '',
    'game_name', '',
    'games', '[]'::jsonb
  );
BEGIN
  PERFORM public._require_auth_uid();

  WITH playable AS (
    SELECT DISTINCT public._map_hub_slug_to_format(g.slug) AS fmt
    FROM public.games g
    WHERE g.is_active = true
      AND g.slug IS DISTINCT FROM 'galeria_conhecimento'
      AND public._map_hub_slug_to_format(g.slug) IS NOT NULL
      AND (
        p_enabled_slugs IS NULL
        OR g.slug = ANY (p_enabled_slugs)
      )
  )
  SELECT p.fmt INTO v_format
  FROM playable p
  WHERE EXISTS (
    SELECT 1
    FROM public.submodulo_pares sp
    INNER JOIN public.submodulos s ON s.id = sp.submodulo_id
    INNER JOIN public.concept_game_items cgi
      ON cgi.concept_id = sp.concept_id
     AND cgi.game_type = sp.game_type
     AND COALESCE(cgi.active, true)
    WHERE public._map_game_format(sp.game_type) = p.fmt
      AND cgi.question_data IS NOT NULL
      AND public._is_app_modulo(s.modulo_id)
  )
  ORDER BY random()
  LIMIT 1;

  IF v_format IS NULL THEN
    RETURN v_empty;
  END IF;

  -- Display name comes from an allowlisted active slug for that format.
  SELECT * INTO game_row
  FROM public.games g
  WHERE g.is_active = true
    AND g.slug IS DISTINCT FROM 'galeria_conhecimento'
    AND public._map_hub_slug_to_format(g.slug) = v_format
    AND (
      p_enabled_slugs IS NULL
      OR g.slug = ANY (p_enabled_slugs)
    )
  ORDER BY random()
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN v_empty;
  END IF;

  RETURN jsonb_build_object(
    'game_slug', game_row.slug,
    'game_name', game_row.name,
    'games', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'pair_id', picked.pair_id,
          'sort_order', picked.sort_order,
          'game_type', picked.game_type,
          'game_format', picked.game_format,
          'concept_id', picked.concept_id,
          'game_payload', picked.game_payload
        )
      )
      FROM (
        SELECT
          p.id AS pair_id,
          1::int AS sort_order,
          p.game_type,
          public._map_game_format(p.game_type) AS game_format,
          p.concept_id,
          public._map_game_payload(p.game_type, cgi.question_data) AS game_payload
        FROM public.submodulo_pares p
        INNER JOIN public.submodulos s ON s.id = p.submodulo_id
        INNER JOIN public.concept_game_items cgi
          ON cgi.concept_id = p.concept_id
         AND cgi.game_type = p.game_type
         AND COALESCE(cgi.active, true)
        WHERE public._map_game_format(p.game_type) = v_format
          AND cgi.question_data IS NOT NULL
          AND public._is_app_modulo(s.modulo_id)
        ORDER BY random()
        LIMIT 1
      ) picked
    ), '[]'::jsonb)
  );
END;
$function$;

-- #167: get_submodule_games. A hidden submodule is reported as "not found" (same error
-- as a missing id), so old links and modified clients learn nothing about hidden content.
CREATE OR REPLACE FUNCTION public.get_submodule_games(p_submodulo_id bigint DEFAULT NULL::bigint, p_submodule_id bigint DEFAULT NULL::bigint)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  submodule_id bigint := COALESCE(p_submodule_id, p_submodulo_id);
  result jsonb;
BEGIN
  PERFORM public._require_auth_uid();

  IF submodule_id IS NULL THEN
    RAISE EXCEPTION 'missing required parameter: p_submodule_id or p_submodulo_id'
      USING ERRCODE = '22023';
  END IF;

  SELECT jsonb_build_object(
    'id', s.id,
    'title', s.titulo,
    'sort_order', s.ordem,
    'image_url', s.imagem_url,
    'level_id', s.nivel_id,
    'module_id', s.modulo_id,
    'preview', COALESCE(
      (SELECT l.conteudo->>'preview' FROM public.licoes l WHERE l.submodulo_id = s.id AND nullif(l.conteudo->>'preview', '') IS NOT NULL ORDER BY l.ordem LIMIT 1),
      (SELECT p.preview_hook FROM public.submodulo_pares p WHERE p.submodulo_id = s.id AND nullif(p.preview_hook, '') IS NOT NULL ORDER BY p.ordem LIMIT 1),
      ''
    ),
    'games', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'pair_id', p.id,
        'sort_order', p.ordem,
        'game_type', p.game_type,
        'game_format', public._map_game_format(p.game_type),
        'concept_id', p.concept_id,
        'question_data', cgi.question_data,
        'game_payload', public._map_game_payload(
          p.game_type,
          public._enrich_question_data_for_payload(
            cgi.question_data, cgi.correct_answer, cgi.feedback_correct, cgi.feedback_incorrect
          )
        )
      ) ORDER BY p.ordem)
      FROM public.submodulo_pares p
      LEFT JOIN public.concept_game_items cgi
        ON cgi.concept_id = p.concept_id AND cgi.game_type = p.game_type AND COALESCE(cgi.active, true)
      WHERE p.submodulo_id = s.id
    ), '[]'::jsonb)
  )
  INTO result
  FROM public.submodulos s
  WHERE s.id = submodule_id
    AND public._is_app_modulo(s.modulo_id);

  IF result IS NULL THEN
    RAISE EXCEPTION 'submodule not found' USING ERRCODE = 'P0002';
  END IF;

  RETURN result;
END;
$function$;

COMMIT;

-- Verify after applying (run as an authenticated user, or via SQL editor for counts):
--   SELECT count(*) FROM modulos WHERE _is_app_modulo(id);              -- 4 (10 after the new trails)
--   SELECT count(*) FROM modulos WHERE NOT _is_app_modulo(id);          -- 15, hidden but still in the table
--   SELECT jsonb_array_length(get_game_trails());                        -- 4
--   SELECT jsonb_array_length(get_trail_bootstrap()->'modules');         -- 4
--   SELECT get_submodule_games(<id of a hidden submodule>);              -- error P0002 'submodule not found'

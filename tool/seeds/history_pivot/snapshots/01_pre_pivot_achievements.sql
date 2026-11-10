-- History pivot (#161) / #162: pre-pivot snapshot of the Phase 2 RPCs.
-- Project: mizgtuwtuaculchwizkm. Captured 2026-11-07 via pg_get_functiondef.
-- ROLLBACK: running this file restores check_achievements and get_profile.

CREATE OR REPLACE FUNCTION public.check_achievements(p_user_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  rec record;
  v_progress int;
  v_completed_now uuid[] := ARRAY[]::uuid[];
  v_unlocked jsonb := '[]'::jsonb;
  v_streak int;
  v_card_id uuid;
  v_today date;
  v_week date;
  v_modulo_id bigint;
  v_game_slug text;
BEGIN
  IF p_user_id IS NULL THEN
    RETURN jsonb_build_object('completed', '[]'::jsonb, 'unlocked', '[]'::jsonb);
  END IF;

  SELECT current_streak INTO v_streak FROM public.profiles WHERE id = p_user_id;
  v_today := (now() AT TIME ZONE 'America/Sao_Paulo')::date;
  v_week := v_today - ((EXTRACT(ISODOW FROM v_today)::int) - 1);

  FOR rec IN SELECT * FROM public.achievements WHERE is_active LOOP
    v_progress := 0;
    v_modulo_id := NULLIF(rec.condition_metadata->>'modulo_id', '')::bigint;
    v_game_slug := NULLIF(rec.condition_metadata->>'game_slug', '');

    CASE rec.condition_type
      WHEN 'cards_completed' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.progresso_licao
        WHERE user_id = p_user_id AND concluido = true;
      WHEN 'curiosities_opened' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.progresso_licao
        WHERE user_id = p_user_id AND curiosity_opened = true;
      WHEN 'myths_opened' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.progresso_licao
        WHERE user_id = p_user_id AND myth_opened = true;
      WHEN 'submodules_completed' THEN
        SELECT COUNT(DISTINCT s.id) INTO v_progress
        FROM public.submodulos s
        WHERE EXISTS (SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id)
          AND NOT EXISTS (
            SELECT 1 FROM public.licoes l
            WHERE l.submodulo_id = s.id
              AND NOT EXISTS (
                SELECT 1 FROM public.progresso_licao pl
                WHERE pl.user_id = p_user_id
                  AND pl.licao_id = l.id
                  AND pl.concluido = true
              )
          );
      WHEN 'trail_submodules_completed' THEN
        SELECT COUNT(*)::int INTO v_progress
        FROM public._user_completed_submodule_ids(p_user_id);
      WHEN 'trail_modules_completed' THEN
        SELECT COUNT(*)::int INTO v_progress
        FROM public.modulos m
        WHERE EXISTS (
          SELECT 1
          FROM public.submodulos s
          WHERE s.modulo_id = m.id
            AND (
              EXISTS (SELECT 1 FROM public.submodulo_pares sp WHERE sp.submodulo_id = s.id)
              OR EXISTS (SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id)
            )
        )
        AND NOT EXISTS (
          SELECT 1
          FROM public.submodulos s
          WHERE s.modulo_id = m.id
            AND (
              EXISTS (SELECT 1 FROM public.submodulo_pares sp WHERE sp.submodulo_id = s.id)
              OR EXISTS (SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id)
            )
            AND NOT EXISTS (
              SELECT 1
              FROM public._user_completed_submodule_ids(p_user_id) c
              WHERE c.submodulo_id = s.id
            )
        );
      WHEN 'trail_module_submodules_completed' THEN
        IF v_modulo_id IS NULL THEN
          v_progress := 0;
        ELSE
          SELECT COUNT(*)::int INTO v_progress
          FROM public._user_completed_submodule_ids(p_user_id) c
          JOIN public.submodulos s ON s.id = c.submodulo_id
          WHERE s.modulo_id = v_modulo_id;
        END IF;
      WHEN 'trail_module_fully_completed' THEN
        IF v_modulo_id IS NULL THEN
          v_progress := 0;
        ELSIF EXISTS (
          SELECT 1
          FROM public.submodulos s
          WHERE s.modulo_id = v_modulo_id
            AND (
              EXISTS (SELECT 1 FROM public.submodulo_pares sp WHERE sp.submodulo_id = s.id)
              OR EXISTS (SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id)
            )
        )
        AND NOT EXISTS (
          SELECT 1
          FROM public.submodulos s
          WHERE s.modulo_id = v_modulo_id
            AND (
              EXISTS (SELECT 1 FROM public.submodulo_pares sp WHERE sp.submodulo_id = s.id)
              OR EXISTS (SELECT 1 FROM public.licoes l WHERE l.submodulo_id = s.id)
            )
            AND NOT EXISTS (
              SELECT 1
              FROM public._user_completed_submodule_ids(p_user_id) c
              WHERE c.submodulo_id = s.id
            )
        ) THEN
          v_progress := 1;
        ELSE
          v_progress := 0;
        END IF;
      WHEN 'arcade_best_rounds' THEN
        SELECT COALESCE(ar.best_rounds, 0) INTO v_progress
        FROM public.arcade_records ar
        WHERE ar.user_id = p_user_id;
        v_progress := COALESCE(v_progress, 0);
      WHEN 'levels_completed' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.progresso_nivel
        WHERE user_id = p_user_id AND concluido = true;
      WHEN 'review_quiz_perfect' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.progresso_nivel
        WHERE user_id = p_user_id AND quiz_acerto = 100;
      WHEN 'streak_days' THEN
        v_progress := COALESCE(v_streak, 0);
      WHEN 'collectibles_unlocked' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.user_collectibles
        WHERE user_id = p_user_id;
      WHEN 'total_game_matches' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.game_matches
        WHERE user_id = p_user_id AND finished_at IS NOT NULL;
      WHEN 'game_matches_finished' THEN
        SELECT COUNT(*)::int INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id
          AND m.finished_at IS NOT NULL
          AND (v_game_slug IS NULL OR g.slug = v_game_slug);
      WHEN 'game_perfect_matches' THEN
        SELECT COUNT(*)::int INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id
          AND m.finished_at IS NOT NULL
          AND COALESCE(m.total_questions, 0) > 0
          AND m.correct_count = m.total_questions
          AND (v_game_slug IS NULL OR g.slug = v_game_slug);
      WHEN 'distinct_games_played' THEN
        SELECT COUNT(DISTINCT m.game_id)::int INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id
          AND m.finished_at IS NOT NULL
          AND g.is_active = true;
      WHEN 'quiz_relampago_max_multiplier' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id
          AND g.slug = 'quiz_relampago'
          AND COALESCE((m.metadata->>'max_multiplier')::numeric, 0) >= 3.0;
      WHEN 'leilao_zero_hint_streak' THEN
        SELECT COALESCE(MAX(COALESCE((m.metadata->>'zero_hint_streak')::int, 0)), 0)
          INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id AND g.slug = 'leilao_dicas';
      WHEN 'league_promotion' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.user_league_membership
        WHERE user_id = p_user_id AND promoted = true;
      WHEN 'game_category_variety' THEN
        SELECT COUNT(DISTINCT g.category) INTO v_progress
        FROM public.game_matches m
        JOIN public.games g ON g.id = m.game_id
        WHERE m.user_id = p_user_id
          AND m.finished_at IS NOT NULL
          AND g.is_active = true
          AND (m.finished_at AT TIME ZONE 'America/Sao_Paulo')::date >= v_week;
      WHEN 'museum_total_merges' THEN
        SELECT COALESCE(total_merges, 0) INTO v_progress
        FROM public.museum_user_state
        WHERE user_id = p_user_id;
      WHEN 'museum_items_discovered' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.user_discovered_items
        WHERE user_id = p_user_id;
      WHEN 'museum_rooms_completed' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.user_room_progress
        WHERE user_id = p_user_id AND progress_percent >= 100;
      WHEN 'museum_chain_completed' THEN
        SELECT COUNT(*) INTO v_progress FROM (
          SELECT mi.chain_slug,
                 COUNT(*) FILTER (WHERE udi.user_id = p_user_id) AS discovered,
                 COUNT(*) AS total
          FROM public.museum_items mi
          LEFT JOIN public.user_discovered_items udi
            ON udi.museum_item_id = mi.id AND udi.user_id = p_user_id
          GROUP BY mi.chain_slug
        ) t WHERE t.discovered >= t.total AND t.total = 8;
      WHEN 'museum_generator_uses' THEN
        SELECT COUNT(*) INTO v_progress
        FROM public.xp_events
        WHERE user_id = p_user_id
          AND event_type IN ('museum_generator_use', 'museum_item_discovered');
      ELSE
        v_progress := 0;
    END CASE;

    INSERT INTO public.user_achievements(user_id, achievement_id, progress)
    VALUES (p_user_id, rec.id, v_progress)
    ON CONFLICT (user_id, achievement_id) DO UPDATE SET
      progress = GREATEST(public.user_achievements.progress, EXCLUDED.progress);

    IF v_progress >= rec.condition_target THEN
      v_card_id := NULL;
      UPDATE public.user_achievements
        SET completed_at = COALESCE(completed_at, now())
      WHERE user_id = p_user_id
        AND achievement_id = rec.id
        AND completed_at IS NULL
      RETURNING achievement_id INTO v_card_id;

      IF v_card_id IS NOT NULL THEN
        v_completed_now := array_append(v_completed_now, v_card_id);

        INSERT INTO public.player_achievement_events (
          user_id, achievement_id, code, name, icon
        ) VALUES (
          p_user_id, rec.id, rec.code, rec.name, rec.icon
        );

        v_unlocked := v_unlocked || jsonb_build_array(
          jsonb_build_object(
            'id', rec.id,
            'code', rec.code,
            'name', rec.name,
            'description', rec.description,
            'icon', rec.icon
          )
        );

        IF rec.reward_type = 'xp' THEN
          PERFORM public.award_xp(
            p_user_id,
            COALESCE(rec.reward_amount, 0),
            'achievement_' || rec.code,
            'ach-' || rec.id::text,
            NULL
          );
        ELSIF rec.reward_type = 'chest' THEN
          PERFORM public.grant_chest(
            p_user_id,
            COALESCE(rec.reward_metadata->>'chest_type', 'comum'),
            'achievement',
            rec.id::text
          );
        ELSIF rec.reward_type = 'collectible' THEN
          PERFORM public.award_collectible(
            p_user_id,
            public.pick_random_card_for_user(
              p_user_id,
              COALESCE(rec.reward_metadata->>'rarity', 'rara')
            ),
            'achievement:' || rec.code
          );
        ELSIF rec.reward_type = 'title' THEN
          PERFORM public.award_title(
            p_user_id,
            (SELECT id FROM public.titles
             WHERE code = (rec.reward_metadata->>'title_code') LIMIT 1)
          );
        ELSIF rec.reward_type = 'streak_shield' THEN
          UPDATE public.profiles
            SET streak_shields = LEAST(3, COALESCE(streak_shields, 0) + 1)
          WHERE id = p_user_id;
        END IF;

        UPDATE public.user_achievements
          SET reward_claimed_at = now()
        WHERE user_id = p_user_id
          AND achievement_id = rec.id
          AND reward_claimed_at IS NULL;
      END IF;
    END IF;
  END LOOP;

  RETURN jsonb_build_object(
    'completed', to_jsonb(v_completed_now),
    'unlocked', v_unlocked
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.get_profile()
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  uid uuid := public._require_auth_uid();
  v_progress record;
  v_today date := (now() AT TIME ZONE 'America/Sao_Paulo')::date;
  v_days_in_app integer := 0;
  v_submodules_completed integer := 0;
  v_email text;
  v_full_name text;
  v_age integer;
  v_trail_started_at timestamptz;
BEGIN
  SELECT * INTO v_progress FROM public.get_player_progress(uid);

  SELECT
    p.email,
    p.nome_completo,
    p.idade,
    p.data_inicio_trilha,
    CASE
      WHEN p.data_inicio_trilha IS NULL THEN 0
      ELSE GREATEST(
        0,
        (v_today - (p.data_inicio_trilha AT TIME ZONE 'America/Sao_Paulo')::date) + 1
      )
    END
  INTO v_email, v_full_name, v_age, v_trail_started_at, v_days_in_app
  FROM public.profiles p
  WHERE p.id = uid;

  SELECT COUNT(*)::integer
  INTO v_submodules_completed
  FROM (
    SELECT sp.submodulo_id
    FROM public.submodulo_pares sp
    LEFT JOIN public.progresso_par pp
      ON pp.par_id = sp.id
     AND pp.user_id = uid
     AND pp.concluido = true
    GROUP BY sp.submodulo_id
    HAVING COUNT(*) > 0
       AND COUNT(*) FILTER (WHERE pp.par_id IS NOT NULL) = COUNT(*)

    UNION

    SELECT l.submodulo_id
    FROM public.licoes l
    LEFT JOIN public.progresso_licao pl
      ON pl.licao_id = l.id
     AND pl.user_id = uid
     AND pl.concluido = true
    WHERE NOT EXISTS (
      SELECT 1
      FROM public.submodulo_pares sp2
      WHERE sp2.submodulo_id = l.submodulo_id
    )
    GROUP BY l.submodulo_id
    HAVING COUNT(*) > 0
       AND COUNT(*) FILTER (WHERE pl.licao_id IS NOT NULL) = COUNT(*)

    UNION

    SELECT pu.submodulo_id
    FROM public.progresso_usuario pu
    WHERE pu.user_id = uid
      AND pu.concluido = true
  ) completed;

  RETURN jsonb_build_object(
    'id', uid,
    'email', v_email,
    'full_name', v_full_name,
    'age', v_age,
    'trail_started_at', v_trail_started_at,
    'player_level', COALESCE(v_progress.player_level, 1),
    'total_xp', COALESCE(v_progress.total_xp, 0),
    'xp_to_next_level', COALESCE(v_progress.xp_to_next_level, 0),
    'xp_in_level', COALESCE(v_progress.xp_in_level, 0),
    'xp_for_next_level', COALESCE(v_progress.xp_for_next_level, 0),
    'current_streak', COALESCE(v_progress.current_streak, 0),
    'best_streak', COALESCE(v_progress.best_streak, 0),
    'streak_shields', COALESCE(v_progress.streak_shields, 0),
    'xp_today', COALESCE(v_progress.xp_today, 0),
    'xp_week', COALESCE(v_progress.xp_week, 0),
    'days_in_app', COALESCE(v_days_in_app, 0),
    'submodules_completed', COALESCE(v_submodules_completed, 0)
  );
END;
$function$;

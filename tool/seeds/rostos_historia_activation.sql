-- Activate Rostos da História on the Games Hub (see #144).
--
-- Why this is needed: `start_game_match` only opens a match for a game
-- with `is_active = true`:
--
--   SELECT id INTO v_game_id FROM public.games
--   WHERE slug = p_game_slug AND is_active = true;
--   IF v_game_id IS NULL THEN RAISE EXCEPTION 'game not found: %', ...
--
-- The content seed (`rostos_historia.sql`) intentionally left the game
-- inactive, and `get_hub_games` still returns the tile, so tapping it
-- fetched the 5 visual questions and then failed on `start_game_match`
-- (HTTP 400, hub shows "Não foi possível carregar esta rodada.").
--
-- Prerequisites (verified 2026-10-19):
--   * `enabled_game_slugs` (Firebase Remote Config + in-app default)
--     includes `rostos_historia`
--   * 50 `visual_content` / 100 `visual_questions` rows for the slug
--   * `games.hub_section = 'visual'` for the slug
--
-- Idempotent. Apply in the Supabase SQL editor or via linked CLI:
--
--   supabase db query --linked -f tool/seeds/rostos_historia_activation.sql

UPDATE public.games
SET is_active = true
WHERE slug = 'rostos_historia';

-- Verify: expect one row, is_active = true.
SELECT slug, hub_section, is_active
FROM public.games
WHERE slug = 'rostos_historia';

-- Activate Giro pelo Mundo on the Games Hub (see #152).
--
-- Why this is needed: `start_game_match` only opens a match for a game
-- with `is_active = true`:
--
--   SELECT id INTO v_game_id FROM public.games
--   WHERE slug = p_game_slug AND is_active = true;
--   IF v_game_id IS NULL THEN RAISE EXCEPTION 'game not found: %', ...
--
-- The content seed (#150) left the game inactive, and `get_hub_games`
-- still returns the tile, so tapping it fetched the visual questions and
-- then failed on `start_game_match` (HTTP 400, hub shows "Não foi
-- possível carregar esta rodada.").
--
-- Prerequisites (verified 2026-11-02):
--   * `enabled_game_slugs` (Firebase Remote Config + in-app default)
--     includes `giro_pelo_mundo`
--   * 50 `visual_content` / 350 `visual_questions` rows for the slug
--   * `games.hub_section = 'visual'` for the slug
--
-- Idempotent. Apply in the Supabase SQL editor or via linked CLI:
--
--   supabase db query --linked -f tool/seeds/giro_pelo_mundo_activation.sql

UPDATE public.games
SET is_active = true
WHERE slug = 'giro_pelo_mundo';

-- Verify: expect one row, is_active = true.
SELECT slug, hub_section, is_active
FROM public.games
WHERE slug = 'giro_pelo_mundo';

-- Rollback for 02_history_scope_achievements.sql (#168 to #171).
-- ORDER MATTERS:
--   1. Run snapshots/01_pre_pivot_achievements.sql first (restores check_achievements and
--      get_profile, so nothing calls _app_trail_counts any more).
--   2. Then run this file.
-- The backup tables are kept on purpose; drop them by hand once you are sure
-- (DROP TABLE public._bak_history_pivot_achievements, public._bak_history_pivot_user_achievements).

BEGIN;

-- Restore the original is_active flag of every achievement.
UPDATE public.achievements a
SET is_active = b.is_active
FROM public._bak_history_pivot_achievements b
WHERE b.id = a.id
  AND a.is_active IS DISTINCT FROM b.is_active;

-- Restore the original progress of the generic trail counters.
UPDATE public.user_achievements ua
SET progress = b.progress
FROM public._bak_history_pivot_user_achievements b
WHERE b.user_id = ua.user_id
  AND b.achievement_id = ua.achievement_id
  AND ua.progress IS DISTINCT FROM b.progress;

DROP FUNCTION IF EXISTS public._app_trail_counts(uuid);

COMMIT;

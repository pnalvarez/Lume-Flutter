-- Rollback for 02_daily_curiosity.sql (#235). Does not touch public.curiosities (#234).

BEGIN;

DROP FUNCTION IF EXISTS public.mark_curiosity_seen(uuid);
DROP FUNCTION IF EXISTS public.get_daily_curiosity(date);
DROP FUNCTION IF EXISTS public.assign_daily_curiosity(uuid, date);
DROP FUNCTION IF EXISTS public.pick_curiosity_for_user(uuid);

DROP POLICY IF EXISTS "Users read own daily_curiosities" ON public.daily_curiosities;
DROP TABLE IF EXISTS public.daily_curiosities;

DROP POLICY IF EXISTS "Users manage own user_curiosities" ON public.user_curiosities;
DROP TABLE IF EXISTS public.user_curiosities;

COMMIT;

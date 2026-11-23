-- #235 Curiosity of the Day: per-user history, one-per-day assignment and the RPCs around them.
-- Depends on 01_curiosities.sql (#234). Idempotent. Rollback: 02_daily_curiosity.rollback.sql.

BEGIN;

-- What the user has already seen (only set once the curiosity was actually opened/dismissed).
CREATE TABLE IF NOT EXISTS public.user_curiosities (
  user_id       uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  curiosity_id  uuid NOT NULL REFERENCES public.curiosities (id) ON DELETE CASCADE,
  seen          boolean NOT NULL DEFAULT false,
  seen_at       timestamptz,
  PRIMARY KEY (user_id, curiosity_id)
);

ALTER TABLE public.user_curiosities ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage own user_curiosities" ON public.user_curiosities;
CREATE POLICY "Users manage own user_curiosities"
  ON public.user_curiosities
  FOR ALL
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- The curiosity assigned to a user for a (client-local) day.
CREATE TABLE IF NOT EXISTS public.daily_curiosities (
  user_id       uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  day           date NOT NULL,
  curiosity_id  uuid NOT NULL REFERENCES public.curiosities (id) ON DELETE CASCADE,
  assigned_at   timestamptz NOT NULL DEFAULT now(),
  opened_at     timestamptz,
  pushes_sent   smallint NOT NULL DEFAULT 0,
  last_push_at  timestamptz,
  PRIMARY KEY (user_id, day)
);

ALTER TABLE public.daily_curiosities ENABLE ROW LEVEL SECURITY;

-- Read-only for users; every write goes through the SECURITY DEFINER functions below.
DROP POLICY IF EXISTS "Users read own daily_curiosities" ON public.daily_curiosities;
CREATE POLICY "Users read own daily_curiosities"
  ON public.daily_curiosities
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

REVOKE INSERT, UPDATE, DELETE ON public.daily_curiosities FROM authenticated, anon;

-- Shared selection: random unseen active curiosity; once everything is seen,
-- random among the 25% least recently seen. Never empty while an active curiosity exists.
CREATE OR REPLACE FUNCTION public.pick_curiosity_for_user(p_user_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_id uuid;
  v_active_count integer;
BEGIN
  SELECT c.id INTO v_id
  FROM curiosities c
  WHERE c.active
    AND NOT EXISTS (
      SELECT 1 FROM user_curiosities uc
      WHERE uc.user_id = p_user_id AND uc.curiosity_id = c.id AND uc.seen
    )
  ORDER BY random()
  LIMIT 1;

  IF v_id IS NOT NULL THEN
    RETURN v_id;
  END IF;

  SELECT count(*) INTO v_active_count FROM curiosities WHERE active;
  IF v_active_count = 0 THEN
    RETURN NULL;
  END IF;

  SELECT t.id INTO v_id
  FROM (
    SELECT c.id
    FROM curiosities c
    LEFT JOIN user_curiosities uc
      ON uc.curiosity_id = c.id AND uc.user_id = p_user_id
    WHERE c.active
    ORDER BY uc.seen_at ASC NULLS FIRST
    LIMIT greatest(1, ceil(v_active_count * 0.25)::integer)
  ) t
  ORDER BY random()
  LIMIT 1;

  RETURN v_id;
END;
$function$;

-- Idempotent, race-safe assignment for (user, day). Shared by the app RPC and the push job.
-- p_day is clamped to within one day of UTC today so changing the device date cannot farm curiosities.
CREATE OR REPLACE FUNCTION public.assign_daily_curiosity(p_user_id uuid, p_day date)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_today_utc date := (now() AT TIME ZONE 'utc')::date;
  v_day date := least(greatest(p_day, v_today_utc - 1), v_today_utc + 1);
  v_pick uuid;
  v_assigned uuid;
BEGIN
  SELECT d.curiosity_id INTO v_assigned
  FROM daily_curiosities d
  WHERE d.user_id = p_user_id AND d.day = v_day;

  IF v_assigned IS NOT NULL THEN
    RETURN v_assigned;
  END IF;

  v_pick := pick_curiosity_for_user(p_user_id);
  IF v_pick IS NULL THEN
    RETURN NULL;
  END IF;

  -- A concurrent caller may win the insert; we then read back its row.
  INSERT INTO daily_curiosities (user_id, day, curiosity_id)
  VALUES (p_user_id, v_day, v_pick)
  ON CONFLICT (user_id, day) DO NOTHING;

  SELECT d.curiosity_id INTO v_assigned
  FROM daily_curiosities d
  WHERE d.user_id = p_user_id AND d.day = v_day;

  RETURN v_assigned;
END;
$function$;

CREATE OR REPLACE FUNCTION public.get_daily_curiosity(p_day date)
 RETURNS TABLE (
   id uuid,
   image_url text,
   title text,
   content text,
   teaser text,
   opened boolean
 )
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_uid uuid := auth.uid();
  v_today_utc date := (now() AT TIME ZONE 'utc')::date;
  v_day date := least(greatest(p_day, v_today_utc - 1), v_today_utc + 1);
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated' USING ERRCODE = '28000';
  END IF;

  PERFORM assign_daily_curiosity(v_uid, v_day);

  RETURN QUERY
  SELECT c.id, c.image_url, c.title, c.content, c.teaser, (d.opened_at IS NOT NULL)
  FROM daily_curiosities d
  JOIN curiosities c ON c.id = d.curiosity_id
  WHERE d.user_id = v_uid AND d.day = v_day;
END;
$function$;

CREATE OR REPLACE FUNCTION public.mark_curiosity_seen(p_curiosity_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated' USING ERRCODE = '28000';
  END IF;

  INSERT INTO user_curiosities (user_id, curiosity_id, seen, seen_at)
  VALUES (v_uid, p_curiosity_id, true, now())
  ON CONFLICT (user_id, curiosity_id)
  DO UPDATE SET seen = true, seen_at = now();

  UPDATE daily_curiosities
  SET opened_at = now()
  WHERE user_id = v_uid AND curiosity_id = p_curiosity_id AND opened_at IS NULL;
END;
$function$;

-- Client-facing RPCs: authenticated only. Selection/assignment helpers: server side only
-- (the push scheduler calls them with the service role).
REVOKE ALL ON FUNCTION public.get_daily_curiosity(date) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.mark_curiosity_seen(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_daily_curiosity(date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.mark_curiosity_seen(uuid) TO authenticated;

REVOKE ALL ON FUNCTION public.pick_curiosity_for_user(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.assign_daily_curiosity(uuid, date) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.pick_curiosity_for_user(uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.assign_daily_curiosity(uuid, date) TO service_role;

COMMIT;

-- Verify on a Supabase branch (as an authenticated user):
--   SELECT * FROM get_daily_curiosity(current_date);     -- twice: same id, opened = false
--   SELECT mark_curiosity_seen('<id>');                   -- then opened = true, row in user_curiosities
--   SELECT * FROM get_daily_curiosity(current_date + 5);  -- clamped to UTC today + 1

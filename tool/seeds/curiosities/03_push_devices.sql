-- #239 Curiosity of the Day: push notification devices (FCM tokens + device timezone).
-- Consumed by the push scheduler (#240) with the service role. Idempotent.
-- Rollback: 03_push_devices.rollback.sql.

BEGIN;

CREATE TABLE IF NOT EXISTS public.push_devices (
  token                  text PRIMARY KEY,
  user_id                uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  platform               text NOT NULL CHECK (platform IN ('ios', 'android')),
  timezone               text NOT NULL CHECK (length(timezone) > 0), -- IANA, e.g. America/Sao_Paulo
  notifications_enabled  boolean NOT NULL DEFAULT true,
  updated_at             timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS push_devices_user_id_idx ON public.push_devices (user_id);

ALTER TABLE public.push_devices ENABLE ROW LEVEL SECURITY;

-- Users manage only their own rows (the scheduler uses the service role, which bypasses RLS).
DROP POLICY IF EXISTS "Users manage own push_devices" ON public.push_devices;
CREATE POLICY "Users manage own push_devices"
  ON public.push_devices
  FOR ALL
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Upsert the calling user's device. SECURITY DEFINER because an FCM token can move to another
-- account on the same phone (logout + login): the old owner's row must be taken over, which RLS
-- alone would forbid. A user's previous notifications_enabled choice is preserved on refresh;
-- a token that changes owner starts enabled.
CREATE OR REPLACE FUNCTION public.register_push_device(
  p_token text,
  p_platform text,
  p_timezone text
)
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
  IF p_token IS NULL OR length(trim(p_token)) = 0 THEN
    RAISE EXCEPTION 'token required' USING ERRCODE = '22023';
  END IF;
  IF p_platform NOT IN ('ios', 'android') THEN
    RAISE EXCEPTION 'invalid platform' USING ERRCODE = '22023';
  END IF;
  IF p_timezone IS NULL OR length(trim(p_timezone)) = 0 THEN
    RAISE EXCEPTION 'timezone required' USING ERRCODE = '22023';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_timezone_names WHERE name = p_timezone) THEN
    RAISE EXCEPTION 'unknown timezone' USING ERRCODE = '22023';
  END IF;

  INSERT INTO push_devices (token, user_id, platform, timezone, notifications_enabled, updated_at)
  VALUES (p_token, v_uid, p_platform, p_timezone, true, now())
  ON CONFLICT (token) DO UPDATE
  SET user_id = EXCLUDED.user_id,
      platform = EXCLUDED.platform,
      timezone = EXCLUDED.timezone,
      notifications_enabled = CASE
        WHEN push_devices.user_id = EXCLUDED.user_id THEN push_devices.notifications_enabled
        ELSE true
      END,
      updated_at = now();
END;
$function$;

-- Removes the calling user's row for this token (logout). No-op for other users' tokens.
CREATE OR REPLACE FUNCTION public.unregister_push_device(p_token text)
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

  DELETE FROM push_devices WHERE token = p_token AND user_id = v_uid;
END;
$function$;

REVOKE ALL ON FUNCTION public.register_push_device(text, text, text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.unregister_push_device(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.register_push_device(text, text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.unregister_push_device(text) TO authenticated;

COMMIT;

-- Verify on a Supabase branch (as an authenticated user):
--   SELECT register_push_device('tok-1', 'ios', 'America/Sao_Paulo');
--   SELECT * FROM push_devices;                      -- one row, notifications_enabled = true
--   SELECT register_push_device('tok-1', 'ios', 'Europe/Lisbon');  -- same row, timezone updated
--   SELECT unregister_push_device('tok-1');          -- row gone
--   SELECT register_push_device('tok-2', 'web', 'UTC');            -- raises: invalid platform

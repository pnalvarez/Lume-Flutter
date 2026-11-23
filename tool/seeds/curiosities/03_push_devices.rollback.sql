-- Rollback for 03_push_devices.sql (#239). Drops every registered device token.

BEGIN;

DROP FUNCTION IF EXISTS public.unregister_push_device(text);
DROP FUNCTION IF EXISTS public.register_push_device(text, text, text);

DROP POLICY IF EXISTS "Users manage own push_devices" ON public.push_devices;
DROP TABLE IF EXISTS public.push_devices;

COMMIT;

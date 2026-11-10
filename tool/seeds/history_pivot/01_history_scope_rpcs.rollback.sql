-- Rollback for 01_history_scope_rpcs.sql (#164 to #167).
-- ORDER MATTERS:
--   1. Run snapshots/00_pre_pivot_rpcs.sql first. It restores the 5 RPCs, which stops
--      them calling the helpers below.
--   2. Then run this file to remove the helpers.
-- Running this file alone would fail, because the RPCs would still depend on the helpers.

BEGIN;

DROP FUNCTION IF EXISTS public._is_app_modulo(bigint);
DROP FUNCTION IF EXISTS public._app_category_id();

COMMIT;

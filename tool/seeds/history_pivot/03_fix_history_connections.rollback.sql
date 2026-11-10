-- Rollback for 03_fix_history_connections.sql: restores the original question_data of the 8 items.
-- The backup table is kept; drop it by hand once you are sure (DROP TABLE public._bak_history_pivot_connections).

BEGIN;

UPDATE public.concept_game_items cgi
SET question_data = b.question_data
FROM public._bak_history_pivot_connections b
WHERE b.id = cgi.id;

COMMIT;

-- History pivot / #188: per-trail achievements for the 6 new History modules
-- and re-enable the generic milestones that #168 deactivates while only 4 trails exist.
-- Apply AFTER 04..09 trail seeds (looks up modules by titulo). Idempotent.
-- Rollback: 10_achievements_new_trails.rollback.sql

BEGIN;

-- Snapshot names we touch (once).
CREATE TABLE IF NOT EXISTS public._bak_history_pivot_achievements_phase5 AS
SELECT id, code, name, description, is_active, condition_metadata
FROM public.achievements
WHERE code IN (
  'modules_5', 'modules_10', 'submodules_50', 'submodules_100'
)
OR code LIKE 'mod\_%\_first\_sub' ESCAPE '\'
OR code LIKE 'mod\_%\_complete' ESCAPE '\';

ALTER TABLE public._bak_history_pivot_achievements_phase5 ENABLE ROW LEVEL SECURITY;

-- New trail titles → emoji (for achievement names/icons).
CREATE TEMP TABLE _new_trails (titulo text PRIMARY KEY, emoji text);
INSERT INTO _new_trails (titulo, emoji) VALUES
  ('Grécia e Roma Antigas', '🏺'),
  ('Idade Média', '🏰'),
  ('Renascimento e Grandes Navegações', '🧭'),
  ('Era das Revoluções', '⚖️'),
  ('Brasil República (1889 até hoje)', '🇧🇷'),
  ('Século XX e as Guerras Mundiais', '🌍');

-- Per-module first-sub + complete, same pattern as existing History modules.
INSERT INTO public.achievements (
  code, name, description, icon,
  reward_type, reward_amount, reward_metadata,
  condition_type, condition_target, condition_metadata, is_active
)
SELECT
  'mod_' || m.id || '_first_sub',
  'Primeiro passo: ' || t.emoji || ' ' || m.titulo,
  'Complete 1 submódulo em ' || m.titulo || '.',
  t.emoji,
  'xp', 30, NULL,
  'trail_module_submodules_completed', 1,
  jsonb_build_object('modulo_id', m.id),
  true
FROM public.modulos m
JOIN _new_trails t ON t.titulo = m.titulo
WHERE NOT EXISTS (
  SELECT 1 FROM public.achievements a WHERE a.code = 'mod_' || m.id || '_first_sub'
);

INSERT INTO public.achievements (
  code, name, description, icon,
  reward_type, reward_amount, reward_metadata,
  condition_type, condition_target, condition_metadata, is_active
)
SELECT
  'mod_' || m.id || '_complete',
  'Módulo dominado: ' || t.emoji || ' ' || m.titulo,
  'Complete todos os submódulos de ' || m.titulo || '.',
  t.emoji,
  'xp', 100, NULL,
  'trail_module_fully_completed', 1,
  jsonb_build_object('modulo_id', m.id),
  true
FROM public.modulos m
JOIN _new_trails t ON t.titulo = m.titulo
WHERE NOT EXISTS (
  SELECT 1 FROM public.achievements a WHERE a.code = 'mod_' || m.id || '_complete'
);

-- Re-enable milestones reachable with 10 History trails / 120 submodules.
UPDATE public.achievements
SET is_active = true
WHERE code IN ('modules_5', 'modules_10', 'submodules_50', 'submodules_100')
  AND is_active IS DISTINCT FROM true;

-- Rename "Polímata" (implies many subjects) to a History-flavoured name.
UPDATE public.achievements
SET name = 'Erudito da História',
    description = 'Complete 5 trilhas de História inteiras.'
WHERE code = 'modules_5'
  AND name IS DISTINCT FROM 'Erudito da História';

DROP TABLE _new_trails;

-- Assert: 6 first_sub + 6 complete for the new titles, milestones active.
DO $$
DECLARE
  v_first int;
  v_complete int;
  v_milestones int;
BEGIN
  SELECT count(*) INTO v_first
  FROM public.achievements a
  JOIN public.modulos m ON a.condition_metadata->>'modulo_id' = m.id::text
  WHERE a.code = 'mod_' || m.id || '_first_sub'
    AND m.titulo IN (
      'Grécia e Roma Antigas', 'Idade Média', 'Renascimento e Grandes Navegações',
      'Era das Revoluções', 'Brasil República (1889 até hoje)', 'Século XX e as Guerras Mundiais'
    )
    AND a.is_active;

  SELECT count(*) INTO v_complete
  FROM public.achievements a
  JOIN public.modulos m ON a.condition_metadata->>'modulo_id' = m.id::text
  WHERE a.code = 'mod_' || m.id || '_complete'
    AND m.titulo IN (
      'Grécia e Roma Antigas', 'Idade Média', 'Renascimento e Grandes Navegações',
      'Era das Revoluções', 'Brasil República (1889 até hoje)', 'Século XX e as Guerras Mundiais'
    )
    AND a.is_active;

  SELECT count(*) INTO v_milestones
  FROM public.achievements
  WHERE code IN ('modules_5', 'modules_10', 'submodules_50', 'submodules_100')
    AND is_active;

  IF v_first <> 6 OR v_complete <> 6 OR v_milestones <> 4 THEN
    RAISE EXCEPTION 'achievements phase5 incomplete: first=%, complete=%, milestones=%',
      v_first, v_complete, v_milestones;
  END IF;
END $$;

COMMIT;

-- After apply (with all 6 trails live), expect ~58 active History-scoped achievements
-- once #168 has deactivated the non-History catalogue. Verify:
--   SELECT count(*) FROM achievements WHERE is_active;

-- Rollback for #188. Removes only the per-module achievements created for the
-- 6 new trail titles. Restores modules_5 name/description and milestone is_active
-- from the phase-5 backup when present; otherwise leaves milestones untouched.

BEGIN;

DELETE FROM public.achievements a
USING public.modulos m
WHERE a.condition_metadata->>'modulo_id' = m.id::text
  AND m.titulo IN (
    'Grécia e Roma Antigas',
    'Idade Média',
    'Renascimento e Grandes Navegações',
    'Era das Revoluções',
    'Brasil República (1889 até hoje)',
    'Século XX e as Guerras Mundiais'
  )
  AND (a.code = 'mod_' || m.id || '_first_sub'
    OR a.code = 'mod_' || m.id || '_complete');

UPDATE public.achievements a
SET name = b.name,
    description = b.description,
    is_active = b.is_active
FROM public._bak_history_pivot_achievements_phase5 b
WHERE a.code = b.code
  AND a.code IN ('modules_5', 'modules_10', 'submodules_50', 'submodules_100');

COMMIT;

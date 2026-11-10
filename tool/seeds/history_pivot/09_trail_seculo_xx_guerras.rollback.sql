-- Rollback for #187: Século XX e as Guerras Mundiais
-- Removes only rows created by this trail (slug prefix sx-).

BEGIN;

DELETE FROM public.submodulo_pares sp
USING public.submodulos s, public.modulos m
WHERE sp.submodulo_id = s.id
  AND s.modulo_id = m.id
  AND m.titulo = 'Século XX e as Guerras Mundiais';

DELETE FROM public.concept_game_items cgi
USING public.concepts c
WHERE cgi.concept_id = c.id
  AND c.slug LIKE 'sx-%';

DELETE FROM public.concepts
WHERE slug LIKE 'sx-%';

DELETE FROM public.licoes l
USING public.submodulos s, public.modulos m
WHERE l.submodulo_id = s.id AND s.modulo_id = m.id
  AND m.titulo = 'Século XX e as Guerras Mundiais';

DELETE FROM public.submodulos s
USING public.modulos m
WHERE s.modulo_id = m.id
  AND m.titulo = 'Século XX e as Guerras Mundiais';

DELETE FROM public.niveis n
USING public.modulos m
WHERE n.modulo_id = m.id
  AND m.titulo = 'Século XX e as Guerras Mundiais';

DELETE FROM public.modulos
WHERE titulo = 'Século XX e as Guerras Mundiais';

COMMIT;

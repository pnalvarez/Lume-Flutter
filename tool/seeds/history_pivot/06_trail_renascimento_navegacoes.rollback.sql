-- Rollback for #184: Renascimento e Grandes Navegações
-- Removes only rows created by this trail (slug prefix rn-).

BEGIN;

DELETE FROM public.submodulo_pares sp
USING public.submodulos s, public.modulos m
WHERE sp.submodulo_id = s.id
  AND s.modulo_id = m.id
  AND m.titulo = 'Renascimento e Grandes Navegações';

DELETE FROM public.concept_game_items cgi
USING public.concepts c
WHERE cgi.concept_id = c.id
  AND c.slug LIKE 'rn-%';

DELETE FROM public.concepts
WHERE slug LIKE 'rn-%';

DELETE FROM public.licoes l
USING public.submodulos s, public.modulos m
WHERE l.submodulo_id = s.id AND s.modulo_id = m.id
  AND m.titulo = 'Renascimento e Grandes Navegações';

DELETE FROM public.submodulos s
USING public.modulos m
WHERE s.modulo_id = m.id
  AND m.titulo = 'Renascimento e Grandes Navegações';

DELETE FROM public.niveis n
USING public.modulos m
WHERE n.modulo_id = m.id
  AND m.titulo = 'Renascimento e Grandes Navegações';

DELETE FROM public.modulos
WHERE titulo = 'Renascimento e Grandes Navegações';

COMMIT;

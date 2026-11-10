-- History pivot (#161) / #179: standardize the 8 existing History "Connections" items.
-- Content edit on concept_game_items (ids 189, 204, 217, 237, 261, 888, 908, 921).
-- Each item belongs to exactly one submodulo_pares row, so no other trail is affected.
--
-- What changes:
--   1. All 8 get titulo (= the submodule title) and a standard subtitulo, so players stop
--      seeing the generic "Conexões" fallback with an empty subtitle.
--   2. The 3 newer items (888, 908, 921) only had one top-level `explicacao`, which the
--      payload mapper never reads. Each pair now gets its own explicacao. Top-level text kept.
-- EDITORIAL: the 12 per-pair explanations below were written from the facts already in each
-- item's own columns. Review them before applying.
-- Rollback: 03_fix_history_connections.rollback.sql

BEGIN;

CREATE TABLE IF NOT EXISTS public._bak_history_pivot_connections AS
  SELECT id, question_data
  FROM public.concept_game_items
  WHERE id IN (189, 204, 217, 237, 261, 888, 908, 921);

ALTER TABLE public._bak_history_pivot_connections ENABLE ROW LEVEL SECURITY;

-- 1) titulo / subtitulo for all 8 (only where missing, so re-running is safe).
UPDATE public.concept_game_items cgi
SET question_data = cgi.question_data || jsonb_build_object(
      'titulo', s.titulo,
      'subtitulo', 'Ligue cada item da esquerda ao que combina na direita.'
    )
FROM public.submodulo_pares sp
JOIN public.submodulos s ON s.id = sp.submodulo_id
WHERE cgi.id IN (189, 204, 217, 237, 261, 888, 908, 921)
  AND cgi.concept_id = sp.concept_id
  AND cgi.game_type = sp.game_type
  AND (COALESCE(cgi.question_data->>'titulo', '') = ''
       OR COALESCE(cgi.question_data->>'subtitulo', '') = '');

-- 2) per-pair explanations for the 3 items that had none.
UPDATE public.concept_game_items
SET question_data = jsonb_set(question_data, '{pares}', '[
  {"esquerda_id":"e1","direita_id":"d1","explicacao":"''Rabbit'', de Jeff Koons, foi vendida por 91 milhões de dólares e produzida por uma equipe de assistentes."},
  {"esquerda_id":"e2","direita_id":"d2","explicacao":"Ai Weiwei montou uma instalação com 9.000 mochilas escolares em memória das vítimas do terremoto de Sichuan, em 2008."},
  {"esquerda_id":"e3","direita_id":"d3","explicacao":"Em ''The Artist Is Present'', Marina Abramović ficou sentada imóvel por cerca de 8 horas diárias durante 75 dias."},
  {"esquerda_id":"e4","direita_id":"d4","explicacao":"Em ''Shoot'', Chris Burden pediu para ser baleado no braço, dentro de uma galeria."}
]'::jsonb)
WHERE id = 888
  AND NOT (question_data->'pares'->0 ? 'explicacao');

UPDATE public.concept_game_items
SET question_data = jsonb_set(question_data, '{pares}', '[
  {"esquerda_id":"e1","direita_id":"d1","explicacao":"Os Mármores de Elgin foram retirados do Parthenon e até hoje são disputados entre Grécia e Reino Unido."},
  {"esquerda_id":"e2","direita_id":"d2","explicacao":"Os Bronzes de Benin foram saqueados pelos britânicos em 1897 e hoje estão espalhados por mais de 150 museus."},
  {"esquerda_id":"e3","direita_id":"d3","explicacao":"A Máscara de Warka desapareceu no saque ao Museu de Bagdá, em 2003."},
  {"esquerda_id":"e4","direita_id":"d4","explicacao":"Objetos sagrados de povos nativos americanos vêm sendo devolvidos pelo Smithsonian desde 2021."}
]'::jsonb)
WHERE id = 908
  AND NOT (question_data->'pares'->0 ? 'explicacao');

UPDATE public.concept_game_items
SET question_data = jsonb_set(question_data, '{pares}', '[
  {"esquerda_id":"e1","direita_id":"d1","explicacao":"O alfabeto que usamos hoje tem origem fenícia e foi passado adiante por gregos e romanos."},
  {"esquerda_id":"e2","direita_id":"d2","explicacao":"A semana de 7 dias tem origem babilônica."},
  {"esquerda_id":"e3","direita_id":"d3","explicacao":"A Grande Muralha funcionava mais como símbolo de poder do que como barreira militar."},
  {"esquerda_id":"e4","direita_id":"d4","explicacao":"Papel, pólvora, imprensa e bússola são as quatro grandes invenções chinesas."}
]'::jsonb)
WHERE id = 921
  AND NOT (question_data->'pares'->0 ? 'explicacao');

COMMIT;

-- Verify: run validate_history_content.sql. It must return zero rows.

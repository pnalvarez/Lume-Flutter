# Supabase content seeds

SQL applied to the shared Lume Supabase project (`Lume-Server`). These files are the source of truth for Flutter board tickets that seed content the client already consumes via RPCs.

## `rostos_historia.sql`

Seeds **Rostos da História** from `rostos_da_historia_conteudo.xlsx`:

- 50 `visual_content` rows (`game_slug = rostos_historia`, `content_type = person`)
- 100 `visual_questions` rows (`identify_person` + `identify_contribution`)
- Distractors as jsonb `{text, educational_note}`
- Idempotent (`WHERE NOT EXISTS` on slug / question_type)
- Does **not** set `games.is_active = true`

Apply in the Supabase SQL editor or via linked CLI:

```bash
supabase db query --linked -f tool/seeds/rostos_historia.sql
```

Verify:

```sql
SELECT count(*) FROM visual_content WHERE game_slug = 'rostos_historia';
-- 50
SELECT count(*) FROM visual_questions WHERE game_slug = 'rostos_historia';
-- 100
```

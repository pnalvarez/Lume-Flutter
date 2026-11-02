# Giro pelo Mundo — image pipeline

Generates flag / landmark / silhouette assets from
`giro_pelo_mundo_conteudo (1).xlsx` prompts, uploads them to the public
Supabase Storage bucket `knowledge-gallery`, and writes a slug → URL mapping
for the seed-data ticket (#150).

## Layout

```
prompts/manifest.json   # 150 generation jobs extracted from the sheet
images/flags|landmarks|silhouettes/  # local generated assets (gitignored)
out/url_mapping.json    # slug → {flag_url, landmark_url, silhouette_url}
```

## Commands

```bash
# 1. Re-extract prompts from the xlsx (optional; manifest is committed)
python3 tool/content/giro_pelo_mundo/extract_prompts.py

# 2. Generate missing images (Cursor GenerateImage / agent), then:
python3 tool/content/giro_pelo_mundo/upload_images.py

# 3. Verify every public URL returns 200 + image/*
python3 tool/content/giro_pelo_mundo/verify_urls.py
```

Uploads require `SUPABASE_ACCESS_TOKEN` (Management API) in `.env` so the
script can resolve the project's `service_role` key at runtime. Secrets are
never written into the mapping or the repo.

## Storage paths

`knowledge-gallery/giro_pelo_mundo/<slug>/{flag|landmark|silhouette}.png`

Public base:
`https://mizgtuwtuaculchwizkm.supabase.co/storage/v1/object/public/knowledge-gallery/`

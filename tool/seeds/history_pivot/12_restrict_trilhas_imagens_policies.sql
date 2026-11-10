-- #192: restrict trilhas-imagens storage policies.
-- Drops the temporary public INSERT/UPDATE/SELECT bulk policies.
-- Keeps the bucket public for CDN reads and adds a permanent SELECT-only policy.
-- Future uploads: Supabase Dashboard or service_role (bypasses RLS). Do not re-open public write.

BEGIN;

DROP POLICY IF EXISTS "temp_trilhas_imagens_insert_bulk" ON storage.objects;
DROP POLICY IF EXISTS "temp_trilhas_imagens_update_bulk" ON storage.objects;
DROP POLICY IF EXISTS "temp_trilhas_imagens_select_bulk" ON storage.objects;

DROP POLICY IF EXISTS "trilhas_imagens_public_read" ON storage.objects;
CREATE POLICY "trilhas_imagens_public_read"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'trilhas-imagens');

COMMIT;

-- Verify:
-- SELECT policyname, cmd FROM pg_policies
-- WHERE schemaname='storage' AND tablename='objects' AND policyname ILIKE '%trilhas%';

-- Rollback for #192. Restores the temporary bulk policies (NOT recommended).
-- Prefer leaving write closed and uploading via service_role / Dashboard.

BEGIN;

DROP POLICY IF EXISTS "trilhas_imagens_public_read" ON storage.objects;

DROP POLICY IF EXISTS "temp_trilhas_imagens_select_bulk" ON storage.objects;
CREATE POLICY "temp_trilhas_imagens_select_bulk"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'trilhas-imagens');

DROP POLICY IF EXISTS "temp_trilhas_imagens_insert_bulk" ON storage.objects;
CREATE POLICY "temp_trilhas_imagens_insert_bulk"
  ON storage.objects
  FOR INSERT
  TO public
  WITH CHECK (bucket_id = 'trilhas-imagens');

DROP POLICY IF EXISTS "temp_trilhas_imagens_update_bulk" ON storage.objects;
CREATE POLICY "temp_trilhas_imagens_update_bulk"
  ON storage.objects
  FOR UPDATE
  TO public
  USING (bucket_id = 'trilhas-imagens')
  WITH CHECK (bucket_id = 'trilhas-imagens');

COMMIT;

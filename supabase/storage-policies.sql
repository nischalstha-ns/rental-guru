-- =====================================================
-- STORAGE BUCKETS & POLICIES
-- =====================================================

INSERT INTO storage.buckets (id, name, public) VALUES
  ('user-documents', 'user-documents', false),
  ('property-images', 'property-images', true),
  ('user-avatars', 'user-avatars', false)
ON CONFLICT (id) DO NOTHING;

-- USER DOCUMENTS
CREATE POLICY "Allow authenticated users to upload own documents" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'user-documents' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to read their own documents" ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'user-documents' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to update their own documents" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'user-documents' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to delete their own documents" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'user-documents' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow admins to read all documents" ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'user-documents' AND (auth.jwt() ->> 'role') = 'admin');

-- PROPERTY IMAGES
CREATE POLICY "Anyone can view property images" ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'property-images');
CREATE POLICY "Landlords can upload their property images" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'property-images' AND (auth.jwt() ->> 'role') IN ('landlord', 'property_manager', 'admin'));
CREATE POLICY "Landlords can update their property images" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'property-images' AND (auth.jwt() ->> 'role') IN ('landlord', 'property_manager', 'admin'));
CREATE POLICY "Landlords can delete their property images" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'property-images' AND (auth.jwt() ->> 'role') IN ('landlord', 'property_manager', 'admin'));

-- USER AVATARS
CREATE POLICY "Allow users to upload avatars" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'user-avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to read their own avatar" ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'user-avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to update their own avatar" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'user-avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
CREATE POLICY "Allow users to delete their own avatar" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'user-avatars' AND (storage.foldername(name))[1] = auth.uid()::text);

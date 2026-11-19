-- =====================================================
-- RLS POLICIES
-- =====================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE properties_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE rental_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE leases ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- PROFILES
CREATE POLICY "Users can view all profiles" ON profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);
CREATE POLICY "Admin can update any profile" ON profiles FOR UPDATE TO authenticated USING ((auth.jwt() ->> 'role') = 'admin');

-- PROPERTIES
CREATE POLICY "Anyone can view available properties" ON properties FOR SELECT TO authenticated
  USING (verification_status = 'approved' OR auth.uid() = landlord_id OR (auth.jwt() ->> 'role') = 'admin');
CREATE POLICY "Landlords can insert own properties" ON properties FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = landlord_id);
CREATE POLICY "Landlords can update own properties" ON properties FOR UPDATE TO authenticated
  USING (auth.uid() = landlord_id OR (auth.jwt() ->> 'role') IN ('property_manager', 'admin'));
CREATE POLICY "Landlords can delete own properties" ON properties FOR DELETE TO authenticated
  USING (auth.uid() = landlord_id);
CREATE POLICY "Managers can update managed properties" ON properties FOR UPDATE TO authenticated
  USING (auth.uid() = assigned_manager_id);
CREATE POLICY "Admins can manage all properties" ON properties FOR ALL TO authenticated
  USING ((auth.jwt() ->> 'role') = 'admin');

-- PROPERTIES_IMAGES
CREATE POLICY "Anyone can view property images" ON properties_images FOR SELECT TO authenticated USING (true);
CREATE POLICY "Property owners can insert images" ON properties_images FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM properties WHERE properties.id = properties_images.property_id AND properties.landlord_id = auth.uid()));
CREATE POLICY "Property owners can delete images" ON properties_images FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM properties WHERE properties.id = properties_images.property_id AND properties.landlord_id = auth.uid()));

-- USER_DOCUMENTS
CREATE POLICY "Users can view own documents" ON user_documents FOR SELECT TO authenticated
  USING (auth.uid() = user_id OR (auth.jwt() ->> 'role') = 'admin');
CREATE POLICY "Users can insert own documents" ON user_documents FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can update verification status" ON user_documents FOR UPDATE TO authenticated
  USING ((auth.jwt() ->> 'role') IN ('admin', 'property_manager'));

-- RENTAL_APPLICATIONS
CREATE POLICY "Tenants can view own applications" ON rental_applications FOR SELECT TO authenticated
  USING (auth.uid() = tenant_id OR EXISTS (SELECT 1 FROM properties p WHERE p.id = rental_applications.property_id AND p.landlord_id = auth.uid()));
CREATE POLICY "Tenants can insert applications" ON rental_applications FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = tenant_id);
CREATE POLICY "Landlords can update their property applications" ON rental_applications FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM properties p WHERE p.id = rental_applications.property_id AND p.landlord_id = auth.uid()));

-- LEASES
CREATE POLICY "Users can view relevant leases" ON leases FOR SELECT TO authenticated
  USING (auth.uid() = tenant_id OR auth.uid() = landlord_id OR auth.uid() = COALESCE(manager_id, auth.uid()));
CREATE POLICY "Landlords can create leases" ON leases FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = landlord_id);
CREATE POLICY "Landlords can update leases" ON leases FOR UPDATE TO authenticated
  USING (auth.uid() = landlord_id);

-- PAYMENTS
CREATE POLICY "Users can view their payments" ON payments FOR SELECT TO authenticated
  USING (auth.uid() = tenant_id OR EXISTS (SELECT 1 FROM leases l WHERE l.id = payments.lease_id AND l.landlord_id = auth.uid()));
CREATE POLICY "Tenants can insert payments" ON payments FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = tenant_id);

-- MAINTENANCE_REQUESTS
CREATE POLICY "Users can view relevant requests" ON maintenance_requests FOR SELECT TO authenticated
  USING (auth.uid() = tenant_id OR EXISTS (SELECT 1 FROM properties p WHERE p.id = maintenance_requests.property_id AND p.landlord_id = auth.uid()));
CREATE POLICY "Tenants can create requests" ON maintenance_requests FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = tenant_id);
CREATE POLICY "Owners/managers can update requests" ON maintenance_requests FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM properties p WHERE p.id = maintenance_requests.property_id AND (p.landlord_id = auth.uid() OR p.assigned_manager_id = auth.uid())));

-- AUDIT_LOGS
CREATE POLICY "Admins can view audit logs" ON audit_logs FOR SELECT TO authenticated
  USING ((auth.jwt() ->> 'role') = 'admin');

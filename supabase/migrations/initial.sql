-- =====================================================
-- RENT GURU - INITIAL SCHEMA MIGRATION
-- =====================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUM TYPES
CREATE TYPE user_role AS ENUM ('tenant', 'landlord', 'property_manager', 'admin');
CREATE TYPE account_status AS ENUM ('active', 'suspended', 'pending_review');
CREATE TYPE verification_status AS ENUM ('not_submitted', 'pending', 'approved', 'rejected');
CREATE TYPE document_type AS ENUM ('national_id', 'citizenship_front', 'passport', 'landlord_identity', 'property_manager_identity');
CREATE TYPE property_type AS ENUM ('apartment', 'house', 'condo', 'studio', 'townhouse', 'commercial');
CREATE TYPE availability_status AS ENUM ('available', 'rented', 'maintenance', 'off_market');
CREATE TYPE application_status AS ENUM ('pending', 'under_review', 'approved', 'rejected', 'withdrawn');
CREATE TYPE lease_status AS ENUM ('draft', 'active', 'expired', 'terminated', 'renewed');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'partial', 'overdue', 'refunded');
CREATE TYPE payment_type AS ENUM ('rent', 'security_deposit', 'utility', 'late_fee', 'other');
CREATE TYPE maintenance_priority AS ENUM ('low', 'medium', 'high', 'urgent');
CREATE TYPE maintenance_status AS ENUM ('open', 'in_progress', 'completed', 'cancelled');
CREATE TYPE audit_action AS ENUM ('INSERT', 'UPDATE', 'DELETE', 'SELECT', 'LOGIN', 'LOGOUT');
CREATE TYPE audit_entity AS ENUM ('profile', 'property', 'application', 'lease', 'payment', 'maintenance_request', 'user_document');

-- TABLES
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name VARCHAR(255) NOT NULL DEFAULT '',
    phone VARCHAR(20),
    avatar_path TEXT,
    role user_role NOT NULL DEFAULT 'tenant',
    verification_status verification_status NOT NULL DEFAULT 'not_submitted',
    account_status account_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE properties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    landlord_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    assigned_manager_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    property_type property_type,
    address_line TEXT,
    city VARCHAR(100),
    district VARCHAR(100),
    province VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    monthly_rent NUMERIC(12, 2) NOT NULL CHECK (monthly_rent > 0),
    security_deposit NUMERIC(12, 2) NOT NULL CHECK (security_deposit >= 0),
    bedrooms INTEGER CHECK (bedrooms >= 0),
    bathrooms INTEGER CHECK (bathrooms >= 0),
    area_sq_ft NUMERIC(10, 2),
    furnishing_status VARCHAR(50),
    availability_status availability_status NOT NULL DEFAULT 'available',
    verification_status verification_status NOT NULL DEFAULT 'pending',
    rejection_reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE properties_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    document_type document_type NOT NULL,
    document_number VARCHAR(100),
    file_path TEXT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size INTEGER NOT NULL DEFAULT 0,
    verification_status verification_status NOT NULL DEFAULT 'pending',
    rejection_reason TEXT,
    reviewed_by UUID REFERENCES profiles(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE rental_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    message TEXT,
    preferred_move_in_date DATE,
    status application_status NOT NULL DEFAULT 'pending',
    reviewed_by UUID REFERENCES profiles(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(property_id, tenant_id)
);

CREATE TABLE leases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE RESTRICT,
    tenant_id UUID NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
    landlord_id UUID NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
    manager_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    start_date DATE,
    end_date DATE,
    monthly_rent NUMERIC(12, 2) NOT NULL CHECK (monthly_rent > 0),
    security_deposit NUMERIC(12, 2) NOT NULL CHECK (security_deposit >= 0),
    status lease_status NOT NULL DEFAULT 'draft',
    lease_document_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
    amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    payment_type payment_type NOT NULL DEFAULT 'rent',
    due_date DATE NOT NULL,
    paid_at TIMESTAMPTZ,
    payment_status payment_status NOT NULL DEFAULT 'pending',
    transaction_reference VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE maintenance_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    assigned_manager_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority maintenance_priority NOT NULL DEFAULT 'medium',
    status maintenance_status NOT NULL DEFAULT 'open',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    performed_by UUID REFERENCES profiles(id),
    action audit_action NOT NULL,
    entity audit_entity NOT NULL,
    entity_id UUID,
    changes JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- INDEXES
CREATE INDEX idx_properties_landlord ON properties(landlord_id);
CREATE INDEX idx_properties_status ON properties(availability_status);
CREATE INDEX idx_properties_verification ON properties(verification_status);
CREATE INDEX idx_user_docs_user ON user_documents(user_id);
CREATE INDEX idx_user_docs_doc_type ON user_documents(document_type);
CREATE INDEX idx_user_docs_status ON user_documents(verification_status);
CREATE INDEX idx_applications_property ON rental_applications(property_id);
CREATE INDEX idx_applications_tenant ON rental_applications(tenant_id);
CREATE INDEX idx_leases_property ON leases(property_id);
CREATE INDEX idx_leases_tenant ON leases(tenant_id);
CREATE INDEX idx_leases_landlord ON leases(landlord_id);
CREATE INDEX idx_payments_lease ON payments(lease_id);
CREATE INDEX idx_payments_tenant ON payments(tenant_id);
CREATE INDEX idx_maintenance_property ON maintenance_requests(property_id);
CREATE INDEX idx_maintenance_tenant ON maintenance_requests(tenant_id);
CREATE INDEX idx_audit_logs_performed_by ON audit_logs(performed_by);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

-- TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS \$\$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER properties_updated_at BEFORE UPDATE ON properties FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER user_documents_updated_at BEFORE UPDATE ON user_documents FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER rental_applications_updated_at BEFORE UPDATE ON rental_applications FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER leases_updated_at BEFORE UPDATE ON leases FOR EACH ROW EXECUTE FUNCTION handle_updated_at();
CREATE TRIGGER maintenance_requests_updated_at BEFORE UPDATE ON maintenance_requests FOR EACH ROW EXECUTE FUNCTION handle_updated_at();

-- REALTIME
ALTER PUBLICATION supabase_realtime ADD TABLE properties;
ALTER PUBLICATION supabase_realtime ADD TABLE rental_applications;
ALTER PUBLICATION supabase_realtime ADD TABLE maintenance_requests;

-- AUDIT LOG TRIGGERS
CREATE OR REPLACE FUNCTION log_audit_event()
RETURNS TRIGGER AS \$\$
BEGIN
    INSERT INTO audit_logs (performed_by, action, entity, entity_id, changes)
    VALUES (NEW.id, TG_OP, TG_TABLE_NAME::audit_entity, NEW.id, to_jsonb(NEW));
    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql;

CREATE TRIGGER properties_audit AFTER INSERT OR UPDATE ON properties FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER user_documents_audit AFTER INSERT OR UPDATE ON user_documents FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER applications_audit AFTER INSERT OR UPDATE ON rental_applications FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER leases_audit AFTER INSERT OR UPDATE ON leases FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER maintenance_audit AFTER INSERT OR UPDATE ON maintenance_requests FOR EACH ROW EXECUTE FUNCTION log_audit_event();

CREATE TYPE beneficiary_status AS ENUM ('ACTIVE', 'INACTIVE', 'DELETED');

CREATE TABLE IF NOT EXISTS beneficiaries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    type payout_method NOT NULL,
    account_number VARCHAR(100),
    bank_code VARCHAR(50),
    routing_number VARCHAR(50),
    swift_bic VARCHAR(20),
    currency VARCHAR(3) NOT NULL,
    status beneficiary_status NOT NULL DEFAULT 'ACTIVE',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_beneficiaries_customer ON beneficiaries(customer_id);

CREATE TRIGGER update_beneficiaries_modtime
    BEFORE UPDATE ON beneficiaries
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add foreign key to payouts now that beneficiaries table exists
ALTER TABLE payouts
    ADD CONSTRAINT fk_payouts_beneficiary
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(id) ON DELETE RESTRICT;

CREATE TYPE payout_status AS ENUM ('PENDING', 'PROCESSING', 'SENT', 'COMPLETED', 'FAILED', 'RETURNED');
CREATE TYPE payout_method AS ENUM ('BANK_TRANSFER', 'MOBILE_MONEY', 'CASH_PICKUP');

CREATE TABLE IF NOT EXISTS payouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID REFERENCES transactions(id) ON DELETE RESTRICT,
    source_account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    beneficiary_id UUID NOT NULL, -- Added FK in later migration to avoid circular dep if beneficiaries are created first, or just create beneficiaries first. Wait, let's create it without FK or just define the FK. I will create beneficiaries first in 10, so here I will add it via alter table if needed. Actually, let me just add the column and I will add the foreign key in migration 10 or just reorder in my head. I'll just use a UUID type.
    amount BIGINT NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL,
    provider_id VARCHAR(50), -- e.g., 'stripe', 'wise', 'flutterwave'
    provider_reference VARCHAR(100),
    status payout_status NOT NULL DEFAULT 'PENDING',
    method payout_method NOT NULL,
    fee_amount BIGINT NOT NULL DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payouts_source ON payouts(source_account_id);
CREATE INDEX idx_payouts_beneficiary ON payouts(beneficiary_id);
CREATE INDEX idx_payouts_status ON payouts(status);
CREATE INDEX idx_payouts_provider_ref ON payouts(provider_reference);

CREATE TRIGGER update_payouts_modtime
    BEFORE UPDATE ON payouts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

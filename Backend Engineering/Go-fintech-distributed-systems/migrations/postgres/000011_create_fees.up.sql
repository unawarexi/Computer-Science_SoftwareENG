CREATE TYPE fee_type AS ENUM ('FIXED', 'PERCENTAGE');
CREATE TYPE fee_status AS ENUM ('ACTIVE', 'INACTIVE');

CREATE TABLE IF NOT EXISTS fee_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_type transaction_type NOT NULL,
    fee_type fee_type NOT NULL,
    amount BIGINT NOT NULL, -- fixed amount or percentage (in basis points, e.g. 100 = 1%)
    currency VARCHAR(3), -- null if percentage
    status fee_status NOT NULL DEFAULT 'ACTIVE',
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    valid_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE RESTRICT,
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    schedule_id UUID REFERENCES fee_schedules(id),
    amount BIGINT NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fee_schedules_type ON fee_schedules(transaction_type);
CREATE INDEX idx_fees_transaction ON fees(transaction_id);

CREATE TRIGGER update_fee_schedules_modtime
    BEFORE UPDATE ON fee_schedules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

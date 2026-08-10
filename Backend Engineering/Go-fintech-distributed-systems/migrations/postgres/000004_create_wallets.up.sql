CREATE TYPE wallet_status AS ENUM ('ACTIVE', 'LOCKED', 'CLOSED');

CREATE TABLE IF NOT EXISTS wallets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    wallet_address VARCHAR(100) UNIQUE NOT NULL,
    currency VARCHAR(3) NOT NULL,
    status wallet_status NOT NULL DEFAULT 'ACTIVE',
    available_balance BIGINT NOT NULL DEFAULT 0,
    locked_balance BIGINT NOT NULL DEFAULT 0,
    version BIGINT NOT NULL DEFAULT 1,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    CONSTRAINT positive_available CHECK (available_balance >= 0),
    CONSTRAINT positive_locked CHECK (locked_balance >= 0),
    UNIQUE (customer_id, currency)
);

CREATE INDEX idx_wallets_customer_id ON wallets(customer_id);
CREATE INDEX idx_wallets_address ON wallets(wallet_address);

CREATE TRIGGER update_wallets_modtime
    BEFORE UPDATE ON wallets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

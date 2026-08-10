CREATE TYPE account_type AS ENUM ('SAVINGS', 'CHECKING', 'SYSTEM', 'SUSPENSE');
CREATE TYPE account_status AS ENUM ('ACTIVE', 'FROZEN', 'CLOSED');

CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID REFERENCES customers(id) ON DELETE RESTRICT,
    account_number VARCHAR(50) UNIQUE NOT NULL,
    type account_type NOT NULL,
    status account_status NOT NULL DEFAULT 'ACTIVE',
    currency VARCHAR(3) NOT NULL,
    balance BIGINT NOT NULL DEFAULT 0, -- Minor units (e.g., cents)
    hold_balance BIGINT NOT NULL DEFAULT 0,
    version BIGINT NOT NULL DEFAULT 1, -- For optimistic locking
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    CONSTRAINT positive_balance CHECK (balance >= 0 OR type IN ('SYSTEM', 'SUSPENSE')),
    CONSTRAINT positive_hold CHECK (hold_balance >= 0)
);

CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_accounts_account_number ON accounts(account_number);
CREATE INDEX idx_accounts_currency ON accounts(currency);

CREATE TRIGGER update_accounts_modtime
    BEFORE UPDATE ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TYPE entry_direction AS ENUM ('DEBIT', 'CREDIT');

CREATE TABLE IF NOT EXISTS ledger_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL, -- Logical grouping for double-entry
    account_id UUID NOT NULL REFERENCES accounts(id),
    amount BIGINT NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL,
    direction entry_direction NOT NULL,
    description TEXT,
    reference_id VARCHAR(100), -- External reference
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Note: ledger_entries is APPEND ONLY. No updated_at, no triggers for updates.

CREATE INDEX idx_ledger_account_id ON ledger_entries(account_id);
CREATE INDEX idx_ledger_transaction_id ON ledger_entries(transaction_id);
CREATE INDEX idx_ledger_created_at ON ledger_entries(created_at);
CREATE INDEX idx_ledger_reference ON ledger_entries(reference_id);

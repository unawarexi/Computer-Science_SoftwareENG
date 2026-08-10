CREATE TYPE card_type AS ENUM ('VIRTUAL', 'PHYSICAL');
CREATE TYPE card_status AS ENUM ('PENDING', 'ACTIVE', 'FROZEN', 'CANCELLED');

CREATE TABLE IF NOT EXISTS cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    type card_type NOT NULL,
    status card_status NOT NULL DEFAULT 'PENDING',
    last_four VARCHAR(4) NOT NULL,
    expiry_month INT NOT NULL CHECK (expiry_month BETWEEN 1 AND 12),
    expiry_year INT NOT NULL,
    token VARCHAR(255) UNIQUE, -- Tokenized PAN from provider
    provider_id VARCHAR(50),
    spending_limit BIGINT,
    daily_limit BIGINT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_cards_customer ON cards(customer_id);
CREATE INDEX idx_cards_account ON cards(account_id);
CREATE INDEX idx_cards_token ON cards(token);

CREATE TRIGGER update_cards_modtime
    BEFORE UPDATE ON cards
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

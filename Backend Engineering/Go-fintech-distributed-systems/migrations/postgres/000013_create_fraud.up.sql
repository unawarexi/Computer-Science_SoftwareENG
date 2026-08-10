CREATE TYPE fraud_rule_action AS ENUM ('ALLOW', 'FLAG', 'BLOCK', 'REQUIRE_MFA');
CREATE TYPE alert_status AS ENUM ('OPEN', 'INVESTIGATING', 'RESOLVED_FALSE_POSITIVE', 'RESOLVED_TRUE_POSITIVE');

CREATE TABLE IF NOT EXISTS fraud_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    condition_expression TEXT NOT NULL,
    action fraud_rule_action NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fraud_alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID REFERENCES customers(id),
    transaction_id UUID REFERENCES transactions(id),
    rule_id UUID REFERENCES fraud_rules(id),
    score INT NOT NULL, -- 0 to 100 risk score
    status alert_status NOT NULL DEFAULT 'OPEN',
    details JSONB DEFAULT '{}',
    resolved_by UUID, -- ID of the admin who resolved it
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_fraud_alerts_customer ON fraud_alerts(customer_id);
CREATE INDEX idx_fraud_alerts_transaction ON fraud_alerts(transaction_id);
CREATE INDEX idx_fraud_alerts_status ON fraud_alerts(status);

CREATE TRIGGER update_fraud_rules_modtime
    BEFORE UPDATE ON fraud_rules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_fraud_alerts_modtime
    BEFORE UPDATE ON fraud_alerts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

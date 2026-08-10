DROP TRIGGER IF EXISTS update_fraud_alerts_modtime ON fraud_alerts;
DROP TRIGGER IF EXISTS update_fraud_rules_modtime ON fraud_rules;
DROP TABLE IF EXISTS fraud_alerts CASCADE;
DROP TABLE IF EXISTS fraud_rules CASCADE;
DROP TYPE IF EXISTS alert_status;
DROP TYPE IF EXISTS fraud_rule_action;

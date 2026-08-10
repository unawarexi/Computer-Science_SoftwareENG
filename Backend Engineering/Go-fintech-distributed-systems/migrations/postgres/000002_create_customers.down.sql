DROP TRIGGER IF EXISTS update_customers_modtime ON customers;
DROP FUNCTION IF EXISTS update_updated_at_column();

DROP TABLE IF EXISTS customers CASCADE;
DROP TYPE IF EXISTS kyc_tier;
DROP TYPE IF EXISTS customer_status;

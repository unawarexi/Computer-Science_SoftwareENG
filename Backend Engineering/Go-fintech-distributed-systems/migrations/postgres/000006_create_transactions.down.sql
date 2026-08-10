DROP TRIGGER IF EXISTS update_transactions_modtime ON transactions;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TYPE IF EXISTS transaction_type;
DROP TYPE IF EXISTS transaction_status;

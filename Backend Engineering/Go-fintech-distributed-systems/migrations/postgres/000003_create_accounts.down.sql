DROP TRIGGER IF EXISTS update_accounts_modtime ON accounts;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TYPE IF EXISTS account_status;
DROP TYPE IF EXISTS account_type;

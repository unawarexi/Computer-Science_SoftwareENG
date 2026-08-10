DROP TRIGGER IF EXISTS update_transfers_modtime ON transfers;
DROP TABLE IF EXISTS transfers CASCADE;
DROP TYPE IF EXISTS transfer_status;

DROP TRIGGER IF EXISTS update_idempotency_keys_modtime ON idempotency_keys;
DROP TABLE IF EXISTS idempotency_keys CASCADE;

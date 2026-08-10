DROP TRIGGER IF EXISTS update_api_keys_modtime ON api_keys;
DROP TRIGGER IF EXISTS update_users_modtime ON users;
DROP TABLE IF EXISTS api_keys CASCADE;
DROP TABLE IF EXISTS refresh_tokens CASCADE;
DROP TABLE IF EXISTS users CASCADE;

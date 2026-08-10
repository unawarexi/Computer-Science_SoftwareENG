DROP TRIGGER IF EXISTS update_fee_schedules_modtime ON fee_schedules;
DROP TABLE IF EXISTS fees CASCADE;
DROP TABLE IF EXISTS fee_schedules CASCADE;
DROP TYPE IF EXISTS fee_status;
DROP TYPE IF EXISTS fee_type;

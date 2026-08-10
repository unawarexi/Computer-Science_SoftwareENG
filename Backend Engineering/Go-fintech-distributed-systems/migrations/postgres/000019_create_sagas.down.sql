DROP TRIGGER IF EXISTS update_saga_steps_modtime ON saga_steps;
DROP TRIGGER IF EXISTS update_sagas_modtime ON sagas;
DROP TABLE IF EXISTS saga_steps CASCADE;
DROP TABLE IF EXISTS sagas CASCADE;
DROP TYPE IF EXISTS saga_step_status;
DROP TYPE IF EXISTS saga_status;

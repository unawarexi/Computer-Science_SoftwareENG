DROP TRIGGER IF EXISTS update_reconciliation_discrepancies_modtime ON reconciliation_discrepancies;
DROP TABLE IF EXISTS reconciliation_discrepancies CASCADE;
DROP TABLE IF EXISTS reconciliation_runs CASCADE;
DROP TYPE IF EXISTS discrepancy_status;
DROP TYPE IF EXISTS reconciliation_status;

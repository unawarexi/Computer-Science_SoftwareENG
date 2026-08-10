CREATE TYPE reconciliation_status AS ENUM ('RUNNING', 'COMPLETED_SUCCESS', 'COMPLETED_WITH_DISCREPANCIES', 'FAILED');
CREATE TYPE discrepancy_status AS ENUM ('OPEN', 'RESOLVED', 'IGNORED');

CREATE TABLE IF NOT EXISTS reconciliation_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id VARCHAR(50) NOT NULL, -- e.g., 'stripe', 'internal_ledger'
    run_date DATE NOT NULL,
    status reconciliation_status NOT NULL DEFAULT 'RUNNING',
    total_records_processed INT NOT NULL DEFAULT 0,
    total_discrepancies INT NOT NULL DEFAULT 0,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS reconciliation_discrepancies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    run_id UUID NOT NULL REFERENCES reconciliation_runs(id) ON DELETE CASCADE,
    transaction_id UUID REFERENCES transactions(id),
    provider_reference VARCHAR(100),
    type VARCHAR(100) NOT NULL, -- e.g., 'MISSING_IN_DB', 'AMOUNT_MISMATCH'
    internal_amount BIGINT,
    provider_amount BIGINT,
    currency VARCHAR(3),
    status discrepancy_status NOT NULL DEFAULT 'OPEN',
    resolution_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_reconciliation_runs_date ON reconciliation_runs(run_date);
CREATE INDEX idx_reconciliation_discrepancies_run ON reconciliation_discrepancies(run_id);
CREATE INDEX idx_reconciliation_discrepancies_status ON reconciliation_discrepancies(status);

CREATE TRIGGER update_reconciliation_discrepancies_modtime
    BEFORE UPDATE ON reconciliation_discrepancies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

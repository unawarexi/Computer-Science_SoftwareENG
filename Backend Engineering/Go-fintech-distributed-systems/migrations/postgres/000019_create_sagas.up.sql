CREATE TYPE saga_status AS ENUM ('STARTED', 'COMPLETED', 'ABORTED', 'COMPENSATING', 'COMPENSATED', 'FAILED_TO_COMPENSATE');
CREATE TYPE saga_step_status AS ENUM ('PENDING', 'STARTED', 'COMPLETED', 'FAILED', 'COMPENSATED');

CREATE TABLE IF NOT EXISTS sagas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    saga_type VARCHAR(255) NOT NULL,
    status saga_status NOT NULL DEFAULT 'STARTED',
    payload JSONB NOT NULL,
    current_step INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS saga_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    saga_id UUID NOT NULL REFERENCES sagas(id) ON DELETE CASCADE,
    step_name VARCHAR(255) NOT NULL,
    step_order INT NOT NULL,
    status saga_step_status NOT NULL DEFAULT 'PENDING',
    error TEXT,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE (saga_id, step_name),
    UNIQUE (saga_id, step_order)
);

CREATE INDEX idx_sagas_status ON sagas(status);
CREATE INDEX idx_saga_steps_saga ON saga_steps(saga_id);

CREATE TRIGGER update_sagas_modtime
    BEFORE UPDATE ON sagas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_saga_steps_modtime
    BEFORE UPDATE ON saga_steps
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

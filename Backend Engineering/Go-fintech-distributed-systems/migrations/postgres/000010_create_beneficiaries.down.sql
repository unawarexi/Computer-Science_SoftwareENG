ALTER TABLE payouts DROP CONSTRAINT IF EXISTS fk_payouts_beneficiary;

DROP TRIGGER IF EXISTS update_beneficiaries_modtime ON beneficiaries;
DROP TABLE IF EXISTS beneficiaries CASCADE;
DROP TYPE IF EXISTS beneficiary_status;

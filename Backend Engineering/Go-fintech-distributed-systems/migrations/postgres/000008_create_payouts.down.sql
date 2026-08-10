DROP TRIGGER IF EXISTS update_payouts_modtime ON payouts;
DROP TABLE IF EXISTS payouts CASCADE;
DROP TYPE IF EXISTS payout_method;
DROP TYPE IF EXISTS payout_status;

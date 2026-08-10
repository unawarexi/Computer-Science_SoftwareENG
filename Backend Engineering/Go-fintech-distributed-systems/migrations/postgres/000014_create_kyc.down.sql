DROP TRIGGER IF EXISTS update_kyc_verif_modtime ON kyc_verifications;
DROP TRIGGER IF EXISTS update_kyc_docs_modtime ON kyc_documents;
DROP TABLE IF EXISTS kyc_verifications CASCADE;
DROP TABLE IF EXISTS kyc_documents CASCADE;
DROP TYPE IF EXISTS verification_status;
DROP TYPE IF EXISTS document_type;

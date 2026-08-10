DROP TRIGGER IF EXISTS update_cards_modtime ON cards;
DROP TABLE IF EXISTS cards CASCADE;
DROP TYPE IF EXISTS card_status;
DROP TYPE IF EXISTS card_type;

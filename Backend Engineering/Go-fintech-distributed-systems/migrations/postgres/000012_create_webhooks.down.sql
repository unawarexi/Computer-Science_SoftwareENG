DROP TRIGGER IF EXISTS update_webhook_deliveries_modtime ON webhook_deliveries;
DROP TRIGGER IF EXISTS update_webhooks_modtime ON webhooks;
DROP TABLE IF EXISTS webhook_deliveries CASCADE;
DROP TABLE IF EXISTS webhooks CASCADE;
DROP TYPE IF EXISTS webhook_delivery_status;
DROP TYPE IF EXISTS webhook_status;

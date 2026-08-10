DROP TRIGGER IF EXISTS update_notification_queue_modtime ON notification_queue;
DROP TRIGGER IF EXISTS update_notification_templates_modtime ON notification_templates;
DROP TABLE IF EXISTS notification_queue CASCADE;
DROP TABLE IF EXISTS notification_templates CASCADE;
DROP TYPE IF EXISTS notification_status;
DROP TYPE IF EXISTS notification_type;

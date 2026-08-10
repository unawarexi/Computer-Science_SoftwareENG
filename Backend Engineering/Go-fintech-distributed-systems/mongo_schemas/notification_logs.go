package mongo_schemas

import "time"

// NotificationLog represents a record in the notification_logs MongoDB collection.
// It tracks the delivery status of emails, SMS, and push notifications.
type NotificationLog struct {
	ID           string                 `bson:"_id,omitempty" json:"id"`
	Type         string                 `bson:"type" json:"type"` // EMAIL, SMS, PUSH
	Recipient    string                 `bson:"recipient" json:"recipient"`
	Subject      string                 `bson:"subject,omitempty" json:"subject,omitempty"`
	BodyTemplate string                 `bson:"body_template,omitempty" json:"body_template,omitempty"`
	Status       string                 `bson:"status" json:"status"` // SENT, FAILED, DELIVERED, BOUNCED
	Provider     string                 `bson:"provider" json:"provider"` // e.g., Twilio, SendGrid
	ProviderID   string                 `bson:"provider_id,omitempty" json:"provider_id,omitempty"`
	ErrorMessage string                 `bson:"error_message,omitempty" json:"error_message,omitempty"`
	Metadata     map[string]interface{} `bson:"metadata,omitempty" json:"metadata,omitempty"`
	SentAt       time.Time              `bson:"sent_at" json:"sent_at"`
	CreatedAt    time.Time              `bson:"created_at" json:"created_at"`
}

package mongo_schemas

import "time"

// AnalyticsEvent represents a record in the analytics_events MongoDB collection.
// Used for tracking user behavior and business metrics.
type AnalyticsEvent struct {
	ID           string                 `bson:"_id,omitempty" json:"id"`
	EventType    string                 `bson:"event_type" json:"event_type"` // e.g., login, transfer_initiated
	CustomerID   string                 `bson:"customer_id,omitempty" json:"customer_id,omitempty"`
	SessionID    string                 `bson:"session_id,omitempty" json:"session_id,omitempty"`
	Properties   map[string]interface{} `bson:"properties" json:"properties"`
	Platform     string                 `bson:"platform" json:"platform"` // web, ios, android
	AppVersion   string                 `bson:"app_version,omitempty" json:"app_version,omitempty"`
	DeviceID     string                 `bson:"device_id,omitempty" json:"device_id,omitempty"`
	Timestamp    time.Time              `bson:"timestamp" json:"timestamp"`
}

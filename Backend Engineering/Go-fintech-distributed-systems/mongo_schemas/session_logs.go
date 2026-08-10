package mongo_schemas

import "time"

// SessionLog represents a record in the session_logs MongoDB collection.
// Used to track user sessions, active times, and logouts.
type SessionLog struct {
	ID           string    `bson:"_id,omitempty" json:"id"`
	SessionID    string    `bson:"session_id" json:"session_id"`
	CustomerID   string    `bson:"customer_id" json:"customer_id"`
	LoginTime    time.Time `bson:"login_time" json:"login_time"`
	LogoutTime   time.Time `bson:"logout_time,omitempty" json:"logout_time,omitempty"`
	DurationSecs int       `bson:"duration_secs,omitempty" json:"duration_secs,omitempty"`
	IPAddress    string    `bson:"ip_address" json:"ip_address"`
	UserAgent    string    `bson:"user_agent" json:"user_agent"`
	DeviceID     string    `bson:"device_id,omitempty" json:"device_id,omitempty"`
	IsActive     bool      `bson:"is_active" json:"is_active"`
	LogoutReason string    `bson:"logout_reason,omitempty" json:"logout_reason,omitempty"` // e.g., user_action, timeout, forced
}

package mongo_schemas

import "time"

// AuditLog represents a record in the audit_logs MongoDB collection.
// It is used to track all critical actions for compliance and debugging.
type AuditLog struct {
	ID        string                 `bson:"_id,omitempty" json:"id"`
	Action    string                 `bson:"action" json:"action"`
	ActorID   string                 `bson:"actor_id" json:"actor_id"` // User or System ID
	ActorType string                 `bson:"actor_type" json:"actor_type"`
	TargetID  string                 `bson:"target_id,omitempty" json:"target_id,omitempty"`
	TargetType string                `bson:"target_type,omitempty" json:"target_type,omitempty"`
	Changes   map[string]interface{} `bson:"changes,omitempty" json:"changes,omitempty"`
	IPAddress string                 `bson:"ip_address,omitempty" json:"ip_address,omitempty"`
	UserAgent string                 `bson:"user_agent,omitempty" json:"user_agent,omitempty"`
	Metadata  map[string]interface{} `bson:"metadata,omitempty" json:"metadata,omitempty"`
	CreatedAt time.Time              `bson:"created_at" json:"created_at"`
}

package mongo_schemas

import "time"

// DeviceFingerprint represents a record in the device_fingerprints MongoDB collection.
// Used by the fraud engine to track recognized and suspicious devices.
type DeviceFingerprint struct {
	ID                string                 `bson:"_id,omitempty" json:"id"`
	CustomerID        string                 `bson:"customer_id" json:"customer_id"`
	DeviceIdentifier  string                 `bson:"device_identifier" json:"device_identifier"` // Hash of device characteristics
	OS                string                 `bson:"os" json:"os"`
	Browser           string                 `bson:"browser,omitempty" json:"browser,omitempty"`
	IPAddresses       []string               `bson:"ip_addresses" json:"ip_addresses"`
	Locations         []string               `bson:"locations,omitempty" json:"locations,omitempty"` // GeoIP locations
	RiskScore         int                    `bson:"risk_score" json:"risk_score"`
	IsTrusted         bool                   `bson:"is_trusted" json:"is_trusted"`
	LastSeenAt        time.Time              `bson:"last_seen_at" json:"last_seen_at"`
	CreatedAt         time.Time              `bson:"created_at" json:"created_at"`
	FingerprintData   map[string]interface{} `bson:"fingerprint_data" json:"fingerprint_data"` // Raw data
}

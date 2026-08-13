package advancedtopics

import (
	"encoding/json"
	"fmt"
	"log"
)

// =============================================================================
// SECTION 1: Struct Tags
// Struct tags control how encoding/json maps between Go fields and JSON keys.
// Format: `json:"key_name,option1,option2"`
// =============================================================================

// User demonstrates the most common JSON struct tags.
type User struct {
	// "id" in JSON  →  ID in Go
	ID int `json:"id"`

	// "username" in JSON; field is omitted entirely from JSON output if empty
	Username string `json:"username,omitempty"`

	// The dash "-" completely excludes Password from JSON encoding/decoding —
	// critical for preventing sensitive data from leaking into API responses.
	Password string `json:"-"`

	// "email" in JSON; omitted when empty
	Email string `json:"email,omitempty"`
}

// Product shows how struct tags work with nested structs
type Product struct {
	ID    int     `json:"id"`
	Name  string  `json:"name"`
	Price float64 `json:"price"`
	// Nested struct — also must have tags
	Metadata ProductMeta `json:"metadata"`
}

type ProductMeta struct {
	InStock  bool   `json:"in_stock"`
	Category string `json:"category"`
}

// =============================================================================
// SECTION 2: Marshalling (Go → JSON)
// json.Marshal converts a Go value into a JSON-encoded []byte.
// json.MarshalIndent produces human-readable, pretty-printed JSON.
// =============================================================================

func demonstrateMarshalling() {
	fmt.Println("--- 2. Marshalling (Go → JSON) ---")

	user := User{ID: 1, Username: "alice", Password: "secret123", Email: "alice@example.com"}

	// Marshal to compact JSON
	jsonData, err := json.Marshal(user)
	if err != nil {
		log.Fatal("Marshal error:", err)
	}
	// Note: Password is absent because of `json:"-"`
	fmt.Println("Compact JSON:", string(jsonData))
	// Output: {"id":1,"username":"alice","email":"alice@example.com"}

	// Marshal a user with empty optional fields — omitempty fields are excluded
	partialUser := User{ID: 2}
	partialJSON, _ := json.Marshal(partialUser)
	fmt.Println("Partial (omitempty) JSON:", string(partialJSON))
	// Output: {"id":2}  — username and email are omitted

	// Pretty-print (indent) for human-readable output
	product := Product{
		ID:    42,
		Name:  "Laptop Pro",
		Price: 1299.99,
		Metadata: ProductMeta{InStock: true, Category: "Electronics"},
	}
	prettyJSON, _ := json.MarshalIndent(product, "", "  ")
	fmt.Println("Pretty JSON:\n", string(prettyJSON))
}

// =============================================================================
// SECTION 3: Unmarshalling (JSON → Go)
// json.Unmarshal parses a JSON []byte into a Go struct.
// You MUST pass a pointer so the json package can populate the struct.
// =============================================================================

func demonstrateUnmarshalling() {
	fmt.Println("\n--- 3. Unmarshalling (JSON → Go) ---")

	jsonString := []byte(`{"id": 2, "username": "bob", "email": "bob@example.com"}`)
	var user User

	// Pass a POINTER to the target struct — required for json.Unmarshal
	err := json.Unmarshal(jsonString, &user)
	if err != nil {
		log.Fatal("Unmarshal error:", err)
	}

	fmt.Printf("Unmarshalled User: ID=%d, Username=%s, Email=%s\n",
		user.ID, user.Username, user.Email)
	// Password will always be empty — the "-" tag means the JSON parser ignores it

	// Unmarshalling a JSON array into a Go slice
	jsonArray := []byte(`[{"id":1,"username":"alice"},{"id":2,"username":"bob"}]`)
	var users []User
	json.Unmarshal(jsonArray, &users)
	fmt.Printf("Parsed %d users from JSON array\n", len(users))
	for _, u := range users {
		fmt.Printf("  → ID: %d, Username: %s\n", u.ID, u.Username)
	}
}

// =============================================================================
// SECTION 4: Handling Unknown / Dynamic JSON
// When the JSON schema is not known ahead of time, unmarshal into
// map[string]interface{} and use type assertions to safely access values.
// =============================================================================

func demonstrateDynamicJSON() {
	fmt.Println("\n--- 4. Dynamic / Unknown JSON ---")

	rawJSON := []byte(`{"name": "Charlie", "age": 30, "active": true, "score": 98.5}`)

	var dynamicData map[string]interface{}
	if err := json.Unmarshal(rawJSON, &dynamicData); err != nil {
		log.Fatal(err)
	}

	// Type assertions are required — json.Unmarshal uses interface{} for all values
	if name, ok := dynamicData["name"].(string); ok {
		fmt.Println("Name:", name)
	}
	// JSON numbers become float64 by default when unmarshalling into interface{}
	if age, ok := dynamicData["age"].(float64); ok {
		fmt.Printf("Age: %.0f\n", age)
	}
	if active, ok := dynamicData["active"].(bool); ok {
		fmt.Println("Active:", active)
	}

	fmt.Println("⚠ Prefer strict structs when the JSON schema is known — use interface{} sparingly.")
}

// =============================================================================
// DemonstrateJSON runs all JSON encoding/decoding examples.
// =============================================================================
func DemonstrateJSON() {
	demonstrateMarshalling()
	demonstrateUnmarshalling()
	demonstrateDynamicJSON()
}

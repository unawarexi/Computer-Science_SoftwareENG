# JSON Parsing in Go

JSON (JavaScript Object Notation) is the standard format for communicating data over the web. Go provides a robust, built-in package called `encoding/json` to seamlessly translate between JSON strings and Go structs.

## 1. Struct Tags

In Go, you use **Struct Tags**—metadata attached to struct fields using backticks—to tell the JSON package exactly how to map JSON keys to Go struct fields. 

Because JSON keys are usually `camelCase` or `snake_case`, and Go exported fields must be `PascalCase` (capitalized), tags bridge this naming gap.

```go
type User struct {
    // Maps to "id" in JSON
    ID int `json:"id"`
    // Maps to "username", ignores the field if it's empty
    Username string `json:"username,omitempty"`
    // The dash "-" tells the JSON parser to completely ignore this field
    Password string `json:"-"`
}
```

## 2. Marshalling (Go to JSON)

Converting a Go struct, map, or slice into a JSON byte slice is called **Marshalling**.

```go
user := User{ID: 1, Username: "alice"}

// Convert to JSON
jsonData, err := json.Marshal(user)
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(jsonData)) // Output: {"id":1,"username":"alice"}
```

## 3. Unmarshalling (JSON to Go)

Converting raw JSON bytes back into structured Go data types is called **Unmarshalling**. You must provide a pointer to the struct so the `json` package can modify it.

```go
jsonString := []byte(`{"id": 2, "username": "bob"}`)
var user User

// Provide a pointer to 'user'
err := json.Unmarshal(jsonString, &user)
if err != nil {
    log.Fatal(err)
}
fmt.Println(user.Username) // Output: bob
```

## 4. Handling Unknown/Dynamic JSON

Sometimes you interact with APIs that return unstructured or unpredictable JSON, meaning you can't create a strict struct for it beforehand. In these cases, you can unmarshal JSON into a `map[string]interface{}`. 

```go
rawJSON := []byte(`{"name": "Charlie", "age": 30, "active": true}`)

var dynamicData map[string]interface{}
json.Unmarshal(rawJSON, &dynamicData)

// You must use type assertions to access the values safely
if name, ok := dynamicData["name"].(string); ok {
    fmt.Println("Name is:", name)
}
```
While flexible, using `interface{}` bypasses Go's type safety, so strict structs are strongly preferred whenever the JSON schema is known.

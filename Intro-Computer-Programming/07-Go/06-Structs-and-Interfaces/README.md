# 06: Structs and Interfaces in Go

Welcome to the guide on Structs and Interfaces! These two concepts are the core of Go's approach to object-oriented programming. Go doesn't have classes or inheritance; instead, it uses **structs** to group data and **interfaces** to define behavior. 

---

## 1. Structs
A struct (short for structure) is a typed collection of different fields. They are useful for grouping data together to form records.

### Defining and Initializing Structs
You define a struct using the `type` and `struct` keywords. You can initialize it by providing values for its fields.
```go
type Person struct {
    Name string
    Age  int
}
```
```go
// Initializing with field names
p := Person{Name: "Alice", Age: 30}
```

### Accessing and Modifying Fields
You access and modify the data inside a struct using dot `.` notation.
```go
p.Age = 31               // Modifying a field
fmt.Println(p.Name)      // Accessing a field
```

### Pointers to Structs
If you use a pointer to a struct, Go automatically dereferences the pointer when you access its fields. You don't need to write `(*p).Age`.
```go
pPointer := &p
pPointer.Age = 32 // Automatically dereferenced!
```

### Anonymous Structs
If you only need a struct for a single, one-off use (like sending a quick JSON response), you can declare and initialize it inline without naming it.
```go
user := struct{ Name string }{
    Name: "Bob",
}
```

### Nested vs Embedded Structs
To build complex structures without inheritance, Go uses composition. 
- **Nested Structs**: You give the inner struct a field name. You must access its fields via that name (`e.Home.City`).
- **Embedded Structs**: You omit the field name. Its fields are "promoted" to the parent, so you can access them directly (`e.Name`).
```go
type Address struct { City string }
type Employee struct {
    Home Address // Nested (e.Home.City)
    Person       // Embedded (e.Name)
}
```

### Struct Methods
You can define behaviors for your structs by attaching functions to them. This is done by adding a **receiver** argument between the `func` keyword and the function name.
```go
// 'p' is a value receiver
func (p Person) Greet() string {
    return "Hi, I am " + p.Name
}
```

### Pointer Receivers
If your method needs to modify the struct's data, or if the struct is very large and you want to avoid copying it, you must use a pointer receiver (`*Person`).
```go
func (p *Person) HaveBirthday() {
    p.Age++ // Modifies the original struct
}
```

### Struct Tags
Struct tags are small pieces of metadata added to fields. They are heavily used by libraries to control how the struct is encoded/decoded (like to JSON or database rows).
```go
type User struct {
    Name string `json:"username"`
    Age  int    `json:"age,omitempty"`
}
```

---

## 2. Interfaces
While structs define *data*, interfaces define *behavior*. An interface is a named collection of method signatures.

### Defining an Interface
You define an interface by listing the methods a type must have to satisfy it.
```go
type Speaker interface {
    Speak() string
}
```

### Implicit Implementation (Duck Typing)
In Go, you **do not** explicitly declare that a struct implements an interface (there is no `implements` keyword). If a struct has all the methods required by an interface, it implicitly implements it.
```go
type Dog struct{}
func (d Dog) Speak() string { return "Woof!" }
// Dog now automatically satisfies the Speaker interface!
```

### Using Interfaces
Interfaces are powerful because you can write functions that accept the interface, meaning they will accept *any* struct that implements it.
```go
func MakeSound(s Speaker) {
    fmt.Println(s.Speak())
}
```

### The Empty Interface (`any` / `interface{}`)
The empty interface has zero methods. Since every type has at least zero methods, the empty interface can hold **any** value. It's often used when a type is unknown (like generic print functions). *Note: In modern Go, you can just use the keyword `any`.*
```go
func PrintAnything(value any) {
    fmt.Println("Value is:", value)
}
```

### Type Assertions
If you have an interface variable but need to access the concrete value inside it, you use a type assertion. It extracts the underlying value.
```go
var i any = "hello"
str := i.(string) // Asserts that 'i' holds a string
```
To do this safely without panicking, use the two-value form:
```go
str, ok := i.(string)
if ok { /* safe to use str */ }
```

### Type Switches
If an interface could be one of several different types, a type switch is a clean way to handle the various possibilities.
```go
switch v := i.(type) {
case int:
    fmt.Println("It's an int:", v)
case string:
    fmt.Println("It's a string:", v)
}
```

### Interface Embedding
Just like structs, you can compose interfaces by embedding them within one another to create more complex contracts.
```go
type Reader interface { Read() }
type Writer interface { Write() }
type ReadWriter interface {
    Reader
    Writer
}
```

### Copier Interface (Prototype Pattern)
While there is no built-in `Copier` interface, defining one is a common pattern for creating deep copies (clones) of objects without knowing their exact type.
```go
type Copier interface {
    Copy() Copier
}
```

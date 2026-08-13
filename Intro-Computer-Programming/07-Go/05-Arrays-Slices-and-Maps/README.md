# 05: Arrays, Slices, and Maps in Go

Welcome to the guide on Go's core data structures for grouping values: Arrays, Slices, and Maps. 

---

## 1. Arrays
An array is a fixed-length sequence of elements of a single type. Because their size is fixed at compile-time, they are less flexible and less commonly used directly in Go compared to slices.

### Declaration and Initialization
You must specify the size and type. The size is part of the array's type.
```go
var nums [3]int            // Array of 3 integers (all initialized to 0)
names := [2]string{"Alice", "Bob"} // Initialized with values
```

### The `...` Ellipsis
You can let the Go compiler count the elements for you by using `...` instead of a number.
```go
colors := [...]string{"red", "green", "blue"}
fmt.Println(len(colors)) // Outputs: 3
```

### Accessing and Modifying
You access array elements using their zero-based index.
```go
nums[0] = 42
fmt.Println(nums[0]) // Outputs: 42
```

---

## 2. Slices
Slices are Go's dynamic, flexible wrapper around arrays. They are what you will use 99% of the time. A slice does not store data itself; it describes a section of an underlying array.

### Declaration and Initialization
A slice looks just like an array, but without a specified length.
```go
var emptySlice []int                     // nil slice
scores := []int{90, 85, 100}             // Initialized slice
```

### Using `make()`
To pre-allocate a slice with a specific length and capacity, use the built-in `make` function. This is highly recommended for performance when you know the approximate size.
```go
// make(type, length, capacity)
buffer := make([]byte, 5, 10) 
```

### Slicing Existing Arrays or Slices
You can create a slice from an existing array or slice by specifying a half-open range `[low:high]`.
```go
letters := []string{"a", "b", "c", "d"}
subset := letters[1:3] // Contains "b" and "c"
```

### Length vs Capacity (`len` and `cap`)
- **Length**: The number of elements currently in the slice.
- **Capacity**: The maximum number of elements the underlying array can hold.
```go
fmt.Println(len(buffer)) // Outputs 5
fmt.Println(cap(buffer)) // Outputs 10
```

### The `append()` Function
You add elements to a slice using `append`. If the underlying array is full, `append` automatically allocates a larger array and copies the data over.
```go
scores = append(scores, 95)
scores = append(scores, 88, 92) // Appending multiple items
```

---

## 3. Maps
A map is Go's built-in hash table (or dictionary). It stores unordered collections of key-value pairs, where keys must be uniquely identifiable.

### Declaration and Initialization
You define a map using `map[KeyType]ValueType`. Always initialize a map before writing to it, otherwise it will cause a runtime panic.
```go
// Using make()
ages := make(map[string]int)
ages["Alice"] = 30
```
```go
// Using a map literal
codes := map[string]string{"NY": "New York", "CA": "California"}
```

### Accessing and Modifying
You use the key inside square brackets to read or update a value.
```go
codes["TX"] = "Texas"        // Adding a new key-value pair
fmt.Println(codes["NY"])     // Reading a value
```

### The "Comma OK" Idiom (Checking Existence)
If you request a key that doesn't exist, Go returns the zero-value for that type. To distinguish between a missing key and a key that actually holds a zero-value, check the second return value.
```go
age, exists := ages["Bob"]
if !exists {
    fmt.Println("Bob is not in the map")
}
```

### Deleting Elements
You can remove a key-value pair from a map using the built-in `delete` function.
```go
delete(codes, "NY") // Removes the key "NY"
```

### Iterating Over Maps
You can iterate over the keys and values of a map using `range`. Remember: Map iteration order is intentionally randomized in Go!
```go
for key, value := range codes {
    fmt.Println(key, ":", value)
}
```

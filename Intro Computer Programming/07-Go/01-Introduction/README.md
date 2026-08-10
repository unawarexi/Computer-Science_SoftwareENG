# 01: Introduction to Go (Golang)

Welcome to the comprehensive introduction to the Go programming language! 

Go (often referred to as Golang due to its domain name, golang.org) is an open-source programming language designed by Google to make it easy to build simple, reliable, and efficient software.

To keep this introduction detailed and easy to digest, the content has been split into several focused documents:

1. [History and Purpose](file:///Users/mac/Desktop/Computer-Science_SoftwareENG/Intro%20Computer%20Programming/07-Go/01-Introduction/01-History-and-Purpose.md)
   - Discover why Go was created, who created it, and the core problems it aimed to solve.
2. [Strengths and Weaknesses](file:///Users/mac/Desktop/Computer-Science_SoftwareENG/Intro%20Computer%20Programming/07-Go/01-Introduction/02-Strengths-and-Weaknesses.md)
   - An objective look at where Go shines and where it falls short.
3. [Language Comparisons](file:///Users/mac/Desktop/Computer-Science_SoftwareENG/Intro%20Computer%20Programming/07-Go/01-Introduction/03-Comparisons.md)
   - How Go stacks up against Java, C++, Python, and Node.js.
4. [Use Cases and Applications](file:///Users/mac/Desktop/Computer-Science_SoftwareENG/Intro%20Computer%20Programming/07-Go/01-Introduction/04-Use-Cases.md)
   - Real-world applications and what you should (and shouldn't) build with Go.

---

### Getting Started (Hello World)

To write your first Go program, create a file named `main.go`:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

Run it using the terminal:
```bash
go run main.go
```

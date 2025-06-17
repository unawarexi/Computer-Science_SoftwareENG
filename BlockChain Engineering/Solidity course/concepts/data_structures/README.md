# Solidity Data Structures — Student-Friendly Explanations

This note explains the main data structures used in Solidity smart contracts. Understanding these is essential for organizing and storing data on the Ethereum blockchain.

---

## 📦 What Are Data Structures?

Data structures help you store, organize, and manage data efficiently. In Solidity, the most common data structures include:

- Arrays
- Mappings
- Structs
- Enums

Each one has unique use cases. Let’s break them down with examples and real-world explanations.

---

## 📋 Arrays

Arrays are ordered collections of items of the same type.

| Type         | Description                   |
|--------------|------------------------------|
| Fixed-size   | Has a predefined length       |
| Dynamic-size | Grows or shrinks at runtime  |

**Example:**
```solidity
string[3] fixedArray = ["Alice", "Bob", "Carol"];
string[] public dynamicArray;

function addName(string memory name) public {
    dynamicArray.push(name);
}
```

**Key Functions:**

| Function   | Description                          |
|------------|--------------------------------------|
| `.push()`  | Adds an element (only for dynamic)   |
| `.length`  | Returns number of elements           |
| `[index]`  | Access element by index              |
| `.pop()`   | Removes last element                 |

---

## 🗺️ Mappings (Key-Value Store)

Mappings are like dictionaries or hash maps in other languages. They link a key to a value.

```solidity
mapping(address => uint) public balances;
```

**How It Works:**

| Term  | Meaning                        |
|-------|--------------------------------|
| Key   | The lookup field (e.g., address)|
| Value | The stored data (e.g., uint)   |

**Example:**
```solidity
function updateBalance(address user, uint amount) public {
    balances[user] = amount;
}

function getBalance(address user) public view returns (uint) {
    return balances[user];
}
```
> 🧠 **Note:** You can’t loop over a mapping — it doesn’t keep track of keys!

---

## 🧱 Structs (Custom Data Types)

Structs allow you to group related data into a single unit.

**Real-World Analogy:**  
Think of a Student record with name, age, and score.

**Example:**
```solidity
struct Student {
    string name;
    uint age;
    uint score;
}

Student public student;

function setStudent(string memory _name, uint _age, uint _score) public {
    student = Student(_name, _age, _score);
}
```

**Structs in Arrays:**
```solidity
Student[] public students;

function addStudent(string memory _name, uint _age, uint _score) public {
    students.push(Student(_name, _age, _score));
}
```

---

## 🎛️ Enums (Options)

Enums are used to define named constant options — great for tracking states or choices.

**Example:**
```solidity
enum Status { Pending, Approved, Rejected }

Status public applicationStatus;

function approve() public {
    applicationStatus = Status.Approved;
}

function isApproved() public view returns (bool) {
    return applicationStatus == Status.Approved;
}
```
> 🧠 **Note:** Enums are stored as uint internally (`Pending = 0`, `Approved = 1`, etc.).

---

## 🔁 Nested Structures

You can combine arrays, mappings, structs, and enums to create complex systems.

**Example:**
```solidity
struct Product {
    string name;
    uint price;
}

mapping(uint => Product) public productCatalog;
```

---

## ✅ Quick Summary Table

| Data Structure | Purpose         | Supports Loops? | Modifiers/Notes              |
|----------------|----------------|-----------------|------------------------------|
| Array          | Ordered list   | ✅ Yes          | .push(), .pop(), [i]         |
| Mapping        | Key-value pair | ❌ No           | [key] = value                |
| Struct         | Custom model   | ✅ Yes (in array)| N/A                          |
| Enum           | Named states   | ✅ Yes (as uint) | EnumType.Value               |


---

## 💡 Pro Tips for Students

- Use arrays when order matters and you need to loop.
- Use mappings for fast lookup.
- Use structs to group related data.
- Use enums for clear, readable states.
- Combine them for powerful and flexible data systems.

---

## 📘 Further Reading

- [Solidity Docs – Arrays](https://docs.soliditylang.org/en/latest/types.html#arrays)
- [Solidity Docs – Mappings](https://docs.soliditylang.org/en/latest/types.html#mappings)
- [Solidity Docs – Structs](https://docs.soliditylang.org/en/latest/types.html#structs)
- [Solidity Docs – Enums](https://docs.soliditylang.org/en/latest/types.html#enums)
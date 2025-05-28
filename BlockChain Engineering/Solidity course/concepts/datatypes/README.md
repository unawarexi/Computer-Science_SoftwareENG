# Solidity Data Types - Advanced Guide

Solidity is a statically-typed language, which means each variable must be declared with a type at compile time. Solidity’s type system is rich and includes primitive types, custom user-defined types, and complex storage-specific rules.

This guide serves as a comprehensive reference for all Solidity data types and their advanced use-cases.

---

## 🧠 Table of Contents

- [✅ Value Types](#-value-types)
- [📦 Reference Types](#-reference-types)
- [🎯 Special Types](#-special-types)
- [🧩 Storage vs Memory vs Calldata](#-storage-vs-memory-vs-calldata)
- [⛽ Data Location and Gas Optimization](#-data-location-and-gas-optimization)
- [🔁 Type Conversions](#-type-conversions)
- [🧬 Advanced Concepts](#-advanced-concepts)
- [📐 Best Practices](#-best-practices)
- [📚 Resources](#-resources)
- [📌 Conclusion](#-conclusion)

---

## ✅ Value Types

Value types hold data directly in the variable and are always copied when assigned or passed to functions.

### 1. Boolean

A boolean can be either `true` or `false`.

```solidity
bool isComplete = true;
```
- Logical operators: `&&`, `||`, `!`
- Comparison: `==`, `!=`

### 2. Integers

Solidity supports both signed and unsigned integers of various sizes.

**Signed:**
```solidity
int256 x = -42;
```
**Unsigned:**
```solidity
uint256 y = 42;
```
- Ranges:
  - `int8` → [-128, 127]
  - `uint8` → [0, 255]
  - `int256` / `uint256` are common default types
- Arithmetic: `+`, `-`, `*`, `/`, `%`, `**`
- Bitwise: `&`, `|`, `^`, `~`, `<<`, `>>`

### 3. Fixed Point Numbers

_Not fully implemented yet in Solidity._

```solidity
// Not supported in current versions.
```

### 4. Address

Represents a 20-byte Ethereum address.

```solidity
address owner;
```
- Used to interact with contracts or external accounts

### 5. Address Payable

Allows sending Ether to the address.

```solidity
address payable recipient;
recipient.transfer(1 ether);
```

### 6. Bytes

**Fixed-size:**
```solidity
bytes1 a = 0x12;
bytes32 b = 0xabcd...;
```
**Dynamic-size:**
```solidity
bytes memory data = "hello";
```

### 7. Enums

Enums are user-defined types for a variable with a set of predefined constants.

```solidity
enum Status { Pending, Shipped, Delivered }
Status public status;
```
- Defaults to the first item
- Underlying type is `uint8`

---

## 📦 Reference Types

Reference types hold references to actual data stored elsewhere.

### 1. Arrays

**Fixed-size:**
```solidity
uint[3] numbers;
```
**Dynamic-size:**
```solidity
uint[] numbers;
```
**Multidimensional:**
```solidity
uint[][] memory matrix;
```

### 2. Strings

Strings are UTF-8 encoded and stored as dynamic arrays of bytes.

```solidity
string memory name = "Solidity";
```
- Not directly indexable (convert to bytes first)

### 3. Structs

Structs are custom data types that group variables.

```solidity
struct User {
    string name;
    uint age;
}
User public user;
```
- Can be nested
- Often used with mappings

### 4. Mappings

Mappings are key-value stores, only available in storage.

```solidity
mapping(address => uint) public balances;
```
- Only in storage
- Cannot iterate or delete keys directly
- Can be nested:
  ```solidity
  mapping(address => mapping(uint => bool)) nested;
  ```

---

## 🎯 Special Types

### Address Types

- `address`: basic address type
- `address payable`: allows transfer and send of Ether

### Function Types

Functions can be assigned to variables.

**Internal:**
```solidity
function(uint, uint) internal pure returns (uint)
```
**External:**
```solidity
function(uint, uint) external view returns (uint)
```

### `type(x)`

Used for introspection and getting type-related information.

```solidity
type(MyContract).creationCode
type(MyContract).runtimeCode
type(uint8).max
```

### `this` and `super`

- `this`: refers to the current contract (external context)
- `super`: used for accessing parent contract functions

---

## 🧩 Storage vs Memory vs Calldata

| Type     | Location    | Mutability | Use Case                        |
|----------|-------------|------------|---------------------------------|
| storage  | Persistent  | Mutable    | State variables                 |
| memory   | Temporary   | Mutable    | Local variables, function args  |
| calldata | Temporary   | Immutable  | External function inputs        |

**Example:**
```solidity
function foo(uint[] calldata x) external { }
```

---

## ⛽ Data Location and Gas Optimization

- Use `calldata` for read-only parameters to reduce gas
- Avoid copying large structs or arrays
- Pack tightly using smaller data types (e.g. `uint8`, `bool`) for storage efficiency

---

## 🔁 Type Conversions

### Implicit Conversion

```solidity
uint8 x = 8;
uint256 y = x;
```

### Explicit Conversion

```solidity
uint256 a = uint256(int256(-5));
```
> **Warning:** Be careful with signed to unsigned casts to avoid unexpected results.

---

## 🧬 Advanced Concepts

### ABI Encoding

Solidity provides several encoding functions for ABI compatibility.

```solidity
abi.encode(a, b)
abi.encodePacked(a, b)
abi.encodeWithSignature("foo(uint256)", 123)
```

### Storage Layout

Variables are packed into 32-byte slots. Smaller types share slots if defined together.

**Packed vs Unpacked Example:**
```solidity
// Better packing
uint128 a;
uint128 b;

// Wastes space
uint128 a;
bool b;
```

### Hashing and Mappings

Mappings are stored using a hash of the key and the storage slot.

```solidity
keccak256(abi.encodePacked(key, slot))
```

---

## 📐 Best Practices

- Use the smallest `uint` type sufficient for your data
- Avoid string comparison—prefer hashing (`keccak256`)
- Avoid deep nesting of arrays and mappings
- Always specify data location (`memory`, `calldata`)
- Use `uint256` unless you have a strong reason otherwise

---

## 📚 Resources

- [Solidity Docs](https://docs.soliditylang.org)
- [Solidity by Example](https://solidity-by-example.org)
- [Ethereum StackExchange](https://ethereum.stackexchange.com)
- [Remix IDE](https://remix.ethereum.org)

---

## 📌 Conclusion

Solidity's data types form the foundation of Ethereum smart contract development. Mastery over them enables safer, optimized, and gas-efficient code. Always keep storage layout and data location in mind for best results.
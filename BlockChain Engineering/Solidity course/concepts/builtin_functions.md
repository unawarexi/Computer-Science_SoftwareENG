# 📜 Solidity Built-in Functions & Globals

Solidity provides a rich set of built-in functions, global variables, and keywords that are essential for smart contract development. This reference summarizes the most important ones, grouped by category for easy lookup.

---

## Built-in Functions & Global Variables

| Name / Syntax | Type | Description |
|---------------|------|-------------|
| `assert(bool condition)` | Built-in Function | Halts execution and reverts if condition is false. Used for internal errors and invariants. |
| `require(bool condition)` | Built-in Function | Halts execution and reverts if condition is false. Common for input validation and access control. |
| `require(bool, string)` | Built-in Function | Same as above but with a custom error message. |
| `revert()` | Built-in Function | Reverts the transaction, refunds remaining gas. |
| `revert(string)` | Built-in Function | Reverts with a custom message. |
| `block.timestamp` | Global Variable | Current block's timestamp in seconds since epoch. |
| `block.number` | Global Variable | Current block number. |
| `block.difficulty` | Global Variable | Block difficulty. |
| `block.gaslimit` | Global Variable | Maximum gas allowed in this block. |
| `msg.sender` | Global Variable | Address of the function caller. |
| `msg.value` | Global Variable | Amount of wei sent with the call. |
| `msg.data` | Global Variable | Complete calldata. |
| `msg.sig` | Global Variable | First 4 bytes of calldata (function selector). |
| `tx.origin` | Global Variable | Origin of transaction (never use for auth). |
| `tx.gasprice` | Global Variable | Gas price of the transaction. |
| `gasleft()` | Built-in Function | Returns remaining gas. |
| `keccak256(bytes memory)` | Built-in Function | Hash function (same as SHA3). |
| `sha256(bytes memory)` | Built-in Function | SHA-2 hash function. |
| `ripemd160(bytes memory)` | Built-in Function | RIPEMD-160 hash function. |
| `ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)` | Built-in Function | Recovers the address that signed a hashed message. |
| `addmod(uint x, uint y, uint k)` | Built-in Function | `(x + y) % k`, modulo addition without overflow. |
| `mulmod(uint x, uint y, uint k)` | Built-in Function | `(x * y) % k`, modulo multiplication without overflow. |
| `this` | Keyword | Current contract as an address payable. |
| `super` | Keyword | Refers to the parent contract. |
| `now` (deprecated) | Global Variable | Alias for `block.timestamp`. |
| `type(C).creationCode` | Built-in | Bytecode to deploy contract `C`. |
| `type(C).runtimeCode` | Built-in | Bytecode of contract `C` after deployment. |
| `type(T).min / max` | Built-in | Min or max value of integer type `T`. |
| `new Contract()` | Keyword | Used to deploy a new contract instance. |
| `abi.encode(...)` | Built-in | Encodes arguments into ABI-compliant bytes. |
| `abi.encodePacked(...)` | Built-in | Packed version of ABI encoding. |
| `abi.encodeWithSelector(...)` | Built-in | Encodes data with a function selector. |
| `abi.encodeWithSignature(...)` | Built-in | Encodes data using function signature string. |
| `blockhash(uint blockNumber)` | Built-in | Returns hash of a given block (last 256 blocks). |
| `balance(address)` | Global | Returns balance of address in wei. |
| `selfdestruct(address)` | Built-in Function | Destroys the contract and sends funds to address. |

---

## 🔑 Solidity Reserved Keywords

Solidity has a set of reserved keywords and special constructs that define the structure and behavior of contracts.

| Keyword / Syntax | Type | Description |
|------------------|------|-------------|
| `contract` | Keyword | Defines a new contract. |
| `interface` | Keyword | Defines an interface for contracts. |
| `library` | Keyword | Defines a library (stateless code). |
| `struct` | Keyword | Defines a custom struct type. |
| `enum` | Keyword | Defines an enum type. |
| `function` | Keyword | Declares a function. |
| `modifier` | Keyword | Declares a modifier. |
| `event` | Keyword | Declares an event to be emitted. |
| `constructor` | Keyword | Special function run only once when contract is deployed. |
| `fallback()` | Function | Called when no other function matches or `msg.data` is empty. |
| `receive()` | Function | Special fallback for `receive()` Ether. |
| `returns` | Keyword | Specifies function return types. |
| `public` | Visibility | Anyone can call. |
| `private` | Visibility | Only visible within current contract. |
| `internal` | Visibility | Visible in contract and derived contracts. |
| `external` | Visibility | Only callable from outside the contract. |
| `view` | Function Modifier | Does not alter state. |
| `pure` | Function Modifier | Does not read or write to state. |
| `payable` | Modifier | Function can receive Ether. |
| `memory` | Data Location | Temporary memory, cleaned after function ends. |
| `storage` | Data Location | Persistent storage on blockchain. |
| `calldata` | Data Location | Read-only data passed to external functions. |
| `if`, `else` | Control Flow | Conditional branching. |
| `for`, `while`, `do` | Control Flow | Loops. |
| `break`, `continue` | Control Flow | Loop control. |
| `return` | Control Flow | Exits function with optional return value. |
| `import` | Keyword | Import other files or libraries. |
| `pragma` | Keyword | Defines compiler version or directives. |
| `emit` | Keyword | Triggers an event. |
| `is` | Keyword | Inheritance from base contracts. |
| `try`, `catch` | Error Handling | Handle failed external calls. |
| `assembly` | Keyword | Allows inline Yul/assembly code. |
| `unchecked` | Keyword | Skips overflow/underflow checks. |

---

> **Tip:**  
> Use these tables as a quick reference while writing or reviewing Solidity code. Understanding built-in functions, globals, and reserved keywords is essential for writing secure and efficient smart contracts.


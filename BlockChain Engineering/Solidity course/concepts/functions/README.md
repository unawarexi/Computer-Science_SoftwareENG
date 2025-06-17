# Solidity Functions — Student-Friendly Explanation

Solidity functions are the building blocks of smart contracts. This note explains how functions work in Solidity, including their types, behaviors, and best practices.

---

## 📚 What is a Function?

A function in Solidity is a reusable block of code that performs a specific task. Functions can:
- Read or modify contract state
- Accept inputs (parameters)
- Return outputs
- Call other contracts
- Receive Ether (in some cases)

---

## ✍️ Function Syntax

```solidity
function functionName(Type param1, Type param2) public view returns (Type) {
    // logic here
}
```

---

## 🔑 Function Visibility

Visibility determines who can call the function.

| Visibility | Who Can Call?                    | Used For                        |
|------------|----------------------------------|---------------------------------|
| `public`   | Everyone (including contracts)   | Default for accessible APIs     |
| `external` | Only other contracts or accounts | Slightly cheaper gas than public|
| `internal` | Only this contract & inherited   | Reusable internal logic         |
| `private`  | Only this contract               | Restrict internal logic further |

**Examples:**
```solidity
function publicFunc() public {}
function externalFunc() external {}
function internalFunc() internal {}
function privateFunc() private {}
```

---

## 🧱 State Mutability

These keywords describe how a function interacts with the blockchain state.

| Keyword   | Description                                 |
|-----------|---------------------------------------------|
| `view`    | Reads from the state (no gas if external)   |
| `pure`    | Does not read or modify the state           |
| `payable` | Can receive Ether                           |
| (none)    | Can read and write to the state             |

**Example:**
```solidity
function getBalance() public view returns (uint) {
    return address(this).balance;
}

function add(uint a, uint b) public pure returns (uint) {
    return a + b;
}

function receiveEther() public payable {}
```

---

## 🔁 Function Parameters & Return Values

Functions can accept inputs and return outputs.

**Input Parameters:**
```solidity
function setName(string memory _name) public {
    name = _name;
}
```

**Return Values:**
```solidity
function getAge() public view returns (uint) {
    return age;
}
```

**Multiple Returns:**
```solidity
function getData() public view returns (uint, string memory) {
    return (id, name);
}
```

---

## 🏷️ Named Return Variables

You can name output variables instead of using `return`.

```solidity
function getInfo() public view returns (uint age, string memory name) {
    age = 25;
    name = "Andrew";
}
```

---

## 🔒 Modifiers (Access Control for Functions)

Modifiers control how and when functions can run.

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function secureFunction() public onlyOwner {
    // protected logic
}
```

---

## 🔄 Internal Function Calls

Functions can call each other.

```solidity
function total() public view returns (uint) {
    return add(5, 10);
}

function add(uint x, uint y) internal pure returns (uint) {
    return x + y;
}
```

---

## 🔁 Fallback & Receive Functions

Solidity provides two special functions for handling Ether transfers and unknown function calls:

### **Receive Function**

The `receive()` function is a special external payable function that is triggered when the contract receives plain Ether (no data sent). It enables your contract to accept Ether transfers using `.send()`, `.transfer()`, or a simple value transfer.

```solidity
receive() external payable {
    // Custom logic (optional)
}
```
- Only one `receive()` function can be defined per contract.
- It must be marked `external` and `payable`.
- If not present, plain Ether transfers will fail unless a fallback function is defined and marked payable.

### **Fallback Function**

The `fallback()` function is called when:
- The contract receives data that does not match any function signature.
- Ether is sent with data, or when no `receive()` function exists.

```solidity
fallback() external payable {
    // Handles unknown calls or Ether with data
}
```
- Can be marked `payable` to accept Ether, or not payable to reject Ether.
- Useful for logging, proxy contracts, or handling unexpected calls.

**Summary Table:**

| Function   | Triggered When...                                      | Can Receive Ether? | Typical Use Case                      |
|------------|--------------------------------------------------------|--------------------|---------------------------------------|
| `receive()`| Contract receives plain Ether (no data)                | Yes                | Accepting Ether transfers             |
| `fallback()`| Unknown function called or Ether sent with data        | Yes/No             | Handling unknown calls, logging, proxy|

---

## 🔃 Function Overloading

Solidity supports multiple functions with the same name but different parameters.

```solidity
function set(uint x) public {}
function set(string memory x) public {}
```

---

## 🧠 Tips for Students

- Use `view` when reading from the blockchain to save gas.
- Use `pure` when your function doesn’t touch the blockchain.
- Always validate input and use `require()` for security.
- Learn modifiers to control access and logic reuse.
- Use visibility (`private`, `public`, etc.) to prevent unintended calls.

---

## 🧾 Resources

- [Solidity Official Docs – Functions](https://docs.soliditylang.org/en/latest/contracts.html#functions)
- [Solidity by Example – Functions](https://solidity-by-example.org/function)
- [Remix IDE for Testing](https://remix.ethereum.org/)
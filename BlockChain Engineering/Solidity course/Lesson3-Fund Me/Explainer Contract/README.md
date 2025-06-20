# Review of Sending ETH and working with Chainlink

## Interfaces & Price Feeds
- **Chainlink Price Feeds (Data Feeds):** Chainlink provides decentralized data feeds, including price feeds, to smart contracts, ensuring reliable and tamper-proof data.
- **Chainlink GitHub:** Chainlink's GitHub repository contains its source code, documentation, and resources for developers.
- **Interface:** In Solidity, an interface defines the functions and events a contract must implement without providing the implementation itself.
- **Importing from GitHub & NPM:** Developers can import Solidity contracts or libraries from GitHub repositories or NPM, facilitating code reuse.
- **Chainlink NPM Package:** Chainlink offers an NPM package for easy access to its functionality in Solidity projects.

## Floating Point Math in Solidity
- **tuple:** A data structure in Solidity used to group together multiple variables of possibly different types under a single name.
- **Floating Point Numbers in Solidity:** Explanation of how floating-point arithmetic works in Solidity, including its limitations and potential issues.
- **Type Casting:** The process of converting a variable from one data type to another, often necessary in Solidity due to its strict typing system.

## Gas Estimation Failed
- An error message encountered during smart contract development indicating that the estimation of gas usage failed. It often requires further investigation to determine the cause and resolve the issue.

## Basic Solidity: Arrays & Structs II
- **msg.sender:** A global variable in Solidity representing the address of the sender of the current message.

| Global Variables/Built-in Functions | Description/Use Cases                                    |
|-------------------------------------|----------------------------------------------------------|
| **Global Variables**                |                                                          |
| `msg.sender`                        | Returns the address of the sender of the message.        |
| `msg.value`                         | Returns the amount of Ether sent with the message.       |
| `msg.data`                          | Returns the complete calldata.                           |
| `msg.sig`                           | Returns the first four bytes of the calldata (function signature). |
| `now` or `block.timestamp`          | Current block timestamp (alias for `block.timestamp`).   |
| `block.number`                      | Current block number.                                    |
| `block.difficulty`                  | Current block difficulty.                                |
| `block.coinbase`                    | Address of the miner of the current block.              |
| `block.gaslimit`                    | Gas limit of the current block.                          |
| `tx.origin`                         | Address of the sender of the transaction (full call chain). |
| `tx.gasprice`                       | Gas price of the transaction.                            |
| `tx.origin`                         | Address of the sender of the transaction (full call chain). |
| `this`                              | Current contract's address.                              |
| `address(this)`                     | Address of the current contract.                         |
| `blockhash(uint blockNumber) returns (bytes32)` | Returns hash of the given block number.         |
| `keccak256(...)`                    | Compute the Ethereum-SHA-3 (Keccak-256) hash.            |
| `sha256(...) returns (bytes32)`     | Compute the SHA-256 hash.                                |
| `sha3(...) returns (bytes32)`       | Compute the Ethereum-SHA-3 (Keccak-256) hash (alias for `keccak256`). |
| `ripemd160(...) returns (bytes20)`  | Compute the RIPEMD-160 hash.                             |
| `ecrecover(...)`                    | Recover the address associated with the public key from elliptic curve signature. |
| `addmod(uint x, uint y, uint k) returns (uint)` | Computes `(x + y) % k` with gas-efficient modular exponentiation. |
| `mulmod(uint x, uint y, uint k) returns (uint)` | Computes `(x * y) % k` with gas-efficient modular exponentiation. |
| `selfdestruct(address recipient)`  | Destroys the current contract, sending its funds to the specified address. |
| `delegatecall(...)`                 | Calls a function in another contract while preserving the caller's context. |
| `staticcall(...)`                   | Calls a function in another contract without modifying the caller's context. |
| `blockhash(uint blockNumber) returns (bytes32)` | Returns hash of the given block number.                   |
| **Built-in Functions**              |                                                          |
| `assert(bool condition)`            | Checks for a condition and throws an error if false.     |
| `require(bool condition)`           | Checks for a condition and throws an error if false.     |
| `revert()`                          | Abort execution and revert state changes.                |
| `keccak256(...)`                    | Computes the Ethereum-SHA-3 (Keccak-256) hash.           |
| `sha256(...) returns (bytes32)`     | Computes the SHA-256 hash.                               |
| `sha3(...) returns (bytes32)`       | Computes the Ethereum-SHA-3 (Keccak-256) hash (alias for `keccak256`). |
| `ripemd160(...) returns (bytes20)`  | Computes the RIPEMD-160 hash.                            |
| `ecrecover(...)`                    | Recovers the address associated with the public key from elliptic curve signature. |
| `addmod(uint x, uint y, uint k) returns (uint)` | Computes `(x + y) % k` with gas-efficient modular exponentiation. |
| `mulmod(uint x, uint y, uint k) returns (uint)` | Computes `(x * y) % k` with gas-efficient modular exponentiation. |
| `keccak256(...) returns (bytes32)`  | Computes the Ethereum-SHA-3 (Keccak-256) hash.           |
| `sha256(...) returns (bytes32)`     | Computes the SHA-256 hash.                               |
| `sha3(...) returns (bytes32)`       | Computes the Ethereum-SHA-3 (Keccak-256) hash (alias for `keccak256`). |
| `ripemd160(...) returns (bytes20)`  | Computes the RIPEMD-160 hash.                            |
| `ecrecover(...)`                    | Recovers the address associated with the public key from elliptic curve signature. |
| `addmod(uint x, uint y, uint k) returns (uint)` | Computes `(x + y) % k` with gas-efficient modular exponentiation. |
| `mulmod(uint x, uint y, uint k) returns (uint)` | Computes `(x * y) % k` with gas-efficient modular exponentiation. |
| `selfdestruct(address recipient)`  | Destroys the current contract, sending its funds to the specified address. |
| `delegatecall(...)`                 | Calls a function in another contract while preserving the caller's context. |
| `staticcall(...)`                   | Calls a function in another contract without modifying the caller's context. |


## Review of Interfaces, Importing from GitHub, & Math in Solidity
- **Libraries:** Reusable Solidity code that can be deployed and linked to other contracts.
- **Solidity-by-example Library:** A library providing examples and best practices for writing Solidity code.
- **SafeMath, Overflow Checking, and the "unchecked" keyword:** Techniques to prevent arithmetic overflow and underflow in Solidity, ensuring safe mathematical operations.
- **Openzeppelin Safemath:** A library for safe mathematical operations in Solidity, provided by OpenZeppelin.
- **unchecked vs. checked:** Comparison between checked and unchecked arithmetic operations in Solidity.

## Basic Solidity: For Loop
- **For Loop:** A control flow statement in Solidity used for iterating over a range of values.
- **/* */ is another way to make comments:** An alternative method for adding comments in Solidity using the /* */ syntax.

## Basic Solidity: Resetting an Array

## Sending ETH from a Contract
- **Transfer, Send, Call:**  
  - **transfer:** Forwards a fixed 2300 gas stipend, reverts on failure. Simple and safe, but may fail if the recipient needs more gas.
  - **send:** Also forwards 2300 gas, but returns a boolean indicating success or failure (does not revert automatically). You must handle failures manually.
  - **call:** The recommended and most flexible way. Forwards all remaining gas by default, returns a boolean and data. Must check the return value for success and is more prone to reentrancy attacks if not used carefully.

- **this keyword:** Refers to the current contract instance within Solidity code.

## Basic Solidity: Constructor
- **Constructor:** A special function in a Solidity contract that is executed only once upon deployment, typically used for initializing contract state variables.

## Basic Solidity: Modifiers
- **Double equals:** A comparison operator in Solidity used to check for equality between two values.
- **Modifier:** A feature in Solidity used to enforce conditions before executing a function.

## Testnet Demo
- **Disconnecting Metamask:** Instructions on how to disconnect the Metamask wallet from a testnet environment.

## Advanced Solidity
- **Immutable & Constant:** Keywords in Solidity used to declare variables that cannot be modified after initialization.
- **Immutable:** A state variable in Solidity that cannot be modified after its initial assignment.
- **Constant:** A function in Solidity that does not modify the state and does not consume gas when called.

## Current ETH Gas Prices
- Advice against stressing about gas optimizations, particularly for beginners in Ethereum development.

## Naming Conventions
- A suggestion for someone to create documentation or guidelines regarding naming conventions in Solidity.

## Custom Errors
- Introduction to custom error handling in Solidity, allowing developers to define and handle custom error conditions.

## Receive & Fallback Functions
- **Fallback:** A special function in Solidity invoked when a contract receives Ether without specifying a function to call.
- **Receive:** A new special function introduced in Solidity version 0.6.0, invoked when a contract receives Ether, replacing the fallback function.

### Simple & Deep Explanation: `receive` and `fallback` Functions

#### What are they?
- **receive()** and **fallback()** are special functions in Solidity that control how your contract reacts when it receives Ether (ETH) or unknown function calls.

#### When are they triggered?
- **receive()** is called **only** when your contract receives plain ETH (no data attached).
- **fallback()** is called when:
  - The contract receives ETH **with data** (for example, someone tries to call a function that doesn't exist).
  - Or, if `receive()` does not exist, any ETH sent to the contract will trigger `fallback()`.

#### Why do we use them?
- To make sure your contract can **accept ETH** sent directly (for example, from a wallet or another contract).
- To handle **unexpected function calls** or data, so your contract doesn't just fail or lose ETH.
- To add custom logic for receiving ETH, like logging, restricting who can send ETH, or forwarding ETH elsewhere.

#### Which one should you use?
- Use **receive()** if you want your contract to accept ETH sent with no data (most common for simple payments or donations).
- Use **fallback()** if you want to handle:
  - ETH sent with data (for example, by mistake or by calling a non-existent function).
  - Any unknown function calls (for example, to log or reject them).

#### Example

```solidity
// Example contract with both receive and fallback
contract Example {
    // Called when contract receives ETH with no data
    receive() external payable {
        // Accept ETH, maybe log or take action
    }

    // Called when contract receives ETH with data or unknown function call
    fallback() external payable {
        // Handle unexpected calls or ETH with data
    }
}
```

#### Summary Table

| Situation                        | Function Triggered |
|-----------------------------------|-------------------|
| ETH sent, no data                 | receive()         |
| ETH sent, with data               | fallback()        |
| Unknown function called (no ETH)  | fallback()        |
| No receive(), ETH sent, no data   | fallback()        |

---


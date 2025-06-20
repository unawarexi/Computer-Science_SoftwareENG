# Solidity Error Handling Guide

This document covers error handling in Solidity, including the main mechanisms for detecting, reporting, and managing errors in smart contracts.

---

## Error Handling Keywords

These keywords are used to handle errors and control execution flow when something goes wrong.

### `revert()`

Stops execution and reverts all state changes, optionally with an error message.

```solidity
revert("Something went wrong");
```

### `require()`

Checks a condition and reverts if false. Commonly used for input validation and access control.

```solidity
require(msg.sender == owner, "Not authorized");
```

### `assert()`

Used to check for conditions that should **never** be false (internal errors or invariants). If the condition fails, all gas is consumed.

```solidity
assert(balance >= 0); // Should never fail
```

---

## try-catch for External Calls

Solidity (since v0.6.0) supports `try-catch` for error handling in **external calls** or contract creation.

```solidity
try otherContract.someFunction() returns (uint value) {
    // success logic
} catch Error(string memory reason) {
    // catch require/revert errors (with error message)
} catch (bytes memory lowLevelData) {
    // catch assert/panic errors (no error message)
}
```

- Use `try-catch` to handle failures gracefully when calling other contracts.

---

## Best Practices for Error Handling

- Use `require()` for input checks and access control.
- Use `assert()` only for invariants and internal errors.
- Provide clear error messages for easier debugging.
- Avoid using `assert()` for input validation.
- Handle external call failures with `try-catch` where possible.

---

## Related Keywords

| Keyword         | Use Case                              |
|-----------------|--------------------------------------|
| `require()`, `revert()`, `assert()` | Error handling & validation |
| `try-catch`     | External call exception handling     |

---

## Version Compatibility Notes

- `try-catch`: Introduced in Solidity 0.6.0

---

## Examples and Gotchas

### Incorrect Use of `assert()`

```solidity
// Don't use assert for input validation
assert(msg.sender == owner); // Bad practice
```

### Correct Use of `require()`

```solidity
require(msg.sender == owner, "Not authorized"); // Good practice
```

---

> Tip: Always test your error handling logic thoroughly to ensure your contract behaves as expected in all scenarios.

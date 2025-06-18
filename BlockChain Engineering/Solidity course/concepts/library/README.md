# Solidity Libraries — Complete Guide

This document provides a comprehensive understanding of **Libraries in Solidity**: what they are, how they work, when to use them, and how to deploy and interact with them properly.

---

## What Are Libraries?

A **library** in Solidity is a reusable piece of logic that contains functions you can call from contracts. Libraries help you:

- Write modular and reusable code
- Reduce contract size
- Improve code readability
- Maintain DRY (Don't Repeat Yourself) principles

Libraries are similar to contracts, but they are intended to be stateless and cannot hold Ether or state variables. They are best used for utility functions and logic that can be shared across multiple contracts.

---

## Types of Libraries

| Type            | Can Modify Storage? | Deployable? | Usage                      |
|-----------------|--------------------|-------------|----------------------------|
| Internal Library | No                 | No          | Inlined at compile-time    |
| External Library | No (unless passed) | Yes         | Deployed once and linked   |

**Internal libraries** are included directly in the contract's bytecode at compile time.  
**External libraries** are deployed separately and linked to contracts, allowing code reuse across multiple contracts.

---

## Declaring a Library

To declare a library, use the `library` keyword. Functions are usually marked as `internal` for efficiency, but can be `public` if you want to call them externally.

```solidity
library MathLib {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }
}
```

**Explanation:**  
- The `internal` keyword means the function can only be called from inside the library or contracts using the library.
- Libraries cannot have state variables or receive Ether.

---

## Using a Library in a Contract

You can call library functions directly by referencing the library name.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library MathLib {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }
}

contract Calculator {
    function sum(uint x, uint y) external pure returns (uint) {
        return MathLib.add(x, y);
    }
}
```

**Explanation:**  
- The `Calculator` contract uses the `MathLib` library to perform addition.
- This keeps the contract code clean and modular.

---

## The `using for` Pattern

The `using for` directive allows you to attach library functions to a type, enabling a more intuitive syntax.

```solidity
library MathLib {
    function square(uint x) internal pure returns (uint) {
        return x * x;
    }
}

contract Example {
    using MathLib for uint;

    function squareIt(uint num) external pure returns (uint) {
        return num.square(); // Instead of MathLib.square(num)
    }
}
```

**Explanation:**  
- `using MathLib for uint;` attaches all `MathLib` functions to the `uint` type.
- You can now call `num.square()` directly, which is more readable.

---

## Deployment of Libraries

### Internal Libraries

- Functions are inlined in the contract at compile-time.
- No extra deployment gas is required.
- Cannot have storage or state variables.

### External Libraries

- Deployed once and linked to contracts.
- Functions are called using `delegatecall`, sharing the storage context with the calling contract.
- Requires linking at compile or deploy time (using tools like Hardhat, Truffle, or Foundry).

---

## Linking Libraries (Manual Bytecode Linking)

When using external libraries, you may need to link them manually during deployment.

**Example using Hardhat/Truffle:**

```js
await deployer.link(MyLibrary, MyContract);
await deployer.deploy(MyContract);
```

**Example in Solidity:**

```solidity
import "MyLibrary.sol";

library MyLibrary {
    function doSomething(...) internal pure returns (...) { ... }
}
```

---

## Library Restrictions

Libraries in Solidity have the following restrictions:

- Cannot hold Ether (no payable fallback)
- Cannot have state variables
- Cannot inherit or be inherited from
- Cannot define modifiers
- Cannot be instantiated with `new`

---

## Gas Optimization

Libraries can help reduce contract size and gas usage, especially when reused across multiple contracts.

| Case                   | Gas Usage         |
|------------------------|------------------|
| Internal call          | Low (inlined)    |
| External delegatecall  | Moderate         |
| Duplication without lib| High (code bloat)|

---

## Example: Math Library

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library SafeCalc {
    function safeDiv(uint a, uint b) internal pure returns (uint) {
        require(b != 0, "Div by zero");
        return a / b;
    }

    function percent(uint a, uint b) internal pure returns (uint) {
        return (a * b) / 100;
    }
}

contract Finance {
    using SafeCalc for uint;

    function fiftyPercent(uint value) public pure returns (uint) {
        return value.percent(50);
    }
}
```

**Explanation:**  
- `SafeCalc` provides safe division and percentage calculation.
- The `Finance` contract uses `using for` to make the code more readable.

---

## Use Cases for Libraries

Libraries are commonly used for:

- Arithmetic operations (e.g., SafeMath, PRBMath)
- Financial calculations
- Byte manipulation (e.g., BytesLib)
- String utilities (e.g., Strings)
- Signature verification (e.g., ECDSA)
- Enumerable sets/maps (e.g., EnumerableMap, EnumerableSet)
- Creating reusable modules across contracts

---

## Popular Libraries in the Ecosystem

| Library        | Use Case                   | Notes                       |
|----------------|---------------------------|-----------------------------|
| SafeMath (OZ)  | Overflow-safe math         | Unnecessary in Solidity 0.8+|
| Strings (OZ)   | Uint to string conversion  | Used in token metadata      |
| ECDSA (OZ)     | Signature recovery         | ecrecover wrapper           |
| Address (OZ)   | Address utilities          | Contract check, send, call  |
| PRBMath        | Fixed-point math (60.18)   | Precision math              |
| BytesLib       | Bytes & calldata utils     | Low-level manipulation      |

---

## Best Practices

- Use internal functions when possible (more gas-efficient)
- Group reusable logic into libraries instead of contracts
- Avoid external storage modification via libraries
- Use `using for` to make code clean and intuitive
- Document each function clearly since libraries serve as utility modules
- Do not use payable functions or state variables in libraries

---

## Conclusion

Libraries are essential for clean, efficient, and modular Solidity code. They promote best practices, help reduce gas costs, and enable large-scale contract organization.

Think of libraries as smart contract “toolkits” — stateless, reusable, and safe.

---

## Resources

- [Solidity Docs — Libraries](https://docs.soliditylang.org/en/latest/contracts.html#libraries)
- [OpenZeppelin Contracts GitHub](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [PRBMath Docs](https://prbmath.com/)
- [Solmate Utils](https://github.com/transmissions11/solmate)
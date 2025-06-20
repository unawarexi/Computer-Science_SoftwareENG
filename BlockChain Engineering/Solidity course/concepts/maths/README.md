# Solidity Math — Complete Guide

This document covers everything you need to know about **mathematics in Solidity**, including number types, operations, overflow protection, advanced math libraries, and best practices.

---

## Overview

Math in Solidity is **low-level, deterministic, and gas-sensitive**. It differs from high-level languages due to:

- **No floating-point support**
- **Manual overflow/underflow handling** (pre-Solidity 0.8)
- **Precision limits**
- **Gas cost sensitivity**

---

## 1. Integer Types in Solidity

Solidity supports two main types of integers: unsigned (`uint`) and signed (`int`). These types are used to represent whole numbers.

### Unsigned Integers (`uint`)

- `uint8`, `uint16`, ..., `uint256`
- Represents non-negative integers (0 and above)
- `uint` is an alias for `uint256`

### Signed Integers (`int`)

- `int8`, `int16`, ..., `int256`
- Can be positive or negative
- `int` is an alias for `int256`

#### Declaration Example

```solidity
// Unsigned integer
uint256 a = 5;

// Signed integer
int256 b = -10;
```

---

## 2. Basic Arithmetic Operations

Solidity supports standard arithmetic operations:

| Operator | Description         |
|----------|---------------------|
| `+`      | Addition            |
| `-`      | Subtraction         |
| `*`      | Multiplication      |
| `/`      | Division (truncates decimals) |
| `%`      | Modulo (remainder)  |

#### Example

```solidity
uint256 x = 10;
uint256 y = 3;
uint256 result = x / y; // = 3, NOT 3.333...
```

**Note:** Division between integers always truncates towards zero (no decimals).

---

## 3. Overflow and Underflow

**What is Overflow?**  
An *overflow* occurs when a value exceeds the maximum value a data type can store. For example, if a `uint8` (which can store values from 0 to 255) is incremented past 255, it wraps around to 0.

**What is Underflow?**  
An *underflow* happens when a value goes below the minimum value a data type can store. For `uint8`, subtracting 1 from 0 wraps around to 255.

```solidity
uint8 a = 255;
a += 1; // wraps to 0 (overflow)

uint8 b = 0;
b -= 1; // wraps to 255 (underflow)
```

### Before Solidity 0.8.0

Math operations were unchecked, so overflows/underflows would silently wrap around.

```solidity
uint8 a = 255;
a += 1; // wraps to 0 (overflow)
```

### Since Solidity 0.8.0

Checked by default — throws error on overflow/underflow:

```solidity
uint8 a = 255;
a += 1; // runtime error (reverts transaction)
```

### Unchecked Blocks (opt-out manually)

**What does `unchecked` do?**  
The `unchecked` keyword disables overflow and underflow checks within its block, allowing arithmetic to wrap around as in older Solidity versions. This can save gas but should be used only when you are certain overflows/underflows cannot occur or are intentional.

```solidity
unchecked {
    a += 1; // skips safety checks
}
```

---

## 4. Integer Division & Precision

Solidity does **not** support floating-point numbers. All division between integers truncates towards zero.

### Example: Loss of Precision

```solidity
uint256 result = 5 / 2; // = 2
```

### Preserving Precision

**Why multiply before dividing?**  
In Solidity, division between integers always truncates (removes) the decimal part, potentially losing precision. By multiplying first (using a scaling factor like `10^18`), you preserve the fractional part in the result, simulating fixed-point math.

```solidity
uint256 result = (5 * 10**18) / 2; // = 2.5 * 10^18
```

**Tip:** Use scaling (like `10^18`) to simulate fixed-point math, similar to how ETH uses 18 decimals.

---

## 5. Fixed-Point Arithmetic

Solidity doesn't natively support decimal types, but you can simulate them using scaling.

### Example: Simulating 18 Decimals (like ETH)

```solidity
uint256 amount = 100 * 10**18; // Treat 1 unit = 10^18
```

**Explanation:**  
This approach lets you represent fractional values as integers, avoiding floating-point errors.

---

## 6. Math Libraries

### SafeMath (pre-0.8.0 only)

Used to prevent overflow/underflow before Solidity 0.8.0.

```solidity
using SafeMath for uint256;

uint256 a = 1;
uint256 b = 2;
uint256 c = a.add(b); // 3
```

> **Note:** No longer needed in Solidity 0.8+ (checks are built-in).

### PRBMath — Precision Math for Solidity

A high-precision, fixed-point math library for smart contracts.

- Handles signed and unsigned fixed-point math
- Up to 60.18 decimals
- Safe, fast, deterministic

```solidity
import { PRBMathUD60x18 } from "prb-math/PRBMathUD60x18.sol";

uint256 result = PRBMathUD60x18.mul(1e18, 2e18); // = 2e18 (2.0)
```

[GitHub: PRBMath](https://github.com/PaulRBerg/prb-math)

---

## 7. Comparison Operators

Use these for conditional logic and loops.

| Operator | Meaning                |
|----------|------------------------|
| `==`     | Equal to               |
| `!=`     | Not equal to           |
| `<`      | Less than              |
| `>`      | Greater than           |
| `<=`     | Less than or equal     |
| `>=`     | Greater than or equal  |

```solidity
if (a > b) {
    // do something
}
```

---

## 8. Bitwise Operations

Solidity supports all standard bitwise operations, useful for cryptography and compact storage.

| Operator | Description   |
|----------|--------------|
| `&`      | AND          |
| `|`      | OR           |
| `^`      | XOR          |
| `~`      | NOT          |
| `<<`     | Left shift   |
| `>>`     | Right shift  |

#### Example

```solidity
uint8 a = 0b1010;
uint8 b = a << 1; // = 0b10100 = 20
```

---

## 9. Advanced Math Techniques

### Exponentiation

```solidity
uint256 result = a ** b; // a raised to the power b
```

> **Warning:** Can overflow quickly. Be careful with gas limits.

### Square Roots

Use libraries like:

- `OpenZeppelin Math.sqrt(x)`
- `PRBMath.sqrt(x)`
- Babylonian method (custom implementation)

---

## 10. Math Utility Libraries

| Library                | Features                  | Notes                        |
|------------------------|--------------------------|------------------------------|
| SafeMath               | Safe arithmetic          | Pre-0.8 only                 |
| PRBMath                | Fixed-point math         | Highly recommended           |
| ABDKMath64x64          | Signed 64.64 bit math    | Efficient for financial models|
| DSMath                 | Fixed-point math         | Used in DeFi protocols       |
| Math.sol (OpenZeppelin)| Max, min, avg, sqrt      | Simple helpers (0.8+)        |

---

## 11. Gas Considerations

- Math operations are relatively cheap
- Avoid expensive loops or nested exponentiation
- Use `unchecked` when you're sure overflow won't occur
- Use scaling factors to simulate decimals, but track rounding errors

---

## 12. Rounding Issues

Solidity truncates toward zero in all integer division.

No built-in rounding up/down. Use helper functions:

```solidity
function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
    return (a + b - 1) / b;
}
```

---

## 13. Best Practices

- Use `uint256` unless you need smaller types for packing
- Simulate decimals via scaling (`10^18`)
- Use libraries like PRBMath for precision math
- Avoid floating-point assumptions — all math is integer
- Test for rounding issues and edge cases
- Beware of overflows even with Solidity 0.8+

---

**Summary:**  
Solidity math is simple but requires careful handling of overflows, rounding, and precision. Always use the latest best practices and libraries to ensure safe and accurate calculations in your smart contracts.
# Understanding Binary in Solidity

Solidity is a statically typed language designed to run on the Ethereum Virtual Machine (EVM). At the lowest level, the EVM deals with **binary** (base-2) numbers — everything boils down to 0s and 1s.

This guide will help you understand how Solidity handles numbers like `uint8 = 255`, how bits and bytes work, and how overflow, underflow, and data truncation happen under the hood.

---

## Binary: The Language of the EVM

- Binary is base-2: it only uses **0** and **1**.
- Computers use binary to store and process data.
- Each **bit** represents a binary digit (`0` or `1`).
- A **byte** is 8 bits.

### Example

```solidity
uint8 myValue = 255;
```

- `uint8` means: **unsigned integer using 8 bits**.
- 255 in binary (8-bit): `11111111`
- Max value of uint8: `2^8 - 1 = 255`

---

## Data Types and Their Binary Limits

| Type     | Bits | Value Range                    | Max Binary Value     |
|----------|------|--------------------------------|----------------------|
| `uint8`  | 8    | 0 to 255                       | `11111111`           |
| `uint16` | 16   | 0 to 65,535                    | `1111111111111111`   |
| `uint32` | 32   | 0 to 4,294,967,295             | `...`                |
| `uint256`| 256  | 0 to ~1.15 × 10⁷⁷              | 256 bits (32 bytes)  |

### Unsigned vs Signed

- `uint` means **unsigned integer** (only positive values).
- `int` means **signed integer** (positive & negative).
  - `int8` ranges from **-128 to 127**
  - Stored using **two's complement**.

---

## Why 255 is the Max for `uint8`

Binary math:
```
2^0 = 1
2^1 = 2
2^2 = 4
...
2^7 = 128
```

Sum of all powers from 2⁰ to 2⁷:
```
1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 = 255
```

Binary for 255:
```
11111111
```

---

## How Solidity Stores Values

Solidity stores variables in **slots of 32 bytes (256 bits)**.

```solidity
uint8 a = 255;  // takes 1 byte
uint256 b = 2;  // takes full 32 bytes
```

If multiple small-sized variables are declared consecutively, Solidity will try to pack them into the same 32-byte slot (gas optimization).

### Overflow & Underflow (Before Solidity 0.8.x)

```solidity
uint8 a = 255;
a += 1; // overflowed to 0 in Solidity <0.8.0
```

In earlier versions of Solidity, numbers could wrap around silently.

After 0.8.0, overflow/underflow throws an error by default.

Use `unchecked {}` if you want to deliberately disable overflow checks.

```solidity
unchecked {
    a += 1; // wraps from 255 to 0
}
```

### Binary Math Example

```solidity
uint8 x = 200;
uint8 y = 100;
uint8 z = x + y; // 200 + 100 = 300 ❌ error, overflow
```

300 can't be stored in 8 bits (max is 255). Throws a runtime error (post 0.8.x).

### Bitwise Operators in Solidity

Solidity supports binary operators for low-level manipulation.

| Operator | Symbol | Example   | Description                      |
|----------|--------|-----------|----------------------------------|
| AND      | &      | a & b     | 1 only if both bits are 1        |
| OR       | \|     | a \| b    | 1 if either bit is 1             |
| XOR      | ^      | a ^ b     | 1 if bits are different          |
| NOT      | ~      | ~a        | Inverts each bit                 |
| Shift L  | <<     | a << 1    | Shift bits left (×2)             |
| Shift R  | >>     | a >> 1    | Shift bits right (÷2)            |

```solidity
uint8 a = 5;      // binary: 00000101
uint8 b = a << 1; //        = 00001010 (5 * 2 = 10)
```

## Two's Complement (for Signed Ints)

Used to represent negative numbers.

For int8:

- 127 = 01111111
- -1 = 11111111
- -128 = 10000000

This allows subtraction and other arithmetic to be done using binary rules.

---

## Summary

| Concept           | Description                                                      |
|-------------------|------------------------------------------------------------------|
| Bits & Bytes      | 1 byte = 8 bits; storage depends on type size                    |
| uint8 = 255       | Max value for 8-bit unsigned integer (binary: 11111111)          |
| Overflow/Underflow| Handled strictly in Solidity ≥0.8.0 (throws on overflow)         |
| Bitwise Ops       | Efficient low-level manipulation (AND, OR, XOR, NOT, shifts)     |
| Packing           | Solidity packs smaller types to save gas                         |
| Signed Ints       | Use two's complement to represent negatives                      |

---

## Useful Resources

- [Solidity by Example – Overflow](https://solidity-by-example.org/overflow/)
- [Solidity Docs – Types](https://docs.soliditylang.org/en/latest/types.html)
- [EVM Deep Dive – evm.codes](https://www.evm.codes/)
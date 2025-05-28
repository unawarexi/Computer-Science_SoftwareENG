# ⚙️ Solidity Operators - Explanation Note

This note explains all major operators in Solidity, including their syntax, meaning, and usage. Use the tables below as a quick reference while learning or coding.

---

## 📐 Arithmetic Operators

| Operator | Description    | Example | Result/Meaning         |
|----------|----------------|---------|------------------------|
| `+`      | Addition       | x + y   | Sum of x and y         |
| `-`      | Subtraction    | x - y   | Difference             |
| `*`      | Multiplication | x * y   | Product                |
| `/`      | Division       | x / y   | Quotient (truncated)   |
| `%`      | Modulus        | x % y   | Remainder              |
| `++`     | Increment      | x++     | x = x + 1              |
| `--`     | Decrement      | x--     | x = x - 1              |

> **Note:** Solidity automatically checks for overflow/underflow since version 0.8.0.

---

## 📊 Comparison (Relational) Operators

| Operator | Description             | Example   | Returns                |
|----------|-------------------------|-----------|------------------------|
| `==`     | Equal to                | x == y    | true if x equals y     |
| `!=`     | Not equal to            | x != y    | true if x not equals y |
| `>`      | Greater than            | x > y     | true if x > y          |
| `<`      | Less than               | x < y     | true if x < y          |
| `>=`     | Greater than or equal   | x >= y    | true if x ≥ y          |
| `<=`     | Less than or equal      | x <= y    | true if x ≤ y          |

---

## 🔗 Logical Operators

| Operator | Description    | Example    | Returns                    |
|----------|----------------|------------|----------------------------|
| `&&`     | Logical AND    | x && y     | true if both are true      |
| `&#124;&#124;` | Logical OR     | x &#124;&#124; y | true if either is true     |
| `!`      | Logical NOT    | !x         | true if x is false         |

---

## 🧮 Bitwise Operators

| Operator | Description      | Example   | Result/Meaning             |
|----------|------------------|-----------|----------------------------|
| `&`      | Bitwise AND      | x & y     | 1 if both bits are 1       |
| `&#124;` | Bitwise OR       | x &#124; y| 1 if either bit is 1       |
| `^`      | Bitwise XOR      | x ^ y     | 1 if bits are different    |
| `~`      | Bitwise NOT      | ~x        | Inverts each bit           |
| `<<`     | Left shift       | x << n    | Shift bits left by n       |
| `>>`     | Right shift      | x >> n    | Shift bits right by n      |

---

## 🖊️ Assignment Operators

| Operator | Description           | Example   | Equivalent           |
|----------|-----------------------|-----------|----------------------|
| `=`      | Assign                | x = y     | Assign y to x        |
| `+=`     | Add & assign          | x += y    | x = x + y            |
| `-=`     | Subtract & assign     | x -= y    | x = x - y            |
| `*=`     | Multiply & assign     | x *= y    | x = x * y            |
| `/=`     | Divide & assign       | x /= y    | x = x / y            |
| `%=`     | Modulo & assign       | x %= y    | x = x % y            |
| `<<=`    | Left shift & assign   | x <<= y   | x = x << y           |
| `>>=`    | Right shift & assign  | x >>= y   | x = x >> y           |
| `&=`     | Bitwise AND & assign  | x &= y    | x = x & y            |
| `&#124;=`| Bitwise OR & assign   | x &#124;= y| x = x &#124; y        |
| `^=`     | Bitwise XOR & assign  | x ^= y    | x = x ^ y            |

---

## 🧾 Special & Miscellaneous Operators

| Operator / Syntax | Description                | Example                        | Notes/Usage                        |
|-------------------|----------------------------|---------------------------------|-------------------------------------|
| `?:` (ternary)    | Conditional operator       | x ? y : z                      | If x is true, returns y, else z     |
| `delete`          | Clears storage variable    | delete x;                      | Sets variable to default value      |
| `new`             | Deploys new contract       | new Contract()                 | Used for contract creation          |
| `type()`          | Introspection             | type(MyContract).creationCode  | Get creation/runtime code           |
| `abi.encode(...)` | ABI encoding              | abi.encode(x)                  | Used for low-level calls            |
| `address(...)`    | Type conversion           | address(this)                  | Convert to address                  |
| `payable(...)`    | Payable conversion        | payable(msg.sender)            | Enables receiving Ether             |

---

## 🔍 Additional Notes

- **Arithmetic Overflow:** Since Solidity 0.8.0, arithmetic overflows throw an error. Use `unchecked` to bypass:
    ```solidity
    unchecked {
        x += y;
    }
    ```
- **Operator Precedence:** Be mindful of operator precedence. Use parentheses to avoid ambiguity.

---

## 📚 Resources

- [Solidity Docs - Operators](https://docs.soliditylang.org/en/latest/control-structures.html#operators)
- [Solidity by Example](https://solidity-by-example.org/)
- [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)


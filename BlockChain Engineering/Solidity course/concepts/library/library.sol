// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Example 1: Declaring a simple internal library
library MathLib {
    // This function adds two unsigned integers.
    // 'internal' means it can only be used inside this library or contracts using it.
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    // This function returns the square of a number.
    function square(uint x) internal pure returns (uint) {
        return x * x;
    }
}

// Example 2: Using a library directly in a contract
contract Calculator {
    // Uses the MathLib.add function to sum two numbers.
    function sum(uint x, uint y) external pure returns (uint) {
        return MathLib.add(x, y);
    }
}

// Example 3: Using 'using for' to attach library functions to a type
contract Example {
    // Attach all MathLib functions to uint type.
    using MathLib for uint;

    // Now you can call .square() directly on uint variables.
    function squareIt(uint num) external pure returns (uint) {
        return num.square(); // Equivalent to MathLib.square(num)
    }
}

// Example 4: Safe calculation library with require checks
library SafeCalc {
    // Safe division with zero check.
    function safeDiv(uint a, uint b) internal pure returns (uint) {
        require(b != 0, "Div by zero");
        return a / b;
    }

    // Calculate percentage (a * b / 100)
    function percent(uint a, uint b) internal pure returns (uint) {
        return (a * b) / 100;
    }
}

// Example 5: Using SafeCalc with 'using for'
contract Finance {
    using SafeCalc for uint;

    // Returns 50% of the input value.
    function fiftyPercent(uint value) public pure returns (uint) {
        return value.percent(50);
    }
}

/*
Summary of key points:
- Libraries are for reusable, stateless logic.
- Use 'internal' for most library functions for gas efficiency.
- 'using for' attaches library functions to types for cleaner syntax.
- Libraries cannot have state variables, receive Ether, or be inherited.
- Use libraries for math, string, bytes, and utility functions.
*/

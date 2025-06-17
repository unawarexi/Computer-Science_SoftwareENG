// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title LoopExamples - Demonstrates control flow with loops in Solidity
contract LoopExamples {
    uint[] public numbers;

    /// @notice Adds numbers 0 to 9 to the array using a for loop
    function fillWithForLoop() public {
        // Always bound your loops to avoid out-of-gas errors!
        for (uint i = 0; i < 10; i++) {
            numbers.push(i);
        }
    }

    /// @notice Adds numbers 10 to 19 to the array using a while loop
    function fillWithWhileLoop() public {
        uint i = 10;
        while (i < 20) {
            numbers.push(i);
            i++;
        }
    }

    /// @notice Adds numbers 20 to 24 to the array using a do...while loop
    function fillWithDoWhileLoop() public {
        uint i = 20;
        do {
            numbers.push(i);
            i++;
        } while (i < 25);
    }

    /// @notice Demonstrates use of break and continue in a for loop
    function breakAndContinueDemo() public pure returns (uint sum) {
        // Sums odd numbers less than 10, stops if number is 7
        for (uint i = 0; i < 10; i++) {
            if (i == 7) {
                break; // Exit loop early when i == 7
            }
            if (i % 2 == 0) {
                continue; // Skip even numbers
            }
            sum += i; // Only odd numbers less than 7 are summed
        }
    }

    /// @notice Example of a safe bounded loop over an array
    function sumFirstN(uint n) public view returns (uint total) {
        // Always bound loops to avoid excessive gas usage!
        uint limit = n < numbers.length ? n : numbers.length;
        for (uint i = 0; i < limit; i++) {
            total += numbers[i];
        }
    }

    /// @notice Example of a dangerous infinite loop (DO NOT USE)
    function infiniteLoop() public pure {
        // Uncommenting this will cause the function to run out of gas!
        // while (true) {
        //     // No exit condition - will run forever and fail
        // }
    }
}

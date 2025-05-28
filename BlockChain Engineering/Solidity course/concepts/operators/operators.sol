// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OperatorExample {
    uint public a = 10;
    uint public b = 5;
    bool public result;

    // Arithmetic Operators
    function arithmetic() public {
        a += b; // a = a + b
        a -= 2; // a = a - 2
        a *= 2; // a = a * 2
        a /= 3; // a = a / 3
        a %= 4; // a = a % 4
        a++;    // a = a + 1
        a--;    // a = a - 1
    }

    // Comparison Operators
    function compare() public view returns (bool eq, bool neq, bool gt, bool lt, bool gte, bool lte) {
        eq = (a == b);
        neq = (a != b);
        gt = (a > b);
        lt = (a < b);
        gte = (a >= b);
        lte = (a <= b);
    }

    // Logical Operators
    function logic() public view returns (bool andOp, bool orOp, bool notOp) {
        andOp = (a > 0 && b > 0);
        orOp = (a > 0 || b > 100);
        notOp = !(a == b);
    }

    // Bitwise Operators
    function bitwise() public {
        a = a & b;      // Bitwise AND
        a = a | b;      // Bitwise OR
        a = a ^ b;      // Bitwise XOR
        a = ~a;         // Bitwise NOT
        a = a << 1;     // Left shift
        a = a >> 1;     // Right shift
    }

    // Assignment Operators
    function assignments() public {
        uint x = 1;
        x += 2; // x = 3
        x -= 1; // x = 2
        x *= 5; // x = 10
        x /= 2; // x = 5
        x %= 3; // x = 2
        x <<= 2; // x = 8
        x >>= 1; // x = 4
        x &= 3; // x = 0
        x |= 2; // x = 2
        x ^= 1; // x = 3
    }

    // Ternary Operator
    function conditional(uint x) public pure returns (string memory) {
        return x > 10 ? "Greater" : "Smaller or Equal";
    }

    // Delete Operator
    uint public toDelete = 123;
    function deleteExample() public {
        delete toDelete; // toDelete becomes 0
    }

    // new Operator (contract creation)
    // Example contract for demonstration
    contract Dummy {}
    Dummy public dummyInstance;
    function createDummy() public {
        dummyInstance = new Dummy();
    }

    // type() Operator
    function getMaxUint8() public pure returns (uint8) {
        return type(uint8).max;
    }

    // abi.encode
    function encodeExample(uint x) public pure returns (bytes memory) {
        return abi.encode(x);
    }

    // address(...) and payable(...)
    function addressConversion() public view returns (address, address payable) {
        address addr = address(this);
        address payable paddr = payable(msg.sender);
        return (addr, paddr);
    }

    // unchecked block
    function uncheckedAdd(uint x, uint y) public pure returns (uint) {
        uint z;
        unchecked {
            z = x + y;
        }
        return z;
    }
}
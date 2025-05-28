// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Demonstration of Solidity Data Types

contract DataTypesDemo {
    // ✅ Value Types

    // 1. Boolean
    bool public isComplete = true;

    // 2. Integers
    int256 public signedInt = -42;
    uint256 public unsignedInt = 42;
    int8 public smallSigned = -10;
    uint8 public smallUnsigned = 250;

    // 3. Fixed Point Numbers (not supported)
    // // Not supported in current versions

    // 4. Address
    address public owner = msg.sender;

    // 5. Address Payable
    address payable public recipient;

    function setRecipient(address payable _recipient) public {
        recipient = _recipient;
    }

    // 6. Bytes
    bytes1 public b1 = 0x12;
    bytes32 public b32 = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
    bytes public dynamicBytes = "hello";

    // 7. Enums
    enum Status { Pending, Shipped, Delivered }
    Status public status = Status.Pending;

    // 📦 Reference Types

    // 1. Arrays
    uint[3] public fixedArray = [1, 2, 3];
    uint[] public dynamicArray;
    uint[][] public matrix;

    // 2. Strings
    string public name = "Solidity";

    // 3. Structs
    struct User {
        string name;
        uint age;
    }
    User public user = User("Alice", 30);

    // 4. Mappings
    mapping(address => uint) public balances;
    mapping(address => mapping(uint => bool)) public nestedMapping;

    // 🎯 Special Types

    // Address Types
    address public basicAddress;
    address payable public payableAddress;

    // Function Types
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
    function getAdderInternal() public pure returns (function(uint, uint) internal pure returns (uint)) {
        return add;
    }
    function getAdderExternal() public view returns (function(uint, uint) external view returns (uint)) {
        return this.addExternal;
    }
    function addExternal(uint a, uint b) external view returns (uint) {
        return a + b;
    }

    // type(x)
    function getMaxUint8() public pure returns (uint8) {
        return type(uint8).max;
    }

    // this and super
    function getThisAddress() public view returns (address) {
        return address(this);
    }

    // 🧩 Storage vs Memory vs Calldata
    function memoryExample(uint[] memory arr) public pure returns (uint) {
        return arr.length;
    }
    function calldataExample(uint[] calldata arr) external pure returns (uint) {
        return arr.length;
    }

    // ⛽ Data Location and Gas Optimization
    // Use calldata for read-only parameters, pack tightly, etc.

    // 🔁 Type Conversions
    function implicitConversion() public pure returns (uint256) {
        uint8 x = 8;
        uint256 y = x; // Implicit
        return y;
    }
    function explicitConversion() public pure returns (uint256) {
        int256 a = -5;
        return uint256(a); // Explicit, be careful!
    }

    // 🧬 Advanced Concepts

    // ABI Encoding
    function encodeExample(uint a, uint b) public pure returns (bytes memory, bytes memory, bytes memory) {
        return (
            abi.encode(a, b),
            abi.encodePacked(a, b),
            abi.encodeWithSignature("foo(uint256)", 123)
        );
    }

    // Storage Layout Example
    uint128 public packedA;
    uint128 public packedB;
    // bool public unpackedBool; // Uncommenting this will waste storage slot

    // Hashing and Mappings
    function getMappingSlot(address key) public pure returns (bytes32) {
        // Example: keccak256(abi.encodePacked(key, slot))
        return keccak256(abi.encodePacked(key, uint(0)));
    }
}

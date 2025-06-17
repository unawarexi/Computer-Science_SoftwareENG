// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DataMethodsDemo
 * @dev Demonstrates manipulation and methods for basic Solidity data types.
 */
contract DataMethodsDemo {
    // --- Boolean Methods ---
    bool public flag = false;

    function toggleFlag() public {
        flag = !flag;
    }

    // --- Integer Methods ---
    int256 public signedNum = 0;
    uint256 public unsignedNum = 0;

    function incrementInt() public {
        signedNum += 1;
        unsignedNum += 1;
    }

    function decrementInt() public {
        signedNum -= 1;
        if (unsignedNum > 0) {
            unsignedNum -= 1;
        }
    }

    function addInt(int256 x, int256 y) public pure returns (int256) {
        return x + y;
    }

    function mulUint(uint256 x, uint256 y) public pure returns (uint256) {
        return x * y;
    }

    // --- Address Methods ---
    address public lastSender;
    address payable public lastPayable;

    function updateSender() public {
        lastSender = msg.sender;
    }

    function setPayable(address payable _addr) public {
        lastPayable = _addr;
    }

    // --- Bytes Methods ---
    bytes1 public b1 = 0x00;
    bytes public dynamicBytes;

    function setBytes(bytes memory _data) public {
        dynamicBytes = _data;
    }

    function pushByte(byte _b) public {
        dynamicBytes.push(_b);
    }

    function popByte() public {
        require(dynamicBytes.length > 0, "Empty bytes");
        dynamicBytes.pop();
    }

    function getByteAt(uint idx) public view returns (bytes1) {
        require(idx < dynamicBytes.length, "Out of bounds");
        return dynamicBytes[idx];
    }

    // --- String Methods ---
    string public greeting = "Hello";

    function setGreeting(string memory _g) public {
        greeting = _g;
    }

    function concatGreeting(string memory _suffix) public view returns (string memory) {
        return string(abi.encodePacked(greeting, _suffix));
    }

    function getCharAt(uint idx) public view returns (bytes1) {
        bytes memory strBytes = bytes(greeting);
        require(idx < strBytes.length, "Out of bounds");
        return strBytes[idx];
    }

    // --- Type Conversion Methods ---
    function uintToBytes(uint x) public pure returns (bytes memory) {
        return abi.encodePacked(x);
    }

    function bytesToUint(bytes memory b) public pure returns (uint256 result) {
        require(b.length >= 32, "Bytes too short");
        assembly {
            result := mload(add(b, 32))
        }
    }
}

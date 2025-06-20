// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConditionalsDemo {
    // Returns a string based on the value of x
    function checkNumber(int x) public pure returns (string memory) {
        if (x > 0) {
            return "x is positive";
        } else if (x == 0) {
            return "x is zero";
        } else {
            return "x is negative";
        }
    }

    // Returns true if the address is the contract owner
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function isOwner(address addr) public view returns (bool) {
        if (addr == owner) {
            return true;
        } else {
            return false;
        }
    }
}

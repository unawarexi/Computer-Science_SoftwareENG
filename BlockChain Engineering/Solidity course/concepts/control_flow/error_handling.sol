// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ErrorHandlingExamples - Demonstrates error handling in Solidity
contract ErrorHandlingExamples {
    address public owner;
    uint public value;

    constructor() {
        owner = msg.sender;
    }

    /// @notice Uses require for input validation and access control
    function setValue(uint _value) public {
        require(msg.sender == owner, "Not authorized"); // Only owner can set value
        require(_value < 1000, "Value too large");      // Input validation
        value = _value;
    }

    /// @notice Uses revert to manually trigger an error
    function revertExample(uint _x) public pure returns (uint) {
        if (_x == 0) {
            revert("Input cannot be zero");
        }
        return 100 / _x;
    }

    /// @notice Uses assert to check for internal invariants
    function assertExample() public view returns (uint) {
        // This should never fail if contract logic is correct
        assert(value < 1000);
        return value;
    }

    /// @notice Demonstrates try-catch with an external call
    function tryCatchExample(address _otherContract, uint _input) public returns (bool success, uint result) {
        // Assume the external contract has a function: function double(uint) external pure returns (uint)
        (success, result) = _tryDouble(_otherContract, _input);
    }

    function _tryDouble(address _otherContract, uint _input) internal returns (bool, uint) {
        // External call wrapped in try-catch
        try IOtherContract(_otherContract).double(_input) returns (uint doubled) {
            return (true, doubled);
        } catch Error(string memory reason) {
            // Handle require/revert errors
            return (false, 0);
        } catch (bytes memory /*lowLevelData*/) {
            // Handle assert/panic errors
            return (false, 0);
        }
    }
}

/// @dev Minimal interface for external contract used in try-catch example
interface IOtherContract {
    function double(uint) external pure returns (uint);
}

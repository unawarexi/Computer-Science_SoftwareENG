// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// Interface for the Rebase Token contract
interface IRebaseToken {
    
    // Match the actual implementation with 3 parameters
    function mint(address _to, uint256 _amount, uint256 _userInterestRate) external;

    // Add the mintWithCurrentRate function that Vault should use
    function mintWithCurrentRate(address _to, uint256 _amount) external;

    // Match the actual implementation (burnFrom with different parameter order)
    function burnFrom(uint256 _amount, address _from) external;

    // Function to get the balance of a user
    function balanceOf(address _account) external view returns (uint256);
}
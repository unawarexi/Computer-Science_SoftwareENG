// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IRebaseToken} from "./interfaces/IRebaseToken.sol";

// pass the token address to the constructor
// create deposit function that mints tokens equal to the amount of underlying asset deposited
// create redeem function that burns tokens and sends the underlying asset to the user
// create a way to add rewards to the vault
contract Vault {
    // error
    error Vault__InvalidAmount();
    error Vault__TransferFailed();

    IRebaseToken private immutable i_rebaseTokens;

    // event
    event Deposit(address indexed _user, uint256 _amount);
    event Redeem(address indexed _user, uint256 _amount);

    constructor(IRebaseToken _rebaseToken) {
        // Initialize the vault with the token address
        i_rebaseTokens = _rebaseToken;
    }

    receive() external payable {
        // Allow the contract to receive Ether
    }
    
    // Function to get the address of the rebase token
    function getRebaseTokenAddress() external view returns (address) {
        return address(i_rebaseTokens);
    }
    
    // Function to deposit underlying asset and mint rebase tokens
    // it doesn't expect any parameters, it uses msg.value to determine the amount
    function deposit() external payable {
        i_rebaseTokens.mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    // Function to redeem rebase tokens for underlying asset
    // This function burns the user's tokens and sends the underlying asset back
    function redeem(uint256 _amount) external {
        // Logic for redeeming tokens from the vault
        if (_amount == 0) {
            revert Vault__InvalidAmount();
        }
        // Burn the user's tokens and send the underlying asset back
        i_rebaseTokens.burn(msg.sender, _amount);
       (bool success, ) = payable(msg.sender).call{value : _amount}(""); // Assuming 1:1 mapping for simplicity
        if(!success) {
            revert Vault__TransferFailed(); // Handle the case where the transfer fails
        }
        emit Redeem(msg.sender, _amount);
    }
}

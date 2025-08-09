// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// pass the token address to the constructor
// create deposit function that mints tokens equal to the amount of underlying asset deposited
// create redeem function that burns tokens and sends the underlying asset to the user
// create a way to add rewards to the vault
contract Vault {
    // error
    error Vault__InvalidAmount();

    address private immutable i_rebaseTokens;

    // event
    event Deposit(address indexed _user, uint256 _amount);

    constructor(address _rebaseToken) {
        // Initialize the vault with the token address
        i_rebaseTokens = _rebaseToken;
    }

    receive() external payable {
        // Allow the contract to receive Ether
    }

    function getRebaseTokenAddress() external view returns (address) {
        return i_rebaseTokens;
    }

    function deposit() external payable {
        i_rebaseTokens.mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
        // Transfer the underlying asset to the vault
        // Mint the corresponding amount of rebase tokens to the user
        // This would typically involve calling a mint function on the rebase token contract
        // Example: RebaseToken(i_rebaseTokens).mint(msg.sender, amount);
        // Note: Ensure that the rebase token contract has a mint function defined
        // This is a placeholder for the actual minting logic
        // RebaseToken(i_rebaseTokens).mint(msg.sender, amount);
        // Emit an event for the deposit
        // emit Deposit(msg.sender, amount);
    }

    function redeem(uint256 amount) external {
        // Logic for redeeming tokens from the vault
    }
}

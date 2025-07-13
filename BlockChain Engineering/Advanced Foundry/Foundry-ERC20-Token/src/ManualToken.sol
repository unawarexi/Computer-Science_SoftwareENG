// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ManualToken {

    mapping(address => uint256) private s_balances;

    // This contract simulates a simple ERC20 token with manual implementation
    function name() public pure returns (string memory) {
        return "ManualToken";
    }

    function totalSupply() public pure returns (uint256) {
        return 1000000 ether; // 1 million tokens
    }


    function decimals() public pure returns (uint8) {
        return 18; // Standard ERC20 decimal places
    }


    function symbol() public pure returns (string memory) {
        return "MTK"; // Token symbol
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 amount) public returns (bool) {
        uint256 previousBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= amount;
        s_balances[_to] += amount;
        uint256 newBalance = balanceOf(msg.sender) + balanceOf(_to);
        require(newBalance == previousBalance, "Transfer failed: balance mismatch");
        return true;
    }
}
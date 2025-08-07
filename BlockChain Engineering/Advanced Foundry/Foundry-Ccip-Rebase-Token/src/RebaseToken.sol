// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/*
 * @title RebaseToken
 * @author Dr.Dre
 * @notice This is a cross-chain rebase token that incentivises users to deposit into a vault and gain interest in rewards.
 * @notice The interest rate in the smart contract can only decrease
 * @notice Each will user will have their own interest rate that is the global interest rate at the time of depositing.
 */
contract RebaseToken is ERC20 {
    //------------------------------ State Variables

    //------------------------------ Events

    //------------------------------ Constructor

    constructor() ERC20("RebaseToken", "RBT") {
        // Initialize the ERC20 token with a name and symbol
    }

    //------------------------------ Functions
}

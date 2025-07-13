// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract PreBuiltToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("PreBuiltToken", "PBT") {
        _mint(msg.sender, initialSupply); // Mint 1 million tokens to the deployer
    }   
   
}   
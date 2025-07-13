// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {PreBuiltToken} from "../src/PreBuilt-Token.sol";

contract DeployOurToken is Script {
    uint256 public initialSupply = 1_000_000 * 10 ** 18; // 1 million tokens with 18 decimals

    function run() external  returns (PreBuiltToken) {
        vm.startBroadcast(); // Start broadcasting transactions
        PreBuiltToken token = new PreBuiltToken(initialSupply);
        console.log("Deployed PreBuiltToken at address:", address(token));
        vm.stopBroadcast(); // Stop broadcasting transactions
        return token; // Return the deployed token contract
    }
}
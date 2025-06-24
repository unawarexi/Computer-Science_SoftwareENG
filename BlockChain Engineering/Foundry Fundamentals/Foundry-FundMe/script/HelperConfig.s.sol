// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";
import {Script, console2} from "forge-std/Script.sol";

// Abstract contract holding constant values for use in configs
abstract contract CodeConstants {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    // Chain IDs for supported networks
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

// HelperConfig manages network-specific configuration for price feeds
contract HelperConfig is CodeConstants, Script {
    // Custom error for invalid chain IDs
    error HelperConfig__InvalidChainId();

    // Struct to hold network configuration (currently only priceFeed)
    struct NetworkConfig {
        address priceFeed;
    }

    // Stores the local network config (for Anvil)
    NetworkConfig public localNetworkConfig;
    // Mapping from chain ID to network config for supported networks
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    // Constructor initializes configs for supported networks
    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] = getZkSyncSepoliaConfig();
        // Local config is handled separately when needed
    }

    // Returns the config for a given chain ID, creates local config if needed
    function getConfigByChainId(
        uint256 chainId
    ) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].priceFeed != address(0)) {
            // Return config if it exists for the chain ID
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            // For local chain, create or return the mock config
            return getOrCreateAnvilEthConfig();
        } else {
            // Revert if chain ID is unsupported
            revert HelperConfig__InvalidChainId();
        }
    }

    // Returns the config for Ethereum Sepolia testnet
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH / USD price feed
            });
    }

    // Returns the config for zkSync Sepolia testnet
    function getZkSyncSepoliaConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return
            NetworkConfig({
                priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF // ETH / USD price feed
            });
    }

    // Creates or returns the local (Anvil) mock price feed config
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // If already created, return it
        if (localNetworkConfig.priceFeed != address(0)) {
            return localNetworkConfig;
        }

        // Warn user that a mock contract is being deployed
        console2.log(unicode"⚠️ You have deployed a mock contract!");
        console2.log("Make sure this was intentional");

        // Deploy the mock price feed contract
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        // Store and return the local config
        localNetworkConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return localNetworkConfig;
    }
}

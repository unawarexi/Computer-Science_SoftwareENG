# Lesson 6: Hardhat Simple Storage

In this lesson, we'll explore how to set up a Hardhat development environment, deploy a Simple Storage contract, and verify it on Etherscan. We will also go over troubleshooting techniques and some important configurations.

## Table of Contents
1. [Introduction](#introduction)
2. [Hardhat Setup](#hardhat-setup)
   - [Hardhat Documentation](#hardhat-documentation)
   - [DevDependencies vs Dependencies](#devdependencies-vs-dependencies)
   - [@ Sign in Node Modules](#-sign-in-node-modules)
   - [Troubleshooting Hardhat Setup](#troubleshooting-hardhat-setup)
3. [Deploying SimpleStorage](#deploying-simplestorage)
4. [Networks in Hardhat](#networks-in-hardhat)
   - [The Hardhat Network](#the-hardhat-network)
   - [Hardhat Configuration](#hardhat-configuration)
   - [Chain ID List](#chain-id-list)
5. [Programmatic Verification](#programmatic-verification)
   - [Etherscan Verify Tutorial](#etherscan-verify-tutorial)
   - [Hardhat-Etherscan](#hardhat-etherscan)
   - [Etherscan API Keys](#etherscan-api-keys)
6. [Javascript `==` vs `===`](#javascript--vs-)

## Introduction

Hardhat is a powerful Ethereum development environment that allows developers to compile, deploy, test, and debug their smart contracts. This lesson focuses on deploying a simple storage contract using Hardhat and verifying it on Etherscan.

---

## Hardhat Setup

### Hardhat Documentation

To get started, refer to the official [Hardhat documentation](https://hardhat.org/). It contains essential information about setting up and using Hardhat for Ethereum development.

### DevDependencies vs Dependencies

When installing packages for Hardhat, you might notice two types of dependencies:

- **Dependencies:** These are essential for your application to run, even in production.
- **DevDependencies:** These are only required for development purposes, such as testing or compiling contracts, and are not needed in production.

### @ Sign in Node Modules

In the Node.js ecosystem, the `@` symbol is used for scoped packages. For example, `@nomiclabs/hardhat-ethers` refers to a specific package maintained by the Nomic Labs team that integrates Hardhat with Ethers.js.

### Troubleshooting Hardhat Setup

If you encounter issues while setting up Hardhat, common fixes include:
- Ensuring Node.js and npm are updated.
- Double-checking the installed dependencies in your `package.json` file.
- Running the following command to clean cache and reinstall node modules:
```bash
  rm -rf node_modules
  npm install
```

## Networks in Hardhat
Hardhat allows you to interact with multiple Ethereum networks, such as a local Hardhat network, testnets (Rinkeby, Goerli, etc.), or the Ethereum mainnet.

## The Hardhat Network
Hardhat comes with a built-in local Ethereum network for fast development and testing. By default, when you run a script, Hardhat will use this network unless specified otherwise.

## Hardhat Configuration
The Hardhat configuration file, hardhat.config.js, defines how Hardhat interacts with various networks. Here's an example configuration:

```javascript
module.exports = {
   solidity: "0.8.0",
   networks: {
       hardhat: {},
       rinkeby: {
           url: "https://rinkeby.infura.io/v3/YOUR_INFURA_PROJECT_ID",
           accounts: ["YOUR_PRIVATE_KEY"]
       }
   }
};
```
## Chain ID List
Every Ethereum network has a unique Chain ID. For example:

- `Mainnet: 1`
- `Rinkeby: 4`
- `Goerli: 5`
Use these IDs to specify which network you want to deploy to.


## Programmatic Verification
After deploying your contract, you can verify it programmatically using `Hardhat` and the `Etherscan API`.

## Etherscan Verify Tutorial
To verify your contract on Etherscan:

- 1. **Install the Hardhat Etherscan plugin:**

```bash
npm install --save-dev @nomiclabs/hardhat-etherscan
```
- 2. **Add the Etherscan API key in hardhat.config.js:**

```javascript
module.exports = {
    etherscan: {
        apiKey: "YOUR_ETHERSCAN_API_KEY"
    }
};
```
- 3. **Run the verification command:**

```bash
npx hardhat verify --network <network_name> <contract_address> <constructor_arguments>
```

## Hardhat-Etherscan
The Hardhat-Etherscan plugin simplifies the process of verifying contracts on Etherscan. Follow the steps above to set it up.

## Etherscan API Keys
To interact with the Etherscan API, you will need an API key. You can obtain this from Etherscan.

## Javascript == vs ===
In JavaScript:

**== compares values for equality after performing type conversion (loose equality)**.
**=== compares both value and type for equality (strict equality)**.

```javascript
console.log(5 == '5');  // true, because '5' is converted to 5 before comparison
console.log(5 === '5'); // false, because the types (number and string) are different
```

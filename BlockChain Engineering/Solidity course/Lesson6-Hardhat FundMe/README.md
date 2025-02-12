# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js

```
# Hardhat Key Concepts

This document provides an overview of **Hardhat Deploy Block Confirmations**, **Style Guide**, and **NatSpec** for smart contract development.

## 1. Hardhat Deploy Block Confirmations

### What are Block Confirmations?
Block confirmations refer to the number of blocks mined after a transaction or deployment is included in a block, ensuring its finality. More confirmations reduce the risk of reorganization (reorgs) that could revert the transaction.

### Deploy with Block Confirmations in Hardhat:
You can specify the number of block confirmations before considering a deployment successful, particularly useful on live networks.

Example setup in a deployment script:

```js
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("MyContract", {
    from: deployer,
    log: true,
    waitConfirmations: 5, // Wait for 5 block confirmations
  });
};
```

## 2. Style Guide
### Solidity Style Guide:

- Pragma Directive: Use a single Solidity version for all contracts, or specify a range if needed.

```solidity
pragma solidity ^0.8.0;
```
- Naming Conventions:

Contracts, events, and functions: CamelCase.
Variables and function parameters: camelCase.
Constants: UPPER_CASE.

- Function Visibility:

Explicitly define visibility (public, internal, private).
```solidity
function transfer(address _to, uint256 _value) public {}
```
- `Comments: Use NatSpec comments for documentation (see below)`.

- Error Handling: Use require(), assert(), and revert() appropriately.

- Avoid Magic Numbers: Use named constants instead of inline numbers.

- Modifiers: Keep modifiers simple and avoid complex logic.



## 3. NatSpec (Ethereum Natural Specification Format)
### What is NatSpec?
NatSpec is the documentation standard for Ethereum smart contracts. It helps generate structured comments for contracts, functions, and parameters, enhancing readability and developer collaboration.

NatSpec Comment Annotations:
- **@title**: The title of the contract.
- **@dev**: Notes for developers about the contract.
- **@param**: Description of a function parameter.
- **@return**: Describes the return value.
- **@notice**: Information for end-users of the contract.
- **@custom:**: Custom tags for additional documentation.




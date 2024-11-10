# Blockchain Development Commands with Solidity, Hardhat, Ethers.js, Web3.js

This table provides a summary of essential commands for blockchain development with Solidity, Hardhat, Ethers.js, and Web3.js, covering installation, deployment, testing, and interaction with smart contracts.

# Key Components of the Table:

- **Installation:** Commands for installing various tools, libraries, and dependencies.
- **Solidity Compilation:** Details on compiling smart contracts.
- **Testing:** Commands for running tests and checking gas consumption.
- **Blockchain Networks:** Commands for interacting with local and remote blockchain networks.
- **Contract Deployment:** Commands and a sample script for deploying contracts.
- **Interaction with Smart Contracts:** Example code for interacting with smart contracts using Ethers.js and Web3.js.
- **Verification:** How to verify contracts on Etherscan.
- **Gas Usage and Optimization:** Commands and settings to optimize gas usage.
- **Plugins:** Commands for installing and using various Hardhat plugins.
- **Additional Tools:** Other tools, like OpenZeppelin and Truffle, that are useful for development.

| **Command Category**            | **Command**                                                                         | **Description**                                                                        |
| ------------------------------- | ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **Installation**                |                                                                                     |                                                                                        |
| Install Node.js                 | `https://nodejs.org/`                                                               | Download and install Node.js for running JavaScript/TypeScript and package management. |
| Install Hardhat                 | `npm install --save-dev hardhat`                                                    | Installs Hardhat in your project.                                                      |
| Install Ethers.js               | `npm install ethers`                                                                | Installs Ethers.js library for interacting with the Ethereum blockchain.               |
| Install Web3.js                 | `npm install web3`                                                                  | Installs Web3.js library for blockchain interaction.                                   |
| Initialize a Hardhat Project    | `npx hardhat`                                                                       | Initializes a new Hardhat project with interactive setup options.                      |
| Install Hardhat Dependencies    | `npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle` | Installs necessary packages for Ethers.js and Hardhat.                                 |
| Install Hardhat Testing Plugins | `npm install --save-dev chai mocha @nomiclabs/hardhat-etherscan`                    | Installs testing and Etherscan verification plugins for Hardhat.                       |

| **Solidity Compilation** | | |
| Compile Solidity Contracts | `npx hardhat compile` | Compiles Solidity smart contracts using Hardhat. |
| Solidity Compiler Version | Set `pragma solidity ^0.8.0;` in your contract | Specify the Solidity compiler version in the contract. |

| **Testing** | | |
| Run Tests with Hardhat | `npx hardhat test` | Runs smart contract tests using Hardhat. |
| Run a Specific Test File | `npx hardhat test ./test/filename.js` | Runs tests from a specific file in the `/test` directory. |
| Run Tests with Gas Report | `npx hardhat test --gas` | Runs tests and provides a gas consumption report for each function call. |

| **Blockchain Networks** | | |
| Run Local Ethereum Network | `npx hardhat node` | Starts a local Ethereum blockchain for testing and development. |
| Connect to Hardhat Network | `npx hardhat console --network localhost` | Connect to the local Hardhat network for interactive commands. |
| Connect to Mainnet via Infura | `npx hardhat console --network mainnet` | Connects to the Ethereum Mainnet using Hardhat and Infura (setup required). |
| Connect to Testnet (Rinkeby) | `npx hardhat console --network rinkeby` | Connects to the Rinkeby Testnet using Hardhat and Infura. |
| Add Custom Network to Web3.js | `web3.setProvider(new Web3.providers.HttpProvider('https://rinkeby.infura.io/v3/YOUR_INFURA_PROJECT_ID'))` | Sets a custom provider for connecting to a specific Ethereum network. |

| **Contract Deployment** | | |
| Deploy Contract with Hardhat | `npx hardhat run scripts/deploy.js --network localhost` | Deploys a smart contract on the local Hardhat network. |
| Deploy on Testnet (Rinkeby) | `npx hardhat run scripts/deploy.js --network rinkeby` | Deploys a contract on the Rinkeby testnet. |
| Deploy on Mainnet with Ethers.js | `npx hardhat run scripts/deploy.js --network mainnet` | Deploys a contract on the Ethereum mainnet using Hardhat and Ethers.js. |
| Write Deployment Script | See `scripts/deploy.js` example below | Custom script for deploying contracts. |

| **Deployment Script Example** | `js                                                                     | Example of a deployment script for use with Hardhat and Ethers.js.              |
|                                  | async function main() {                                                   | Initialize the deployment script.                                               |
|                                  | const Contract = await ethers.getContractFactory('MyContract');           | Get the contract factory for your smart contract.                               |
|                                  | const contract = await Contract.deploy();                                 | Deploy the contract.                                                            |
|                                  | await contract.deployed();                                                | Wait for the deployment to complete.                                            |
|                                  | console.log('Contract deployed to:', contract.address);                   | Log the contract address.                                                       |
|                                  | }                                                                        |                                                                                 |
|                                  | main().catch((error) => {                                                 | Error handling for the deployment process.                                      |
|                                  | console.error(error);                                                     |                                                                                 |
|                                  | process.exitCode = 1;                                                     |                                                                                 |
|                                  | });                                                                       |                                                                                 |
|                                  | ` | |

| **Interaction with Smart Contracts** | | |
| Interact with Ethers.js | `js                                                                    | Interact with contracts using Ethers.js.                                         |
|                                   | const provider = new ethers.providers.JsonRpcProvider();                 | Create a JSON-RPC provider.                                                     |
|                                   | const contract = new ethers.Contract(contractAddress, abi, provider);    | Create an instance of the contract using its address and ABI.                   |
|                                   | const value = await contract.someFunction();                             | Call a contract function.                                                       |
|                                   | ` | |
| Interact with Web3.js | `js                                                                    | Interact with contracts using Web3.js.                                          |
|                                   | const Web3 = require('web3');                                            | Import Web3.js.                                                                 |
|                                   | const web3 = new Web3('https://rinkeby.infura.io/v3/YOUR_INFURA_PROJECT_ID'); | Connect to a Web3 provider.                                                     |
|                                   | const contract = new web3.eth.Contract(abi, contractAddress);            | Create an instance of the contract.                                             |
|                                   | const value = await contract.methods.someFunction().call();              | Call a contract function.                                                       |
|                                   | ` | |

| **Verification** | | |
| Verify Contract on Etherscan | `npx hardhat verify --network rinkeby DEPLOYED_CONTRACT_ADDRESS` | Verifies contract source code on Etherscan. |

| **Common Hardhat Tasks** | | |
| Compile Contracts | `npx hardhat compile` | Compiles the Solidity contracts in your project. |
| Run Tests | `npx hardhat test` | Runs the unit tests for the contracts. |
| Run Local Network | `npx hardhat node` | Starts a local Ethereum node for development. |
| Run Scripts | `npx hardhat run scripts/<script_name>` | Executes a script located in the `/scripts` folder. |
| Clean Build Artifacts | `npx hardhat clean` | Removes the build artifacts to clean the project. |

| **Gas Usage and Optimization** | | |
| Check Gas Usage | `npx hardhat test --gas` | Shows gas consumption details when running tests. |
| Enable Optimizer in Compiler | Add `optimizer: { enabled: true, runs: 200 }` to the Solidity settings | Enables the Solidity compiler optimizer to reduce gas costs. |

| **Hardhat Plugins** | | |
| Install Etherscan Plugin | `npm install --save-dev @nomiclabs/hardhat-etherscan` | Installs the Etherscan plugin for verifying contracts. |
| Install Gas Reporter Plugin | `npm install --save-dev hardhat-gas-reporter` | Installs a plugin for reporting gas usage. |
| Enable Gas Reporter in Config | Add `require("hardhat-gas-reporter");` to `hardhat.config.js` | Enables gas reporting during tests. |
| Enable Solidity Coverage Plugin | `npm install --save-dev solidity-coverage` | Installs the Solidity coverage tool for testing smart contract coverage. |

| **Additional Tools** | | |
| Install OpenZeppelin Contracts | `npm install @openzeppelin/contracts` | Installs OpenZeppelin's library of reusable contracts. |
| Use OpenZeppelin CLI | `npx oz` | Launches the OpenZeppelin CLI for managing contracts. |
| Install Truffle | `npm install -g truffle` | Installs Truffle, an alternative to Hardhat for Ethereum development. |

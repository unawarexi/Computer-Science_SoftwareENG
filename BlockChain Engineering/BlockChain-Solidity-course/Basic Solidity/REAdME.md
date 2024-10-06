# Basic Solidity: Types, Functions, Arrays & Structs, Compiler Errors and Warnings, Memory, Storage, Calldata, Mappings, Deploying Contracts, Interacting with Contracts

## Basic Solidity: Types
Basic Solidity Types

### Types & Declaring Variables
Solidity supports various data types including uint256, int256, bool, string, address, and bytes32. Variables are declared using the syntax `type name;`.

### Solidity Types
Solidity provides primitive types like uint, int, bool, string, address, and bytes to represent different kinds of data.

### Bits and Bytes
Solidity allows manipulation of bits and bytes using bitwise operators.

### Default Initializations
Variables in Solidity are initialized with default values. For example, numeric types are initialized to 0, boolean to false, and address to address(0).

### Comments
Solidity supports single-line (`//`) and multi-line (`/* */`) comments for documenting code.

# Basic Solidity: Functions
### Functions
Functions in Solidity define behavior and can be called by other contracts or external accounts.

### Deploying a Contract
To deploy a contract, you need to compile the Solidity code into bytecode and then deploy it to the Ethereum blockchain using a transaction.

### Smart Contracts have addresses just like our wallets
Each deployed contract on the Ethereum blockchain has a unique address.

### Calling a public state-changing Function
Public state-changing functions modify the state of the contract and require a transaction to be executed.

### Visibility
Functions can have different visibilities such as public, private, internal, and external, which determine who can call them.

### Gas III | An example
Executing functions on the Ethereum blockchain consumes gas, which is used to pay for computation.

### Scope
Variables in Solidity have different scopes, such as local scope, function scope, and global scope.

### View & Pure Functions
View functions do not modify the state of the contract, while pure functions do not read or modify the state.

# Basic Solidity: Arrays & Structs

### Structs
Structs allow you to define custom data types with multiple fields.

# Intro to Storage
Storage in Solidity refers to the permanent storage on the Ethereum blockchain.

### Arrays
Solidity supports arrays, which can be dynamic or fixed-sized.

### Dynamic & Fixed Sized
Dynamic arrays can change in size, while fixed-sized arrays have a predetermined length.

### push array function
The `push` function is used to add elements to dynamic arrays.

# Basic Solidity: Compiler Errors and Warnings

### Yellow: Warnings are Ok
Compiler warnings indicate potential issues in the code that may not prevent compilation but should be addressed.

### Red: Errors are not Ok
Compiler errors prevent the code from compiling and must be fixed before deployment.

# Memory, Storage, Calldata (Intro)
6 Places you can store and access data. Solidity provides various storage locations but we focus on  `memory, storage, and calldata`.

- ### calldata
Calldata is a special data location that contains the function arguments passed during a function call.

- ### memory
Memory is a temporary data location used for storing function arguments and variables.

- ### storage
Storage is a permanent data location on the Ethereum blockchain used for storing contract state variables.

## Basic Solidity: Mappings
- #### Mappings
Mappings are key-value pairs that allow efficient lookup of values based on keys.

# Deploying your First Contract
### A testnet or mainnet
To deploy a contract, you need to choose a suitable Ethereum network, such as a testnet or mainnet.

### Connecting Metamask
Metamask is a popular Ethereum wallet and browser extension used for interacting with decentralized applications and deploying contracts.

### Find a faucet here
Faucets provide free test Ether (ETH) for testing purposes on Ethereum testnets.

### Interacting with Deployed Contracts
Once deployed, contracts can be interacted with using their addresses and ABI (Application Binary Interface).

## The EVM 
The Ethereum Virtual Machine (EVM) is the runtime environment for executing smart contracts on the Ethereum blockchain. It executes bytecode and enforces consensus rules.

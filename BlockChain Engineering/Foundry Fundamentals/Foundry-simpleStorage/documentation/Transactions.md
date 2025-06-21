# Transactions in the EVM and zkSync EraVM
For Students & Blockchain Developers

## What is a Transaction?
A transaction is a signed message from one account to another on a blockchain. It’s the fundamental action unit — it’s how you:

- Transfer ETH or tokens
- Deploy smart contracts
- Call functions on smart contracts
- Interact with dApps

Once a transaction is submitted, it’s validated, included in a block, and executed by the network’s virtual machine.

## 1. Core Transaction Components

| Field                   | Description                                              |
|-------------------------|---------------------------------------------------------|
| nonce                   | Prevents double spending. It’s a per-account counter.   |
| to                      | Address of recipient (or empty for contract deployment) |
| value                   | Amount of ETH (in wei) to transfer                      |
| data                    | Encoded calldata for function calls or contract creation|
| gasLimit                | Max gas the sender is willing to use                    |
| maxFeePerGas            | Max total fee willing to pay per unit of gas            |
| maxPriorityFeePerGas    | Tip for miners (part of EIP-1559)                       |
| chainId                 | Chain-specific ID (helps prevent replay attacks)        |
| signature (v, r, s)     | Cryptographic proof that sender authorized it           |

## 1A. Ethereum Transaction Types

Ethereum supports several transaction types, each with different features and fields. Understanding these is important for interacting with the network and interpreting transaction data.

### Type 0: Legacy Transactions

- The original transaction format, used before EIP-2930 and EIP-1559.
- Fields: `nonce`, `gasPrice`, `gasLimit`, `to`, `value`, `data`, `v`, `r`, `s`
- No support for access lists or EIP-1559 fee market.
- Still accepted by the network for backward compatibility.

### Type 1: Access List Transactions (EIP-2930)

- Introduced in EIP-2930 (Berlin hard fork).
- Adds an `accessList` field to help reduce gas costs for certain contract interactions.
- Fields: `chainId`, `nonce`, `gasPrice`, `gasLimit`, `to`, `value`, `data`, `accessList`, `v`, `r`, `s`
- Useful for contracts that access many storage slots or addresses.

**What is an Access List?**

An access list is a list of addresses and storage keys that a transaction expects to access during execution. By specifying this list up front, the Ethereum protocol can pre-load these addresses and storage slots, reducing the gas cost for accessing them. This is especially useful for transactions that interact with multiple contracts or storage locations, as it helps make gas costs more predictable and efficient.

The access list is an array of objects, each specifying:
- An address (the contract or account to access)
- An array of storage keys (specific storage slots to access in that contract)

Example:
```json
[
  {
    "address": "0x1234...abcd",
    "storageKeys": [
      "0x0000000000000000000000000000000000000000000000000000000000000000"
    ]
  }
]
```

### Type 2: EIP-1559 Transactions (Dynamic Fee)

- Introduced in EIP-1559 (London hard fork).
- Most common transaction type on modern Ethereum.
- Fields: `chainId`, `nonce`, `maxPriorityFeePerGas`, `maxFeePerGas`, `gasLimit`, `to`, `value`, `data`, `accessList`, `v`, `r`, `s`
- Supports dynamic fee market (base fee + tip).
- Can include an `accessList` for efficiency.

#### Transaction Type Comparison Table

| Type   | Name/Standard         | Fee Fields                        | Access List | Introduced In   | Notes                                 |
|--------|----------------------|-----------------------------------|-------------|-----------------|---------------------------------------|
| 0      | Legacy               | `gasPrice`                        | No          | Genesis         | Simple, no access list, no EIP-1559   |
| 1      | Access List (EIP-2930)| `gasPrice`                        | Yes         | Berlin (2021)   | Adds access list for efficiency       |
| 2      | EIP-1559 (Dynamic Fee)| `maxFeePerGas`, `maxPriorityFeePerGas` | Yes    | London (2021)   | Dynamic fees, access list supported   |

#### Example: Type 2 (EIP-1559) Transaction

```json
{
  "type": 2,
  "chainId": 1,
  "nonce": 5,
  "maxPriorityFeePerGas": "2000000000",
  "maxFeePerGas": "3000000000",
  "gasLimit": "21000",
  "to": "0x...",
  "value": "1000000000000000000",
  "data": "0x",
  "accessList": [],
  "v": "...",
  "r": "...",
  "s": "..."
}
```

#### Notes for Students

- **Legacy (Type 0) transactions** are still valid, but most wallets and dApps now use Type 2 by default.
- **Access lists** can reduce gas for complex contract calls, but are optional.
- **EIP-1559 (Type 2)** transactions help stabilize gas prices and improve user experience.
- When analyzing transactions on block explorers, check the "type" field to understand which format is used.
- Some Layer 2s and testnets may only support certain types.

## 2. How Ethereum (EVM) Executes Transactions

### Steps in EVM

1. Transaction is signed with the sender’s private key
2. Sent to the mempool
3. Miner/validator picks it up and includes it in a block
4. EVM executes the transaction
5. Updates the world state (storage, balances, logs)

### Execution Outcome

- **Success:** state updates & logs emitted
- **Revert:** changes are rolled back, but gas is still consumed

## 3. Gas and Fees (In Ethereum)

- Every operation in EVM has a gas cost.
- Gas is paid upfront and unused gas is refunded.
- If gas runs out, the transaction fails and all changes revert.

### EIP-1559 (Modern Fee Model)

```
maxFeePerGas = baseFee + tip
```

- Tip goes to miner/validator, baseFee is burned

## 4. Contract Deployment Transaction

If the `to` field is empty (null), it means:

> Create a new smart contract with this bytecode.

- `data` contains the compiled contract creation code
- The address is created deterministically from:

```solidity
address = keccak256(sender, nonce)
```

## 5. Contract Call Transaction

If `to` is a contract:

- The `data` is decoded by EVM as:

```solidity
functionSelector + encoded arguments
```

**Example:**

```solidity
transfer(address,uint256) → 0xa9059cbb
```

## 6. Internal Transactions (Calls)

- Not real blockchain transactions
- These happen within a contract (e.g., one contract calling another)
- They don’t have a nonce or signature
- They can’t be seen on-chain directly (only via trace tools or explorers)

## zkSync EraVM (zkEVM) Transactions

zkSync is a Layer 2 blockchain that uses zk-rollups and its own zkEVM called EraVM, designed to be Solidity-compatible while introducing zk-specific innovations.

### What’s Similar to EVM?

- EraVM uses same transaction structure: nonce, to, value, data, gas, signature
- Same Solidity contracts, forge, hardhat, ethers.js
- Compatible with Metamask, ChainID, etc.
- Use `forge create --zksync`, `forge build --zksync`

### What’s Different in EraVM?

#### 1. Transaction Execution Off-Chain

- zkSync executes transactions off-chain
- Proves correctness with ZK Proofs
- Publishes a batch of transactions + one proof to L1 (Ethereum)
- This makes it faster, cheaper, and cryptographically secure (via ZK-SNARKs)

#### 2. New Transaction Types

- **L2 → L2:** Regular fast transaction on zkSync
- **L1 → L2:** Bridge funds/contracts from Ethereum
- **L2 → L1:** Withdraw back to Ethereum (with finality delay)
- **PriorityOp:** High-priority operations verified by Ethereum

#### 3. Account Abstraction (AA) Built-In

- Every account is a smart contract wallet (can be programmable)
- Native support for:
  - Gasless transactions
  - Multisig, recovery, session keys
- EIP-4337 style accounts are the default.

#### 4. Fee Payment in Any Token

- Users can pay fees in ERC-20 tokens (DAI, USDC)
- The system contracts convert it under the hood

#### 5. System Contracts (New in EraVM)

EraVM has special contracts at reserved addresses for internal tasks:

| Contract              | Address         | Purpose                        |
|-----------------------|----------------|--------------------------------|
| BOOTLOADER            | 0x8000...001   | Executes transactions          |
| SYSTEM_CONTEXT        | 0x8000...004   | Exposes tx info                |
| MSG_VALUE_SIMULATOR   | 0x8000...003   | Handles value simulation       |

**Note:** These addresses are reserved — don’t use them in normal contracts.

#### 6. Gas in EraVM

- Users still specify gasLimit, but zkSync has its own pricing logic
- bootloader manages gas distribution
- zkSync aggregates gas from many users, creates ZK proof, and posts to L1

#### 7. Finality & L1 Commitments

- Transactions are fast (seconds)
- Finality on Ethereum: ~15 mins (when proof is posted)
- Withdrawals from L2 → L1 wait for final proof (delay ~24h typical)

## Advanced Topics

| Concept           | Ethereum (EVM) | zkSync (EraVM)         |
|-------------------|----------------|------------------------|
| Gas Refunds       | Yes            | Yes (via bootloader)   |
| Reverts           | Yes            | Yes (with zero-cost proof) |
| Nonce Gaps        | Disallowed     | Disallowed             |
| Static Calls      | Supported      | Supported              |
| CREATE2           | Supported      | Supported              |
| Native Token      | ETH            | ETH (wrapped internally)|
| Internal Tracing  | Possible       | Yes (zkTrace tools)    |

## Developer Tooling for Transactions

| Tool           | Usage                                 |
|----------------|---------------------------------------|
| forge send     | Send tx via Foundry                   |
| cast send      | Send raw tx                           |
| ethers.js      | wallet.sendTransaction({...})         |
| zksync-web3    | Specialized SDK for EraVM             |
| zkWallet       | zkSync wallet for users               |
| anvil-zksync   | Local zk node for testing             |
| bootloader.sol | Custom logic for handling zk txs      |

## Summary Table

| Feature              | Ethereum (EVM)      | zkSync (EraVM)                |
|----------------------|---------------------|-------------------------------|
| Compatible Solidity  | Yes                 | Yes                           |
| Signature Required   | Yes                 | Yes                           |
| Proof Type           | None                | ZK-SNARK                      |
| Gas Efficiency       | Costly              | Cheap (batched)               |
| Account Type         | Externally Owned    | Smart Contract (AA)           |
| Withdraw to L1       | Native              | Delayed via bridge            |
| Tx Speed             | ~12 sec             | ~2-5 sec                      |
| Tx Cost              | High                | Low                           |

## Final Advice for Students

- Always inspect transactions using a block explorer (Etherscan or ZKscan)
- Learn how to use cast and forge send to build transactions manually
- Understand what gas is and how the EVM bytecode affects cost
- Try deploying the same contract on Ethereum and zkSync to see differences
- Embrace ZK concepts like proof generation, AA wallets, and bootloader behavior
# 📘 Foundry Command Reference

This table lists essential **Foundry CLI commands** and their purposes, organized by tool (`forge`, `cast`, `anvil`, `foundryup`, etc.).

---

## 🛠️ `forge` – Compilation, Testing, Deployment

| Command | Description |
|--------|-------------|
| `forge build` | Compiles all contracts in the `src/` folder and outputs to `out/`. |
| `forge test` | Runs all Solidity-based tests in the `test/` folder. |
| `forge clean` | Deletes the `out/` and `cache/` folders to reset the build. |
| `forge script <script>` | Executes a script (e.g., for deployment or automation). |
| `forge create` | Deploys a contract to the network using bytecode. |
| `forge verify-contract` | Verifies deployed contracts on Etherscan or similar services. |
| `forge install <repo>` | Installs a dependency from GitHub into the `lib/` folder. |
| `forge update` | Updates dependencies installed in `lib/`. |
| `forge fmt` | Formats Solidity source code according to standard style. |
| `forge snapshot` | Saves a snapshot of gas usage for later comparison. |
| `forge coverage` | Reports code coverage for tests (requires plugin). |
| `forge inspect <Contract> <type>` | Displays ABI, bytecode, or storage layout of a contract. |
| `forge help` | Lists all available `forge` subcommands and options. |

---

## 🔗 `cast` – Blockchain Interaction & Utilities

| Command | Description |
|--------|-------------|
| `cast call` | Calls a view/pure function on a deployed contract. |
| `cast send` | Sends a transaction to a contract (requires private key). |
| `cast block` | Prints information about a specific block. |
| `cast tx` | Prints details of a transaction. |
| `cast receipt` | Displays the receipt of a transaction. |
| `cast storage` | Reads raw storage at a specific slot in a contract. |
| `cast balance` | Shows the ETH balance of an address. |
| `cast chain-id` | Prints the current chain ID. |
| `cast keccak <string>` | Returns the Keccak-256 hash of a string. |
| `cast abi-encode` | Encodes function calls or constructor args to calldata. |
| `cast abi-decode` | Decodes calldata or return values from transactions. |
| `cast to-hex` | Converts values (like integers) to hex format. |
| `cast from-hex` | Converts hex to string or integer. |
| `cast wallet new` | Generates a new Ethereum wallet. |
| `cast nonce` | Shows the nonce (tx count) of an address. |
| `cast gas-price` | Prints current network gas price. |
| `cast help` | Lists all `cast` commands and options. |

---

## ⛓️ `anvil` – Local Ethereum Node

| Command | Description |
|--------|-------------|
| `anvil` | Starts a local Ethereum development node with funded accounts. |
| `anvil --fork-url <URL>` | Starts a forked version of another network (e.g., mainnet). |
| `anvil --mnemonic <phrase>` | Uses a custom mnemonic for accounts. |
| `anvil --port <number>` | Changes the default port (8545). |
| `anvil --block-time <seconds>` | Sets the time between mined blocks. |
| `anvil --help` | Shows all available `anvil` options. |

---

## ⬆️ `foundryup` – Installation & Updates

| Command | Description |
|--------|-------------|
| `foundryup` | Installs or updates Foundry (forge, cast, anvil, chisel). |
| `foundryup --version` | Prints the installed version of Foundry. |

---

## 🔍 `chisel` – Bytecode Analysis (Advanced)

| Command | Description |
|--------|-------------|
| `chisel disasm` | Disassembles EVM bytecode into readable opcodes. |
| `chisel help` | Shows available options for disassembly and analysis. |

---

> 💡 Tip: Run `forge <subcommand> --help` or `cast <subcommand> --help` to see usage examples and options.

---

## ✅ Suggested Learning Path for Beginners

1. Learn `forge build`, `forge test`, and `forge script`.
2. Use `anvil` to simulate real-world networks locally.
3. Explore `cast` for interacting with live contracts and sending transactions.
4. Use `forge create` and `forge verify-contract` to deploy and verify contracts.
5. Optionally, learn `chisel` for bytecode inspection and debugging.



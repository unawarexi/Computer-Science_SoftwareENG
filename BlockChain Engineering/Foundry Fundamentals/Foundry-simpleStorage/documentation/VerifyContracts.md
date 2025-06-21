# Smart Contract Verification Guide (Etherscan + Other Tools)

Verifying a contract means **publishing your Solidity source code** and **matching it with the bytecode** deployed on the blockchain. This allows users to read and interact with your contract via Etherscan or similar explorers.

---

## Why Verify a Contract?

| Benefit         | Description                                               |
|-----------------|----------------------------------------------------------|
| Transparency    | Users and developers can inspect the source code.         |
| Trust           | Users are more likely to use your dApp if your contracts are open. |
| Interactivity   | Enables function calls directly from Etherscan.           |
| Auditing        | Essential for security review and public accountability.  |

---

## What You Need Before Verifying

- The deployed contract address.
- The Solidity source code (exact version and structure).
- The compiler version (Solc version used).
- Optimization settings (enabled or not, number of runs).
- Any constructor arguments (if applicable).
- Any linked libraries (if used).
- For proxies, the implementation contract address.

---

## Method 1: Manual Verification via Etherscan

### Step-by-Step

1. Go to [https://etherscan.io/](https://etherscan.io/)
2. Search for your contract address.
3. Click the "Contract" tab.
4. Click "Verify and Publish".
5. Fill in the details:
   - Compiler type: `Solidity (Single file)` or `Solidity (Multi-part)`
   - Version: Match the deployed contract exactly.
   - Optimization: Yes/No, and number of runs.
6. Paste your full source code.
7. Enter constructor arguments (hex-encoded) if applicable.
   - You can get them with `cast` or `ethers.utils.defaultAbiCoder`.
8. Click "Verify".

#### Where to get constructor args

```bash
cast abi-encode "constructor(uint256,address)" 1000 0xAbc...123
# Or view them from the transaction input on Etherscan.
```

**Pro Tip:**  
If verification fails:
- Double-check compiler version and optimizer settings.
- Confirm your source matches exactly what was compiled.
- Rebuild the exact bytecode using a tool like `forge inspect`.

---

## Method 2: Automatic Verification with Foundry

### Step-by-Step

```bash
forge verify-contract \
  --chain-id <CHAIN_ID> \
  --watch \
  <CONTRACT_ADDRESS> \
  <CONTRACT_NAME> \
  <ETHERSCAN_API_KEY>
```

#### Prerequisites

Set your Etherscan API key in `foundry.toml`:

```toml
etherscan_api_key = "YOUR_KEY_HERE"
```

Use `--constructor-args` if needed:

```bash
forge verify-contract \
  --constructor-args $(cast abi-encode "constructor(uint256)" 1000) ...
```

Supports Ethereum, Polygon, Arbitrum, Optimism, Base, etc.

---

## Method 3: Verification in Hardhat

Plugin: `hardhat-etherscan`

Install:

```bash
npm install --save-dev @nomicfoundation/hardhat-verify
```

Add to `hardhat.config.js`:

```js
require("@nomicfoundation/hardhat-verify");

module.exports = {
  networks: {
    mainnet: {
      url: "https://mainnet.infura.io/v3/YOUR_KEY",
      accounts: [PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: "YOUR_ETHERSCAN_API_KEY"
  }
};
```

Verify:

```bash
npx hardhat verify --network mainnet <contract_address> <constructor_args>
```

---

## Method 4: Truffle Contract Verification

Use the `truffle-plugin-verify`:

```bash
npm install -D truffle-plugin-verify
```

In `truffle-config.js`:

```js
module.exports = {
  plugins: ["truffle-plugin-verify"],
  api_keys: {
    etherscan: "YOUR_API_KEY"
  }
};
```

Verify with:

```bash
truffle run verify MyContract --network mainnet
```

---

## Method 5: Remix IDE (Etherscan Plugin)

- Deploy your contract using Remix.
- Install the Etherscan plugin from the Plugin Manager.
- Input the contract address, source, and arguments.
- Click "Verify".

---

## Method 6: Block Explorers for Other Chains

| Chain      | Explorer                  | API Key Setup                |
|------------|---------------------------|------------------------------|
| Polygon    | polygonscan.com           | POLYGONSCAN_API_KEY          |
| BNB Chain  | bscscan.com               | BSCSCAN_API_KEY              |
| Arbitrum   | arbiscan.io               | ARBISCAN_API_KEY             |
| Optimism   | optimistic.etherscan.io   | OPTIMISTIC_ETHERSCAN_API_KEY |
| Avalanche  | snowtrace.io              | SNOWTRACE_API_KEY            |
| Base       | basescan.org              | BASESCAN_API_KEY             |

Use the same method as Etherscan, just change the endpoint/API key.

---

## Constructor Arguments Deep Dive

If your contract has a constructor, Etherscan requires the ABI-encoded constructor arguments as hex.

Example:

```bash
cast abi-encode "constructor(string,address)" "MyToken" 0xabc...
```

Paste the resulting hex string into Etherscan when verifying.

---

## Bytecode Matching Check

To manually compare bytecode:

```bash
forge inspect MyContract bytecode
```

Compare that with deployed bytecode from Etherscan's contract page.

---

## Tips & Best Practices

| Tip                              | Why                                         |
|-----------------------------------|---------------------------------------------|
| Always match compiler version     | Even minor version changes will break bytecode match |
| Keep foundry.toml or hardhat.config.js clean | Makes reproducibility easier         |
| Verify immediately after deployment | Keeps the context fresh                   |
| Save constructor arguments        | Required for every manual verification      |
| Use GitHub Actions to automate verification | Especially in production deployments |

---

## Final Thoughts

Verifying your contract helps ensure:

- Transparency and community trust
- Easier debugging and auditing
- Functional dApp interaction via explorers

Whether you're using Foundry, Hardhat, Remix, or manual Etherscan, there’s a path for you.

---

## Resources

- [Etherscan Contract Verification](https://docs.etherscan.io/)
- [Foundry Book – Verification](https://book.getfoundry.sh/reference/forge/forge-verify-contract)
- [Hardhat Etherscan Plugin](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify)
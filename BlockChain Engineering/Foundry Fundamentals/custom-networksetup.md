# Custom Network Setup in MetaMask Using Anvil

This guide covers how to set up a custom blockchain network in MetaMask using [Anvil](https://book.getfoundry.sh/anvil/), the local Ethereum node bundled with Foundry. It includes step-by-step instructions for development, testing, deployment, and considerations for real-world scenarios.

---

## 1. What is Anvil?

Anvil is a fast local Ethereum node, similar to Ganache, designed for development and testing. It is included with Foundry and is commonly used for running local testnets.

- **Default RPC URL:** `http://127.0.0.1:8545`
- **Default Chain ID:** `31337`
- **Default Accounts:** Pre-funded test accounts

---

## 2. Starting Anvil

To start Anvil, run:

```bash
anvil
```

You should see output indicating the RPC endpoint, chain ID, and a list of private keys for test accounts.

---

## 3. Adding Anvil as a Custom Network in MetaMask

1. **Open MetaMask** and go to the network selector (top left).
2. Click **"Add network"** or **"Add network manually"**.
3. Fill in the following details:

   - **Network Name:** Anvil Local (or any name)
   - **New RPC URL:** `http://127.0.0.1:8545`
   - **Chain ID:** `31337`
   - **Currency Symbol:** ETH
   - **Block Explorer URL:** (leave blank or use a local explorer if set up)

4. Click **"Save"**.

---

## 4. Importing Anvil Accounts into MetaMask

Anvil generates several test accounts with private keys. To use these in MetaMask:

1. Copy a private key from the Anvil terminal output.
2. In MetaMask, go to **"Import Account"**.
3. Paste the private key and import.

**Note:** These accounts are for local testing only. Never use them on mainnet.

---

## 5. Deploying Contracts to Anvil

- Use Foundry's `forge` tool to deploy contracts to Anvil.
- Example:

**Without Scripts**
  ```bash
  forge create path/to/Contract.sol:ContractName --rpc-url http://127.0.0.1:8545 --private-key <PRIVATE_KEY> 
  ```
**With Scripts**
 ```bash
 forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0x34903884389348
 ```

- The contract will be deployed to your local Anvil network and visible in MetaMask.

---

## 6. Testing and Development Workflow

- **Write contracts** in Solidity.
- **Test** using `forge test`.
- **Deploy** to Anvil for local interaction.
- **Interact** with contracts using MetaMask or scripts.

---

## 7. Real-World Scenarios

### a. Forking Mainnet/Testnet

Anvil can fork mainnet or testnets for realistic testing:

```bash
anvil --fork-url https://mainnet.infura.io/v3/YOUR_INFURA_KEY
```

- Use the same MetaMask setup, but now your local node mirrors the state of the forked network.

### b. Custom Chain IDs

- For private networks, always ensure the chain ID in MetaMask matches your node.
- Chain ID `31337` is the default for Anvil, but you can set a custom one:

  ```bash
  anvil --chain-id 12345
  ```

- Update MetaMask accordingly.

### c. Deploying to Testnets/Mainnet

- Change the RPC URL and chain ID in MetaMask to match the target network.
- Use secure private keys for real deployments.

---

## 8. Troubleshooting

- **MetaMask not connecting:** Ensure Anvil is running and the RPC URL is correct.
- **Chain ID mismatch:** Double-check the chain ID in both Anvil and MetaMask.
- **Account balance issues:** Use pre-funded Anvil accounts or fund accounts via Anvil's CLI.

---

## 9. Example Configuration

| Field            | Value                      |
|------------------|---------------------------|
| Network Name     | Anvil Local               |
| RPC URL          | http://127.0.0.1:8545     |
| Chain ID         | 31337                     |
| Currency Symbol  | ETH                       |
| Block Explorer   | (optional)                |

---

## 10. References

- [Foundry Book: Anvil](https://book.getfoundry.sh/anvil/)
- [MetaMask Docs: Custom Networks](https://docs.metamask.io/guide/custom-networks.html)
- [Ethereum Chain IDs](https://chainlist.org/)


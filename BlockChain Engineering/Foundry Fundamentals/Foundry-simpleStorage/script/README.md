# Foundry Scripts

Foundry scripts are Solidity or JavaScript files that automate interactions with smart contracts, such as deploying contracts, sending transactions, or running setup tasks. Scripts are useful for automating repetitive tasks in blockchain development and testing.

## Why Use Scripts in Blockchain Development?

- **Automate deployments:** Easily deploy contracts to local or live networks.
- **Test interactions:** Simulate contract calls and transactions.
- **Setup environments:** Prepare test or production environments with required contract states.

## Running Scripts with Foundry

The primary command to run scripts in Foundry is:

```sh
forge script <SCRIPT_PATH>
```

For example, to deploy the `SimpleStorage` contract using the provided script:

```sh
forge script script/DeploySimpleStorage.s.sol
```

for onchain deployment :  remember to always add `--broadcast`
```bash
forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0x34903884389348
```

This command will execute the `DeploySimpleStorage.s.sol` script, which typically contains logic to deploy the contract and optionally broadcast the transaction to a network.

> **Tip:** Use the `--broadcast` flag to send transactions to a real network, and the `--fork-url` flag to simulate on a forked network.

## Further Reading

- [Foundry Book: Scripts](https://book.getfoundry.sh/tutorials/solidity-scripting)
- [Foundry Documentation](https://book.getfoundry.sh/)


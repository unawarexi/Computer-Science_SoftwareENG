# Maximal Extractable Value (MEV)

## What is MEV?

**MEV (Maximal Extractable Value)** is the maximum value that can be extracted by block producers (miners or validators) by strategically including, excluding, or reordering transactions in a block.

Originally called **Miner Extractable Value**, the term evolved to **Maximal** as MEV now applies to all types of block producers — not just miners.

## Why MEV Matters

MEV can be both profitable for validators (or bots) and harmful to users and network fairness. It creates economic incentives for validator behavior beyond just validating blocks, leading to:

- Front-running
- Sandwich attacks
- Network congestion
- Higher gas fees
- Transaction censorship

## Where Does MEV Happen?

MEV opportunities exist across various DeFi protocols and blockchain applications:

- **Decentralized Exchanges (DEXs)** like [Uniswap](https://uniswap.org/), [Curve](https://curve.fi/)
- **Lending protocols** like [Aave](https://aave.com/), [Compound](https://compound.finance/)
- **Stablecoin arbitrage**
- **Liquidations** (e.g., on [MakerDAO](https://makerdao.com/), Compound)
- **NFT minting** races
- **Cross-chain bridges**

## Common MEV Strategies

| Strategy | Description |
|----------|-------------|
| **Front-running** | Placing a transaction just before a large known transaction (e.g., a big swap) |
| **Back-running** | Executing a trade right after a valuable one to capture price shifts |
| **Sandwich Attack** | Surrounding a victim's trade with buy and sell orders to manipulate price |
| **Liquidation Sniping** | Quickly repaying risky loans to capture liquidation bonuses |
| **Arbitrage** | Exploiting price differences between DEXs |
| **Reorgs (rare)** | Rewriting chain history to reorder profitable transactions |

## Key Actors in MEV Ecosystem

| Actor | Role |
|-------|------|
| **Searchers** | Bot operators who scan mempool and simulate profitable strategies |
| **Builders** | Build optimized blocks with MEV opportunities |
| **Relayers** | Bridge between searchers and validators (used in PBS) |
| **Validators/Miners** | Execute and finalize the block (may select blocks based on profit) |
| **Users** | Often unknowingly affected by MEV attacks |

## MEV Supply Chain (Post-Merge, Ethereum)

```
Users → Mempool → Searchers → Builders → Relays → Validators
```

Ethereum post-Merge uses Proposer-Builder Separation (PBS) to separate MEV logic from validator logic, reducing centralization risk.

## Popular MEV Infrastructure

| Tool/Protocol | Description |
|---------------|-------------|
| [Flashbots](https://www.flashbots.net/) | MEV relay network using MEV-Geth and MEV-Boost |
| [MEV-Boost](https://boost.flashbots.net/) | Open-source software that allows validators to access MEV bundles |
| [Flashbots Protect](https://docs.flashbots.net/flashbots-protect/overview) | User RPC that avoids front-running by sending tx privately |
| Eden Network | Former MEV protection network (discontinued) |
| EthBundle | Transaction bundle format used in Flashbots ecosystem |
| [Blocknative](https://www.blocknative.com/) | Mempool explorer and transaction optimizer |

## Risks of MEV

| Risk | Description |
|------|-------------|
| **User Exploitation** | Loss of funds through sandwiching and front-running |
| **Network Centralization** | Builders or relayers concentrating MEV power |
| **Increased Gas Wars** | Bots outbidding each other for priority, raising gas costs |
| **Reorg Attacks** | In rare cases, miners may revert blocks to re-capture MEV |

## Mitigating MEV

| Defense Mechanism | Description |
|-------------------|-------------|
| **MEV-Boost** | Decentralizes MEV opportunities among validators |
| **Private Transactions** | Send txs directly to validators to avoid the public mempool |
| **Fair Sequencing** | Enforce fair tx ordering using cryptographic techniques |
| **Encrypted Mempools** | Prevent searchers from seeing tx details before they're finalized |
| **Intent-based Architectures** | Instead of sending transactions, users declare "what" they want |
| **Zero-Knowledge Proofs** | Use ZK to hide tx details while ensuring correctness |

## MEV Statistics & Monitoring

| Platform | Use Case | URL |
|----------|----------|-----|
| Flashbots Explorer | Monitor MEV bundles and validators | https://explorer.flashbots.net |
| EigenPhi | Analyze MEV opportunities and searcher data | https://www.eigenphi.io |
| EthTx | View sandwich attacks and bot activity | https://ethtx.info |
| Dune Analytics | Community dashboards for MEV trends | https://dune.com |

## Example: Sandwich Attack

```
Victim wants to swap 100 ETH → USDC
Bot sees tx in mempool:

1. Bot sends Buy ETH → USDC (front-run)
2. Victim's tx executes (drives up price)  
3. Bot sends Sell USDC → ETH (back-run)

Result:
- Bot profits from price shift
- Victim gets worse execution
```

## Further Reading

- [Flashbots Documentation](https://docs.flashbots.net/)
- [MEV on Ethereum Foundation Blog](https://ethereum.org/en/developers/docs/mev/)
- [Proposer-Builder Separation (PBS)](https://ethereum.org/en/roadmap/pbs/)
- [MEV-Boost Documentation](https://boost.flashbots.net/)
- [MEV Research by Flashbots](https://writings.flashbots.net/)

## Summary

| Term | Description |
|------|-------------|
| **MEV** | Maximal Extractable Value – profit from tx ordering |
| **Searcher** | Finds profitable tx opportunities |
| **Builder** | Builds blocks with profitable bundles |
| **MEV-Boost** | Tool to decentralize access to MEV |
| **PBS** | Prevents validator-level MEV centralization |
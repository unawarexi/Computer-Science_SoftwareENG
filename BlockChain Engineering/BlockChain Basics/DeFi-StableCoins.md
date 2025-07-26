# DeFi Stablecoins Overview

##  What Are Stablecoins?

**Stablecoins** are cryptocurrencies pegged to a stable asset, most commonly **fiat currencies** like the **US Dollar (USD)**, **Euro (EUR)**, or **gold**. In **DeFi**, they enable users to:
- Avoid crypto volatility
- Lend/borrow assets
- Participate in yield farming
- Provide liquidity without large risk exposure

---

## Categories of Stablecoins

| Type                     | Peg Mechanism                                 | Example Tokens        | Notes                                                 |
|--------------------------|-----------------------------------------------|------------------------|--------------------------------------------------------|
| **Fiat-Backed (Custodial)** | Backed 1:1 with fiat in banks(exogenous)                  | USDC, USDT, BUSD       | Centralized; requires trust in issuer (Circle, Tether) |
| **Crypto-Backed**         | Overcollateralized with crypto assets(endogenous)          | DAI, LUSD, MIM         | Decentralized; resilient but volatile collateral        |
| **Algorithmic**           | Supply adjusted algorithmically                | FRAX, GHO, USDN (failed) | High risk; some have failed due to peg instability     |
| **Hybrid**                | Combines crypto collateral + algorithmic logic | FRAX, sUSD             | Balanced model to improve stability and scalability    |
| **Commodity-Backed**      | Pegged to physical assets like gold(exogenous)          | PAXG, XAUT              | Tokenized assets; not widely used in DeFi yet          |

---

##  Why Stablecoins Matter in DeFi

| Use Case               | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **Unit of Account**     | Enables pricing in stable terms (e.g., $100 instead of 0.0023 ETH).         |
| **Collateral**          | Used as collateral in DeFi lending/borrowing (e.g., DAI in Aave).          |
| **Liquidity**           | Paired with volatile assets in liquidity pools for trading.                |
| **Yield Farming**       | Earn passive income via stablecoin lending or pool farming.                |
| **Payments**            | Fast, borderless payments with minimal volatility.                         |
| **Stability in Volatility** | Safe haven asset during market downturns.                                 |

---

## 🔥 Popular DeFi Stablecoins & Protocols

| Token       | Type            | Protocol / Issuer     | Chain(s)              | Peg           | Collateral Type                   |
|-------------|------------------|------------------------|------------------------|---------------|-----------------------------------|
| **DAI**     | Crypto-Backed    | MakerDAO               | Ethereum               | 1 USD         | ETH, WBTC, USDC, etc.             |
| **USDC**    | Fiat-Backed      | Circle (CENTRE)        | Ethereum, Solana, etc. | 1 USD         | Fiat (USD in reserves)            |
| **USDT**    | Fiat-Backed      | Tether Ltd.            | Ethereum, Tron, etc.   | 1 USD         | Fiat & other assets (opaque)      |
| **crvUSD**  | Crypto-Backed    | Curve Finance          | Ethereum               | 1 USD         | LLAMMA (pegged AMM-based design)  |
| **FRAX**    | Hybrid           | Frax Finance           | Ethereum, others       | 1 USD         | Partial collateral + algorithmic  |
| **GHO**     | Algorithmic      | Aave                   | Ethereum (soon others) | 1 USD         | Aave aToken collaterals           |
| **LUSD**    | Crypto-Backed    | Liquity                | Ethereum               | 1 USD         | ETH (110% collateral)             |
| **MIM**     | Crypto-Backed    | Abracadabra.money      | Ethereum, Fantom       | 1 USD         | Interest-bearing tokens           |
| **sUSD**    | Synthetic        | Synthetix              | Ethereum, Optimism     | 1 USD         | SNX collateral                    |
| **alUSD**   | Synthetic        | Alchemix               | Ethereum               | 1 USD         | Future yield (auto-repay loan)    |
| **USD+**    | Yield-bearing    | Overnight.fi           | Optimism, Polygon      | 1 USD         | USDC + yield strategies           |
| **RAI**     | Unpegged Stable  | Reflexer               | Ethereum               | Pegless       | ETH (controlled via PID logic)    |

---

##  Collateralization Mechanisms

| Mechanism                | How it Works                                                     | Example Tokens      |
|--------------------------|------------------------------------------------------------------|---------------------|
| **Overcollateralized**    | Lock $150+ to mint $100 stablecoin                              | DAI, LUSD, MIM      |
| **Partially Collateralized** | Minted based on part collateral, part algorithmic backing      | FRAX                |
| **Fully Algorithmic**     | Uses rebasing or supply expansion/contraction to maintain peg   | UST (failed), GHO   |
| **Synthetic/Future Yield**| Loans repaid via deposited yield over time                      | alUSD               |
| **Staked Collateral**     | Uses aToken or LST (e.g. stETH) as minting collateral           | GHO, crvUSD         |

---

## Stablecoin Risks

| Risk Type                | Description                                                                       | Affected Tokens        |
|--------------------------|------------------------------------------------------------------------------------|------------------------|
| **Smart Contract Risk**   | Bugs or exploits in collateral protocols                                          | DAI, GHO, FRAX         |
| **Centralization Risk**   | Issuer can freeze or censor transactions                                          | USDC, USDT             |
| **Depeg Risk**            | Price moves away from $1 due to insufficient backing or market confidence         | UST (collapsed), MIM   |
| **Collateral Volatility** | Falling value of underlying collateral can cause liquidations                    | DAI, LUSD              |
| **Oracle Manipulation**   | Price feed attacks can impact peg accuracy                                       | Any DeFi protocol      |

---

## DeFi Stablecoins in Liquidity & Lending

- **Aave & Compound:** DAI, USDC, USDT are top borrowed/lent assets.
- **Curve Finance:** DAI/USDC/USDT pools dominate TVL.
- **Balancer & FraxBP Pools:** Combine stablecoins for low-slippage swaps.
- **Alchemix:** Use yield-bearing collateral (e.g., Yearn vaults) to mint alUSD.
- **Liquity:** Offers interest-free loans with LUSD, liquidated via Stability Pools.

---

## Examples of DeFi Stablecoin Use Flows

### Lending Flow:
User deposits ETH -> Mints DAI -> Lends DAI on Aave -> Earns yield

```shell
### Lending Flow:
```


### Trading Flow:
User swaps ETH to USDC -> Uses USDC to LP on Uniswap -> Earns fees

```shell

### Trading Flow:
```

### Self-Repaying Loan (Alchemix):
Deposit DAI -> Mint alUSD -> Yield from Yearn auto-pays debt over time

```yaml
### Self-Repaying Loan (Alchemix):
```

---

## Stablecoin Tooling & Analytics

| Tool              | Use Case                             | URL                            |
|-------------------|--------------------------------------|---------------------------------|
| **DeFiLlama**     | TVL rankings and stablecoin flows    | https://defillama.com          |
| **Curve Pools**   | Track stableswap and peg slippage    | https://curve.fi               |
| **MakerBurn**     | DAI stats and CDP dashboard          | https://makerburn.com          |
| **Frax Dashboard**| FRAX metrics, AMO, collateral status | https://app.frax.finance       |
| **Stablecoin Stats**| Peg status and backing for all coins| https://dune.com/hildobby      |

---

## Conclusion

Stablecoins are the **backbone of DeFi**, providing the stability needed to interact with high-volatility crypto markets. From **decentralized loans** to **automated strategies**, they are deeply integrated across all major protocols.

> Want to experiment? Start with MakerDAO (DAI), Curve (stable pools), or Aave (stable lending).

---

## License

MIT License – free to use, remix, or contribute.
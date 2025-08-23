# Circle USDC Cross-Chain Transfer Protocol (CCTP)

## Overview

CCTP is Circle's protocol for moving native USDC across chains using burn-and-mint (no wrapped assets / pooled liquidity). v2 adds a unified message layer, better composability, and two transfer modes: **Standard Transfer** and **Fast Transfer**.

### Key Features

- **Native USDC**: Burns on source chain, mints native USDC on destination
- **No Wrapped Assets**: Eliminates liquidity fragmentation and bridge risk  
- **Two Transfer Modes**: Standard (attestation-first) and Fast (LP pre-funded)
- **Unified Messaging**: v2 provides generalized cross-chain messaging capabilities

## What Problem CCTP Solves

Traditional bridges often lock tokens on chain A and mint a wrapped version on chain B, fragmenting liquidity and adding custodial/bridge risk. CCTP avoids that by burning on source and minting native USDC on destination, using Circle's role as USDC issuer.

## Vocabulary & Standards

### USDC Types

- **USDC (native)**: Fiat-backed stablecoin issued by Circle on L1/L2s. Native units exist on each supported chain.
- **Bridged USDC Standard**: Guidance for OP Stack chains so "bridged USDC" can be upgraded in-place to native USDC later by Circle, avoiding fragmentation.
- **USDC Standard (general)**: Circle's alignment initiative to unify symbols, metadata, and upgrade paths across ecosystems.

> **Note**: Chain support evolves. Example: Circle ended USDC support on Tron (Feb 2024/2025 timelines for redemption). Always check the latest support matrix.

## CCTP v1 vs v2 Comparison

| Aspect | CCTP v1 | CCTP v2 |
|--------|---------|---------|
| **Transfer model** | Burn on source → attestation → mint on destination | Same burn/mint, but with unified V2 message layer and two modes (Standard & Fast) |
| **On-chain components (EVM)** | MessageTransmitter (v1) + TokenMessenger/TokenMinter | MessageTransmitterV2 + TokenMessengerV2 (EVM); Solana uses Anchor programs with similar roles |
| **Settlement speed options** | Single path (attestation then mint) | Standard (attestation first, then mint) or Fast (LP pre-funds, CCTP finalizes later) |
| **Composability** | Good | Improved hooks & generalized messaging for richer cross-chain UX/composition |
| **Nonce & message format** | v1 style | V2 nonces, API to query messages (/v2/messages) |

## Architecture (v2)

### Core On-Chain Components

- **MessageTransmitterV2**: Generalized cross-chain message bus & verification layer
- **TokenMessengerV2**: USDC-specific adapter that burns on source and mints on destination after a valid message is received
- **Solana**: Deployed as Anchor programs playing equivalent roles

### Off-Chain Components

- **Circle attestation service**: Observes burns, issues signed attestations (or otherwise validates messages) that the destination chain contracts will accept
- **V2 Nonces & APIs**: Each message has a nonce (unique per destination domain). Query via Circle's `/v2/messages` API using a transaction hash

## Transfer Flows (v2)

### 1. Standard Transfer

**When to use**: You're okay waiting for attestation (finality-aligned), want simplest trust/minimal parties.

**Sequence**:
1. Initiate burn on source via TokenMessengerV2 (USDC is burned; a message is emitted)
2. **Attestation**: Circle (off-chain) confirms burn and prepares/verifies the message
3. **Mint on destination**: Submit the attested message to MessageTransmitterV2/TokenMessengerV2; USDC is minted to the recipient

**Pros**: Minimal trust beyond Circle, native USDC, strong replay/nonce protections  
**Trade-offs**: Latency = source finality + attestation availability

### 2. Fast Transfer

**When to use**: You want near-instant UX; you (or a router/LP) can provide temporary destination liquidity.

**Sequence**:
1. User initiates a cross-chain send; an LP/router agrees to pre-fund the destination address immediately
2. Burn occurs on source; later, Circle attestation arrives on destination
3. **Settlement**: The LP (or contract) claims the final minted USDC upon message confirmation to replenish its liquidity

**Pros**: Great UX (funds arrive fast), still resolves to native USDC (no wrapped asset)  
**Trade-offs**: Involves liquidity providers and routing infra; you'll design slippage/fee/timeout rules

## Smart Contracts & Repositories

### EVM Contracts
- `MessageTransmitter`/`MessageTransmitterV2`
- `TokenMessenger`/`TokenMessengerV2` 
- `TokenMinter`

**Source**: [circlefin/evm-cctp-contracts](https://github.com/circlefin/evm-cctp-contracts) (build, analyze, ABIs, etc.)

## Security Model & Audits

### Security Features
- **No pooled TVL**: Eliminates lock-and-mint risk; native USDC is minted post-burn
- **Message verification**: Destination mints only after a valid Circle-attested message is accepted
- **Nonces / replay protection**: V2 introduces per-message nonces, queryable via API

### Audits
Public V2 audit and whitepaper outline threat model, dependencies, and findings.

### Your Responsibility
Handle timeouts, refunds, idempotency, and griefing costs (esp. for Fast Transfer LPs). Consider circuit breakers and rate limits.

## Developer Integration Guide (EVM)

### Readiness Checklist

1. Verify your source/destination chains are CCTP-enabled and USDC is native there
2. For Fast Transfer, pick or build a router/LP mechanism with:
   - Balance & risk controls
   - Fee model (bps or fixed)
   - Timeout / fallbacks if settlement fails/delays

### Typical Standard Transfer Flow

#### 1. Approve + Burn on Source
```solidity
USDC.approve(TokenMessengerV2, amount)
TokenMessengerV2.depositForBurn(amount, destinationDomain, recipient)
```

#### 2. Poll Circle API
Poll Circle API for message/nonce status (or listen off-chain for events)

#### 3. Mint on Destination
```solidity
MessageTransmitterV2.receiveMessage(message, attestation)
// TokenMessengerV2.mint(...) occurs under the hood when validation passes
```

### Observability

- Use Circle's APIs to track message states and nonces (`/v2/messages?txHash=<...>`)
- Keep dashboards for time-to-finality, attestation latency, LP balances (Fast), and reorg/rollback alerts

## Operational Concerns

### Fees & Costs
- On-chain gas on both sides (burn tx + receive/mint tx)
- Fast Transfer introduces LP fees or spreads (your app defines)
- CCTP does not require liquidity pools; costs relate to gas + infra + LP premium (if fast)

### Rate Limits & Throughput
- Your app should implement rate limits to protect LP liquidity and user safety
- V2's design (unified messaging & nonces) supports higher throughput and better tooling

### Chain Coverage & Deprecations
Supported networks expand over time; some networks can be added (or deprecated, e.g., Tron). Always check current status before enabling routes.

## Usage Recommendations

| Scenario | Recommended Approach |
|----------|---------------------|
| **Payments/remittance UX, speed sensitive** | Fast Transfer (v2) + reputable LP/router (still settles to native USDC) |
| **Institutional flows, DeFi treasuries, exactness over speed** | Standard Transfer (v2) |
| **Complex cross-chain actions beyond USDC** | Compose with MessageTransmitterV2 (generalized messaging) and your own handlers |

## Example App Patterns

### Simple Bridge UI
Standard transfer by default; offer "Fast (Recommended)" toggle with transparent fee & ETA

### Aggregator/Router
Route to best LP for Fast, with slippage caps & failover to Standard

### Composable DeFi
After mint, hook into a strategy on destination (e.g., deposit to a protocol). v2's generalized messaging supports richer post-mint flows

## Testing & Development Tips

### Getting Started
- Start on testnets supported by CCTP; use small transfers
- Instrument end-to-end tracing: burn tx hash → `/v2/messages` → destination receive → final mint

### Adversarial Testing
Test the following scenarios:
- Attestation delays / timeouts
- Destination gas spikes  
- LP insolvency (Fast) and refund paths
- Replay attempts (should be blocked by nonce use)

## Useful Links

- [CCTP Product Page](https://circle.com) - Overview and positioning
- [CCTP v2 Developer Docs](https://developers.circle.com) - How it works, Standard vs Fast, APIs
- [Generalized Message Passing](https://developers.circle.com) - Architectural details (v1/v2, Solana & EVM)
- [Message Format & V2 Nonces](https://developers.circle.com) - API & format notes
- [EVM Contracts Repository](https://github.com/circlefin/evm-cctp-contracts) - Sources, ABIs, analysis targets
- [CCTP v2 Whitepaper & Audit](https://hubspot.com) - Security model and findings
- [Bridged USDC Standard](https://docs.optimism.io) - Upgrade path to native (OP Stack)

## FAQs

### Is Fast Transfer "trustless"?
It's still native USDC end-state, but speed comes from LPs fronting funds. You must trust the LP routing layer (your app/partners) for UX and economics until CCTP settlement completes. The mint still requires Circle's verified message.

### Do I ever hold wrapped USDC with CCTP?
No. CCTP is designed to avoid wrapped assets by burning native USDC on source and minting native USDC on destination.

### How do I check a transfer's status?
Track the burn tx on the source chain, then query Circle's `/v2/messages` by tx hash to see message/nonces, and finally the receive/mint tx on destination.

### What if Circle deprecates a chain?
You can usually redeem/migrate within a timeframe. Always check the latest announcements & docs before enabling a new route.

---

> **⚠️ Important**: Always verify the latest chain support and documentation on Circle's official resources before implementing CCTP in production.
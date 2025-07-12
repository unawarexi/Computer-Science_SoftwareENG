# Blockchain Tokens Reference

## What Are Blockchain Tokens?

Tokens are digital assets built on top of a blockchain, typically representing value or access rights within a decentralized system.

## Tokens vs Coins

| Coins | Tokens |
|-------|--------|
| Native to a blockchain (e.g., ETH on Ethereum) | Built on top of a blockchain (e.g., USDC on Ethereum) |
| Usually used for fees and consensus | Represent value, utility, or rights |

## Why Do We Need Standards?

Imagine building a vending machine that accepts digital tokens. If every token follows a standard, your machine doesn't need to be reprogrammed for each one.

Standards ensure compatibility and security.

## Ethereum Standards: ERCs and EIPs

### EIP: Ethereum Improvement Proposal

A formal document proposing changes to Ethereum.

Not just about tokens—includes protocol upgrades, gas changes, etc.

### ERC: Ethereum Request for Comments

A type of EIP focused on application-level standards, like tokens.

Examples: ERC-20 (fungible tokens), ERC-721 (NFTs), ERC-4626 (tokenized vaults).

## Common Token Standards (ERCs)

### ERC-20 – Fungible Tokens

Most widely used token standard.

Used for things like USDT, DAI, Chainlink (LINK).

All tokens are interchangeable and equal (like dollars or ETH).

**Key Functions:**
```solidity
function transfer(address to, uint amount)
function balanceOf(address account)
function approve(address spender, uint amount)
function transferFrom(address from, address to, uint amount)
function allowance(address owner, address spender)
```

### ERC-721 – Non-Fungible Tokens (NFTs)

Each token is unique and non-interchangeable.

Used for art, game items, land, collectibles.

Examples: CryptoPunks, Bored Ape Yacht Club.

**Key Functions:**
```solidity
function ownerOf(uint tokenId)
function safeTransferFrom(address from, address to, uint tokenId)
function tokenURI(uint tokenId)
```

### ERC-1155 – Multi-Token Standard

Supports both fungible and non-fungible tokens in one contract.

Efficient for games, where you might have both:
- 100 identical swords (fungible)
- 1 rare dragon (NFT)

### ERC-4626 – Tokenized Vault Standard

Used for DeFi yield-bearing vaults.

Wraps a vault's logic and token economics in a standard interface.

## Real-world Token Examples

| Token | Standard | Use Case |
|-------|----------|----------|
| USDC | ERC-20 | Stablecoin |
| LINK | ERC-20 | Chainlink oracle token |
| Bored Ape | ERC-721 | NFT |
| AAVE Vault | ERC-4626 | DeFi staking vault |

## PEP – Python Enhancement Proposal?

Just to clarify:

PEP is not related to Ethereum — it refers to Python Enhancement Proposals in Python programming.

The Ethereum equivalent is EIP (Ethereum Improvement Proposal).

## Summary for Students

| Term | Meaning |
|------|---------|
| Token | Digital unit of value built on a blockchain |
| ERC | Ethereum standard for tokens and apps |
| ERC-20 | Standard for fungible tokens |
| ERC-721 | Standard for NFTs |
| EIP | Ethereum proposal for upgrades/changes |
| Smart contract | Code deployed on blockchain that defines token behavior |

## Teaching Analogy

- **ERC-20** is like making dollars — all dollars are the same.
- **ERC-721** is like Pokémon cards — each one is unique.
- **ERC-1155** is like a game inventory — some items stack, some don't.
- **EIPs** are like government bills — new laws or updates to the system.
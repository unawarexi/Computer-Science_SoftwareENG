# Foundry Setup Guide

Foundry is a fast and flexible toolkit for smart contract development written in Rust. This guide helps you install, configure, and run your first Foundry project — perfect for students and beginners learning Solidity development.

---

## Prerequisites

Before installing Foundry, make sure you have the following:

- Operating System: Linux, macOS, or Windows (WSL for Windows recommended)
- Git installed: [https://git-scm.com/downloads](https://git-scm.com/downloads)
- Rust installed: [https://rustup.rs](https://rustup.rs)
- Node.js (optional, for frontend or tooling): [https://nodejs.org](https://nodejs.org)

---

## Step 1: Install Foundry

You can install Foundry using the official `foundryup` script.

```bash
curl -L https://foundry.paradigm.xyz | bash
```

After installing, make sure to restart your terminal or run:

```bash
source ~/.bashrc      # or ~/.zshrc or ~/.profile depending on your shell
```

---

## Step 2: Install the Foundry Tools

After installing Foundry, you need to install the individual tools like forge, cast, and anvil.

```bash
foundryup
```
if it throws an error then run this - before running **foundryup** again  

```bash
brew install libusb
foundryup
```

This downloads and sets up the following tools:

- `forge` – for building and testing smart contracts
- `cast` – for interacting with Ethereum networks from the command line
- `anvil` – a local Ethereum node, like Hardhat's or Ganache

---

## Step 3: Create a New Foundry Project

Use forge to initialize a new Solidity project:

```bash
forge init my-first-foundry-project
cd my-first-foundry-project
```

This creates a standard folder structure like:

```
my-first-foundry-project/
├── lib/           # Dependencies (installed via git or forge install)
├── script/        # Deployment and scripting code
├── src/           # Solidity contracts
├── test/          # Test contracts (written in Solidity)
└── foundry.toml   # Foundry config file
```

---

## Step 4: Build Your Contracts

To compile your contracts:

```bash
forge build
```

Compiled contracts will be saved in the `out/` directory.

---

## Step 5: Run Your Tests

Foundry tests are written in Solidity. To run them:

```bash
forge test
```

For more detailed output:

```bash
forge test -vvv
```

---

## Sample Test File

Create a file in `test/`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract MyTest is Test {
    function testAddition() public {
        assertEq(1 + 1, 2);
    }
}
```

---

## Optional: Start a Local Node with Anvil

To spin up a local Ethereum node:

```bash
anvil
```

This gives you test accounts, a running RPC, and live logging.

---

## Learn More

- Official Book: https://book.getfoundry.sh/
- Foundry GitHub: https://github.com/foundry-rs/foundry
- Tutorials: Look up YouTube and community guides for “Foundry Ethereum development”

---

## FAQ

**Q: Is Foundry a replacement for Hardhat?**  
A: Yes, Foundry is an alternative — it's faster and written in Rust, but doesn't require Node.js.

**Q: Can I write tests in JavaScript?**  
A: No, Foundry uses Solidity-based testing. If you want JS-based tests, use Hardhat.

**Q: Do I need to install Ganache or Metamask?**  
A: Not necessarily. Foundry comes with anvil for local testing, but you can use Metamask if needed.
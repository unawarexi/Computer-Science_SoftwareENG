# Installing Third-Party Packages in a Foundry Project

This guide explains how to install and use third-party Solidity libraries (e.g., Chainlink, OpenZeppelin) in a Foundry project using `forge`. It covers how dependencies are structured, imported, and compiled, so you can confidently extend your smart contracts using community-built tools.

---

## Requirements

- Foundry installed (`forge` CLI available)
- An initialized Foundry project (`forge init` already run)
- Git installed (Foundry uses git to fetch libraries)

---

## Installing a Third-Party Package

Foundry installs third-party Solidity packages using Git. Use the `forge install` command.

### Common `forge install` Flags

| Flag                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `--commit`          | create a commit after installing the dependency.                      |
| `--no-git`          | Do not initialize the dependency as a git submodule.                         |
| `--branch <name>`   | Install a specific branch of the dependency.                                 |
| `--tag <tag>`       | Install a specific tag of the dependency.                                    |
| `--rev <sha>`       | Install a specific commit hash of the dependency.                            |
| `--path <path>`     | Install the dependency from a local path instead of a remote repository.     |
| `--quiet`           | Suppress output except for errors.                                           |
| `--force`           | Overwrite existing dependency if it already exists.                          |

### Example: Install Chainlink Contracts

```bash
forge install smartcontractkit/chainlink-brownie-contracts
```

This will:

- Clone the Chainlink contracts repo into the `lib/` folder
- Lock the version in `foundry.toml`
- Make the contracts available to import in your code

### Project Structure After Install

```
my-project/
│
├── lib/
│   └── chainlink-brownie-contracts/
│
├── foundry.toml
```

### Installing Other Common Packages

```bash
forge install OpenZeppelin/openzeppelin-contracts
forge install transmissions11/solmate
forge install starkware-libs/cairo-lang
```

## Importing Third-Party Contracts

You can now import installed contracts directly in your Solidity files using the `lib/<repo>/` path.

**Example:**

```solidity
// Import Chainlink’s VRFConsumerBase
import "lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBase.sol";
```

**Tip:**  
To simplify imports, consider setting up remappings (see below).

## Remappings (Optional but Recommended)

Instead of using long paths like `lib/chainlink-brownie-contracts/...`, remappings let you write cleaner imports like:

```solidity
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
```

### How to Add Remappings

Edit your `foundry.toml`:

```toml
remappings = [
  "@chainlink/=lib/chainlink-brownie-contracts/"
]
```

You can add multiple remappings for other packages too.

## Updating Installed Packages

You can update a package to the latest version using:

```bash
forge update
```

To update a specific dependency:

```bash
forge update smartcontractkit/chainlink-brownie-contracts
```

## Compile and Test

Once installed and imported, run:

```bash
forge build
forge test
```

This ensures your project and dependencies are compiled together.

## Removing a Package

Manually delete the folder in `lib/`, and optionally remove any remappings from `foundry.toml`:

```bash
rm -rf lib/chainlink-brownie-contracts
```

## Notes for Students

- Dependencies are downloaded from GitHub by default.
- Always check the Solidity version of the package and match it in your own code (`pragma solidity`).
- Some packages require additional tools (like Chainlink VRF needing oracle setup).

## Common Errors and Fixes

| Error                      | Cause                        | Solution                          |
|----------------------------|------------------------------|-----------------------------------|
| ParserError on import      | Wrong import path            | Use full path or fix remapping    |
| Version mismatch           | Contract uses older/newer Solidity | Align pragma solidity or use compatible release |
| Cannot compile             | Missing remapping            | Add remapping in foundry.toml     |

## Resources

- Foundry Book: Installing Packages
- Chainlink GitHub Repo
- OpenZeppelin Contracts
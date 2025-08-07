# OpenZeppelin Smart Contract Cheat Sheet

A comprehensive reference of key contracts, modifiers, roles, and utility functions from OpenZeppelin Contracts for secure smart contract development.

## Table of Contents
- [Core Contracts](#core-contracts)
- [AccessControl Roles](#accesscontrol-roles)
- [Important Modifiers](#important-modifiers)
- [Common Functions](#common-functions)
- [Utilities](#utilities)
- [Security Features](#security-features)
- [Testing with Hardhat](#testing-with-hardhat)
- [Recommended Libraries](#recommended-libraries)
- [Best Practices](#best-practices)

## Core Contracts

| Contract | Inherits From | Description |
|----------|---------------|-------------|
| `Ownable` | Context | Basic access control — single owner |
| `AccessControl` | Context, IAccessControl | Role-based permission management |
| `AccessControlEnumerable` | AccessControl | Role management with enumeration |
| `Pausable` | Context | Adds emergency stop mechanism |
| `ReentrancyGuard` | – | Prevents reentrancy attacks |
| `ERC20` | IERC20, Context | Standard fungible token logic |
| `ERC20Burnable` | ERC20 | Adds burn() and burnFrom() |
| `ERC20Capped` | ERC20 | Adds max supply cap |
| `ERC20Permit` | ERC20 | Allows approvals via signatures (EIP-2612) |
| `ERC721` | IERC721, Context | NFT token standard |
| `ERC721Enumerable` | ERC721 | Adds token enumeration |
| `ERC721URIStorage` | ERC721 | Token metadata management |
| `ERC1155` | IERC1155 | Multi-token standard |
| `TimelockController` | AccessControl | Delays sensitive operations |
| `Governor` | Multiple | DAO governance logic |
| `UUPSUpgradeable` | ERC1967Upgrade | Upgradable contract standard |

## AccessControl Roles

| Constant | Purpose |
|----------|---------|
| `DEFAULT_ADMIN_ROLE` | Can grant/revoke any role, including itself |
| `keccak256("MINTER_ROLE")` | Used for minting functions |
| `keccak256("BURNER_ROLE")` | For burning logic |
| `keccak256("PAUSER_ROLE")` | To pause/unpause contract |
| `keccak256("UPGRADER_ROLE")` | For UUPS upgrades |

> **Note:** Always hash role names using `keccak256()` for consistency.

### Role Definition Examples

```solidity
bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
```

## Important Modifiers

| Modifier | From | Description |
|----------|------|-------------|
| `onlyOwner` | Ownable | Restricts function to contract owner |
| `onlyRole(bytes32 role)` | AccessControl | Restricts function to a specific role |
| `nonReentrant` | ReentrancyGuard | Prevents reentrant calls |
| `whenNotPaused` / `whenPaused` | Pausable | Guards functions based on pause state |
| `initializer` | Initializable | Used in upgradeable contracts to mark initializer |
| `onlyProxy` | UUPSUpgradeable | Ensures function is called through delegatecall |

### Usage Examples

```solidity
function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
    _mint(to, amount);
}

function emergencyWithdraw() external onlyOwner whenPaused {
    // Emergency logic here
}

function deposit() external nonReentrant {
    // Deposit logic protected from reentrancy
}
```

## Common Functions

| Function | From | Purpose |
|----------|------|---------|
| `_grantRole(role, account)` | AccessControl | Grants role to account (internal) |
| `grantRole(role, account)` | AccessControl | Public version with access control |
| `revokeRole(role, account)` | AccessControl | Removes role from account |
| `hasRole(role, account)` | AccessControl | Checks if an account has a role |
| `pause()` / `unpause()` | Pausable | Changes contract's operational state |
| `transferOwnership(newOwner)` | Ownable | Transfers contract ownership |
| `renounceOwnership()` | Ownable | Relinquishes ownership |
| `burn()` / `burnFrom()` | ERC20Burnable | Burns tokens |
| `mint(to, amount)` | ERC20 (custom) | Custom mint function |
| `upgradeTo(newImplementation)` | UUPSUpgradeable | Upgrades contract logic |

### Implementation Examples

```solidity
// Role management
constructor() {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(MINTER_ROLE, msg.sender);
}

// Pausable functionality
function pause() external onlyRole(PAUSER_ROLE) {
    _pause();
}

function unpause() external onlyRole(PAUSER_ROLE) {
    _unpause();
}
```

## Utilities

| Utility | Purpose |
|---------|---------|
| `Counters.Counter` | Safe auto-incrementing IDs (e.g., ERC721 token IDs) |
| `SafeMath` (deprecated) | Now unnecessary (Solidity ≥0.8 has built-in checks) |
| `Strings` | Utilities for string conversion (e.g., toString, toHexString) |
| `ECDSA` | Signature verification utilities |
| `EIP712` | Structured signature handling |
| `MerkleProof` | Verify proofs from Merkle trees |
| `Math` | Extra math helpers (sqrt, max, min, etc.) |
| `Address` | Useful functions for addresses (e.g., isContract) |





## Security Features

| Feature | Contracts | Use Case |
|---------|-----------|----------|
| Pausing | Pausable | Temporarily stop sensitive functions |
| Reentrancy Lock | ReentrancyGuard | Protect from recursive calls |
| Timelock | TimelockController | Delay critical operations |
| Role-based auth | AccessControl | Decentralized permission control |
| Upgrade guards | UUPSUpgradeable | Prevent unprotected upgrades |
| Signature checks | ECDSA, ERC20Permit | Off-chain approvals, metatransactions |




### Security Implementation

```solidity
contract SecureVault is AccessControl, Pausable, ReentrancyGuard {
    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");
    
    function withdraw(uint256 amount) 
        external 
        onlyRole(WITHDRAWER_ROLE) 
        whenNotPaused 
        nonReentrant 
    {
        // Secure withdrawal logic
    }
}
```

## Testing with Hardhat

| Cheat Code | Plugin/Helper | Description |
|------------|---------------|-------------|
| `ethers.provider.send("evm_increaseTime", [seconds])` | Hardhat | Simulate time travel |
| `ethers.provider.send("evm_mine")` | Hardhat | Force block mining |
| `impersonateAccount(address)` | Hardhat | Simulate calls from any account |
| `setBalance(address, amount)` | Hardhat | Set ETH balance in test |
| `signTypedData(...)` | EIP712 | Used for signature tests |



## Recommended Libraries

### Core Libraries
- **@openzeppelin/contracts**: Core contracts
- **@openzeppelin/contracts-upgradeable**: For upgradeable versions (proxy-safe)
- **@openzeppelin/test-helpers**: Assertions and utilities for testing
- **@openzeppelin/hardhat-upgrades**: Plugin to deploy and upgrade UUPS contracts

### Installation

```bash
npm install @openzeppelin/contracts
npm install @openzeppelin/contracts-upgradeable
npm install --save-dev @openzeppelin/test-helpers
npm install --save-dev @openzeppelin/hardhat-upgrades
```


## Best Practices

### Security Recommendations

- **Never assign roles to `msg.sender` without checks**
- **Secure `DEFAULT_ADMIN_ROLE` with multisig or timelock**
- **Use `AccessControl` over `Ownable` for large dApps**
- **Avoid calling `initialize()` twice (use `initializer` modifier)**
- **Use `keccak256("ROLE_NAME")` for consistent role identifiers**
- **Secure `upgradeTo()` with `onlyProxy` or `onlyRole(UPGRADER_ROLE)`**

### Code Quality Guidelines

```solidity
// Good: Proper role definition
bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

// Good: Secure admin setup
constructor() {
    _grantRole(DEFAULT_ADMIN_ROLE, timelockAddress);
    _grantRole(ADMIN_ROLE, timelockAddress);
}

// Good: Protected upgrade function
function _authorizeUpgrade(address newImplementation) 
    internal 
    onlyRole(UPGRADER_ROLE) 
    override 
{}
```

### Common Pitfalls to Avoid

```solidity
// Bad: Direct role assignment without protection
constructor() {
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Risky for production
}

// Bad: Unprotected upgrade function
function _authorizeUpgrade(address) internal override {
    // No access control - anyone can upgrade!
}

// Bad: Multiple initialization calls
function initialize() public {
    // Missing initializer modifier - can be called multiple times
}
```

---

## Contributing

This cheat sheet is maintained as a reference for OpenZeppelin smart contract development. For the most up-to-date information, always refer to the [official OpenZeppelin documentation](https://docs.openzeppelin.com/).
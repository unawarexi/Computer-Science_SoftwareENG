# Smart Contract Development Patterns

This README covers two important patterns in smart contract engineering:

- Checks-Effects-Interactions (CEI)
- Arrange-Act-Assert (AAA) for testing

---

## 1. Checks-Effects-Interactions (CEI) Pattern

The **Checks-Effects-Interactions** pattern is a best practice for writing safe, predictable, and **reentrancy-resistant** smart contracts.

CEI stands for:

- **Checks** – Verify inputs and permissions
- **Effects** – Update the contract's internal state
- **Interactions** – Make external calls (e.g., transfer ETH, call another contract)

Think of it like firewall layers:

> Check first → change your own state → call out last

### Why Use CEI?

- Prevents **reentrancy attacks**
- Makes code logic easier to reason about
- Ensures consistent internal state before calling external contracts

### CEI Structure:

```solidity
function withdraw() public {
    // 1. Checks
    require(balances[msg.sender] > 0, "No balance to withdraw");

    uint256 amount = balances[msg.sender];

    // 2. Effects
    balances[msg.sender] = 0;

    // 3. Interactions (external calls come last)
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

### Without CEI (Risky):

```solidity
// Vulnerable to reentrancy
function withdraw() public {
    uint256 amount = balances[msg.sender];
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success);
    balances[msg.sender] = 0;
}
```

## 2. Arrange-Act-Assert (AAA) Pattern for Testing

The AAA pattern is a clean and structured way to organize tests. It makes test logic more readable and separates concerns clearly.

### Structure:

| Phase | Description |
|-------|-------------|
| Arrange | Set up the test environment and state |
| Act | Perform the action under test |
| Assert | Verify the expected outcome or behavior |

### Example in Foundry:

```solidity
function testWithdrawShouldResetBalance() public {
    // Arrange
    vm.deal(address(user), 1 ether);
    vm.prank(user);
    contractInstance.deposit{value: 1 ether}();

    // Act
    vm.prank(user);
    contractInstance.withdraw();

    // Assert
    uint256 remainingBalance = contractInstance.balances(user);
    assertEq(remainingBalance, 0);
}
```

### Benefits:

- Improves test clarity and debugging
- Encourages independent, predictable tests
- Helps isolate test failures to one specific stage

## Combining Both Patterns

Writing your contracts using CEI and structuring your tests using AAA ensures:

- Safety in production
- Clean, maintainable test suites
- Readable and robust smart contract systems

## References

- [Solidity Security Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Ethereum Smart Contract Security](https://ethereum.org/en/developers/docs/smart-contracts/security/)

## Summary

| Pattern | Purpose | Key Benefit |
|---------|---------|-------------|
| CEI | Safe and predictable contract logic | Prevents reentrancy and side-effects |
| AAA | Clean and structured test writing | Easier to read and maintain tests |
# Fuzz Testing in Smart Contracts

## What is Fuzz Testing?

Fuzz testing (or fuzzing) is a form of automated property-based testing where the testing framework supplies randomized input data to your functions and checks if they:

- Revert unexpectedly
- Violate assertions
- Overflow/underflow
- Cause unwanted side effects

Think of it as a smart monkey throwing thousands of values at your code to find bugs you might miss in normal tests.

## Why Use Fuzz Testing?

| Benefit | Description |
|---------|-------------|
| Catch edge cases | Inputs like 0, type(uint256).max, negative-like values (via casting), etc. |
| No need to manually list inputs | You let the framework do the heavy lifting |
| Reveal hidden assumptions | You might assume a value is always >0 unless tested randomly |
| Formal verification-lite | Fuzzing + assert() ~= lightweight property testing |

## Fuzz Testing in Foundry

In Foundry, fuzzing is built-in.

All you do is write test functions that accept parameters, and Foundry automatically starts fuzzing.

### Example: Basic Fuzz Test

```solidity
function testFuzz_Addition(uint256 a, uint256 b) public {
    uint256 result = a + b;
    assertEq(result - a, b);
}
```

Foundry will randomly generate values of a and b, and try to break your logic.

### Example: Preventing Invalid Inputs (using vm.assume)

```solidity
function testFuzz_Division(uint256 a, uint256 b) public {
    vm.assume(b != 0); // prevent division by zero

    uint256 result = a / b;
    assertEq(result * b <= a, true);
}
```

If you don't use assume, Foundry will try b == 0 and the test will revert (fail unexpectedly).

### Example: Bounding Fuzzed Inputs

```solidity
function testFuzz_Bounded(uint256 x) public {
    x = bound(x, 1, 100); // x is now always 1 to 100
    assertLe(x, 100);
}
```

Use bound() when your function only makes sense in a range, e.g., days, percentages, etc.

### Example: Fuzzing a Token Transfer

```solidity
function testFuzzTransfer(uint256 amount) public {
    amount = bound(amount, 1, 100 ether);
    vm.deal(address(this), amount);
    myToken.deposit{value: amount}();

    assertEq(myToken.balanceOf(address(this)), amount);
}
```

## Fuzzing vs. Unit Tests

| Unit Tests | Fuzz Tests |
|------------|------------|
| Test fixed inputs only | Test random inputs |
| Predictable | Random, but reproducible |
| Fast, minimal | Deeper, broad coverage |
| Can miss edge cases | Finds edge cases |

Use both! Unit tests = safety net; Fuzz tests = mine detector.

## Fuzzing Tips

### Use assume() to filter invalid inputs

```solidity
vm.assume(x > 100 && x < 1000);
```

Without this, fuzzing will waste time on irrelevant values.

### Use bound() to restrict input range

```solidity
x = bound(x, 1, 365);
```

Useful for percentages, days, and capped ranges.

### Avoid side effects in fuzzed tests

Don't rely on state from a previous fuzz run — use setUp() to reset or isolate.

### Use console.log() or emit log_uint(x) to debug

When fuzzing fails, inspect what inputs caused it.

### Run more fuzzing iterations (default is 256)

```bash
FOUNDRY_FUZZ_RUNS=1000 forge test
```

This lets Foundry try more combinations.

## Real-World Use Case: Auction Contract

Suppose you want to fuzz test that:

- Bids are only accepted if greater than current highest bid
- No underflows happen

```solidity
function testFuzzBidding(uint256 bid) public {
    vm.assume(bid > auction.highestBid());
    auction.placeBid{value: bid}();
    assertEq(auction.highestBid(), bid);
}
```

## Can Fuzzing Find Real Bugs?

Yes.

Fuzzing has revealed bugs in:

- Overflow handling (especially before Solidity 0.8)
- Broken math
- Invariant violations
- Incorrect access controls

It's even used alongside formal verification for security audits.

## Summary Table

| Concept | Syntax / Tool |
|---------|---------------|
| Fuzz function | `function testFuzz_Example(uint256 x) public {}` |
| Skip bad inputs | `vm.assume(condition)` |
| Restrict input | `x = bound(x, min, max)` |
| Run more tests | `FOUNDRY_FUZZ_RUNS=1000 forge test` |
| Debug value | `console.log(x)` or `emit log_uint(x)` |

## Final Thought

Fuzz testing turns your test suite from a checklist into a battlefield simulation.

It simulates user behavior you didn't think of, breaks your assumptions, and builds confidence in your contract.
# Testing Smart Contracts with Foundry

## Assertions

| Function                        | Description                       |
|----------------------------------|-----------------------------------|
| `assertTrue(x)`                 | Fails if x is false               |
| `assertEq(a, b)`                | Fails if a != b                   |
| `assertGt(a, b)`                | Fails if a <= b                   |
| `assertLt(a, b)`                | Fails if a >= b                   |
| `assertApproxEqAbs(a, b, tolerance)` | Asserts approximate equality |
| `fail()`                        | Forces a test to fail             |

## Cheat Codes (via forge-std/Test.sol)

These allow control over EVM state during tests.

| Cheat Code                      | Description                           |
|----------------------------------|---------------------------------------|
| `vm.warp(uint)`                  | Set block timestamp                   |
| `vm.roll(uint)`                  | Set block number                      |
| `vm.prank(address)`              | Next call is from given address       |
| `vm.startPrank(addr)` / `vm.stopPrank()` | Multiple calls from a spoofed address |
| `vm.expectRevert()`              | Expect a function to revert           |
| `vm.deal(address, amount)`       | Set ETH balance of address            |
| `vm.addr(uint)`                  | Generate address from private key     |
| `vm.label(addr, name)`           | Label address in test output          |
| `vm.expectEmit()`                | Expect an event emission              |

## Running Tests

**Run all tests:**
```bash
forge test
```

**Run a specific test file:**
```bash
forge test --match-path test/Counter.t.sol
```

**Run a specific function:**
```bash
forge test --match-test testIncrement
```

**Enable logs (e.g., console.log):**
```bash
forge test -vv
```

## Console Logging

Use Foundry's `console.log()` for debugging:

```solidity
import "forge-std/console.sol";

contract MyTest is Test {
    function testLog() public {
        console.log("Hello, Foundry!");
    }
}
```

## Mocks and Interfaces

You can mock external contracts by writing your own or using libraries like forge-std.

**Example mock interface:**
```solidity
interface IPriceFeed {
    function latestAnswer() external view returns (int256);
}
```

Or mock return values using `vm.mockCall(...)`.

## Fuzz Testing (Property-Based)

Foundry supports automated fuzzing (generating random inputs):

```solidity
function testFuzzAddition(uint256 x) public {
    uint256 y = x + 1;
    assertGt(y, x);
}
```

Use `forge test --fuzz-runs 1000` to increase fuzzing runs.

## Coverage Reporting

```bash
forge coverage
```
Displays function hit counts and identifies untested lines.

## Advanced Patterns

### 1. Setup with Different States

Use multiple `setUp()` or test setup helpers.

```solidity
function setUpWithBalance(uint256 amount) internal {
    vm.deal(address(this), amount);
}
```

### 2. Forked Testing (Mainnet/Testnet)

Foundry can test against live chains using RPC URLs.

Add RPC to `foundry.toml`:

```toml
[rpc_endpoints]
mainnet = "https://mainnet.infura.io/v3/YOUR_KEY"
```

In test:

```solidity
function setUp() public {
    vm.createSelectFork(vm.envString("MAINNET_RPC_URL"));
}
```
Now you can test using real on-chain data.

### 3. Snapshot and Revert

Use these to isolate state changes:

```solidity
uint256 snapshot = vm.snapshot();
// ... perform changes ...
vm.revertTo(snapshot);
```

## Tips for Students

- Group related tests into one `.t.sol` file.
- Forge only recognizes functions that start with `test` e.g `testFunctionName`.
- Use `setUp()` for repeated setup logic.
- Test for both expected behavior and edge cases.
- Use `vm.expectRevert()` to test reverts (e.g. underflows).
- Use fuzzing to cover a wide input range.
- Test deployed contract behavior by forking mainnet/testnet.

## Common Errors and Fixes

| Error                       | Cause                       | Fix                                 |
|-----------------------------|-----------------------------|-------------------------------------|
| Contract not found          | Wrong import path           | Use correct relative or remapped import |
| Failing assertion           | Logic bug                   | Debug with console.log              |
| No logs visible             | Log level too low           | Run `forge test -vv`                |
| Mismatch in Solidity versions | Conflicting versions      | Align pragma solidity in all files  |

## References

- [Foundry Book: Testing](https://book.getfoundry.sh/)
- [Forge Std Library](https://github.com/foundry-rs/forge-std)
- [Cheatcodes List](https://book.getfoundry.sh/cheatcodes/)
- [Foundry Template](https://github.com/foundry-rs/forge-template)


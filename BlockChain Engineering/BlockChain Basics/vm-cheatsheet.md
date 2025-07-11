# VM Cheatcode Tool in Foundry

The `vm` interface (short for virtual machine) is exposed in Foundry's test environment and is available via:

```solidity
import "forge-std/Test.sol";

contract MyTest is Test {
    function testSomething() public {
        // use vm. here
    }
}
```

Foundry injects the `vm` object into your test environment through the Test base contract from forge-std.

## VM Cheatcode Categories

### 1. State & Environment Manipulation

| Cheatcode | Description |
|-----------|-------------|
| `vm.warp(uint256)` | Set block.timestamp to a specific time |
| `vm.roll(uint256)` | Set block.number |
| `vm.fee(uint256)` | Set base fee |
| `vm.chainId(uint256)` | Set block.chainid |
| `vm.txGasPrice(uint256)` | Set tx.gasprice |

### 2. Caller and Origin Control

| Cheatcode | Description |
|-----------|-------------|
| `vm.prank(address)` | Sets msg.sender and tx.origin for next call only |
| `vm.startPrank(address)` | Starts persistent impersonation of msg.sender and tx.origin |
| `vm.stopPrank()` | Ends the prank started by startPrank |
| `vm.broadcast(address)` | Starts a broadcast session (used in scripting) |

### 3. ETH & Storage Control

| Cheatcode | Description |
|-----------|-------------|
| `vm.deal(address, uint256)` | Sets an account's ETH balance |
| `vm.store(address, bytes32 slot, bytes32 value)` | Write directly to storage slot |
| `vm.load(address, bytes32 slot)` | Read a raw storage slot |

### 4. Test Expectation & Assertion Tools

| Cheatcode | Description |
|-----------|-------------|
| `vm.expectRevert(bytes or string)` | Expect a revert to occur |
| `vm.expectEmit(...)` | Expect a specific event to be emitted |
| `vm.expectCall(address, data)` | Expect a call to a specific contract |
| `vm.expectCallMinGas(address, data, gas)` | Expect call with gas limit |
| `vm.mockCall(address, bytes, bytes)` | Mock a contract call and return custom data |

### 5. Cheat Failures

| Cheatcode | Description |
|-----------|-------------|
| `vm.revertTo(uint256 snapshotId)` | Reverts state to a snapshot |
| `vm.snapshot()` | Takes a snapshot of the current state |
| `vm.revertTo(uint256 id)` | Reverts to a previously taken snapshot |
| `vm.expectRevert()` | Asserts that the next call will revert |
| `vm.assume(bool)` | Fuzzing helper to constrain inputs |

### 6. File System and Artifacts

| Cheatcode | Description |
|-----------|-------------|
| `vm.readFile(string path)` | Read file contents as string |
| `vm.readFileBinary(string path)` | Read file as bytes |
| `vm.writeFile(string path, string data)` | Write data to file |
| `vm.serializeString(string key, string name, string value)` | Save key-value config for logs |
| `vm.serializeUint(...)` | Same, for numbers |
| `vm.getCode(string path)` | Get bytecode of contract at file path |
| `vm.ffi(string[])` | Run external commands (e.g., Git, Bash, Python) |

### 7. Fuzzing & Invariant Testing

| Cheatcode | Description |
|-----------|-------------|
| `vm.assume(bool)` | Sets a condition that must be true for fuzzed inputs |
| `vm.bound(uint256, min, max)` | Clamp a fuzzed value to a range |

### 8. Access Control / Permissions

| Cheatcode | Description |
|-----------|-------------|
| `vm.allowCheatcodes(address who)` | Allow a contract to access cheatcodes |
| `vm.label(address, string)` | Name a contract for nicer logs |
| `vm.setNonce(address, uint256)` | Manually set an address's nonce |

### 9. Scripting & Broadcasting (Used in forge script)

| Cheatcode | Description |
|-----------|-------------|
| `vm.startBroadcast()` | Begins signing and broadcasting transactions |
| `vm.stopBroadcast()` | Ends broadcast session |
| `vm.broadcast()` | Single transaction broadcast |

## Common Use Cases

### Simulate a user interaction

```solidity
address user = address(0xABCD);

vm.deal(user, 10 ether);
vm.startPrank(user);
contract.deposit{value: 1 ether}();
vm.stopPrank();
```

### Expect a revert with a specific error

```solidity
vm.expectRevert("Insufficient balance");
contract.withdraw(100 ether);
```

### Simulate time travel

```solidity
vm.warp(block.timestamp + 1 weeks);
```

### Mocking external calls

```solidity
vm.mockCall(
    address(oracle),
    abi.encodeWithSignature("getPrice()"),
    abi.encode(3000 * 1e18)
);
```

## Best Practices

- Use `vm.label(address, "name")` for debugging — makes Foundry logs readable
- Always isolate tests and use `vm.snapshot()` and `vm.revertTo()` in complex state setups
- Use `vm.assume()` to limit fuzz input domain
- Use `expectRevert()` before any revert-expected call to verify reverts

## Debug Tip

If you're testing a contract with ETH or external interactions and getting weird behavior, make sure you're using:

```solidity
vm.startPrank(user);
```

instead of directly calling from the test contract (`address(this)`), which is often the default caller in Foundry tests.

## Summary

| Area | Cheatcodes Examples |
|------|-------------------|
| Time/Block | `vm.warp`, `vm.roll`, `vm.chainId` |
| Balance/Caller | `vm.deal`, `vm.prank`, `vm.startPrank` |
| Reverts/Events | `vm.expectRevert`, `vm.expectEmit` |
| Storage Hacks | `vm.store`, `vm.load` |
| Fuzzing/Invariants | `vm.assume`, `vm.bound` |
| File System | `vm.readFile`, `vm.writeFile`, `vm.ffi` |
| Broadcasting | `vm.startBroadcast`, `vm.stopBroadcast` |
# Foundry Cheatcodes Reference

## Execution Context Manipulation

| Cheatcode | Description |
|-----------|-------------|
| `vm.prank(address)` | Sets msg.sender for the next call only. |
| `vm.prank(address, tx.origin)` | Sets both msg.sender and tx.origin for the next call. |
| `vm.startPrank(address)` | Sets msg.sender for all subsequent calls until vm.stopPrank(). |
| `vm.startPrank(address, tx.origin)` | Sets msg.sender and tx.origin until vm.stopPrank(). |
| `vm.stopPrank()` | Ends a startPrank session. |
| `hoax(address)` | Combines vm.deal() + vm.prank(). |
| `hoax(address, uint256)` | Funds address with ETH and pranks from it. |
| `startHoax(address)` | Persistent version of hoax. Ends with stopPrank. |
| `startHoax(address, uint256)` | Like startHoax but also funds the address. |

## State Manipulation

| Cheatcode | Description |
|-----------|-------------|
| `vm.deal(address, uint256)` | Set ETH balance of an address. |
| `vm.store(address, bytes32 key, bytes32 val)` | Directly store a value into a contract's storage slot. |
| `vm.load(address, bytes32 key)` | Read raw value from a contract's storage slot. |
| `vm.roll(uint256 blockNumber)` | Set the current block number. |
| `vm.warp(uint256 timestamp)` | Set the block timestamp (block.timestamp). |
| `vm.fee(uint256 basefee)` | Set the base fee of the block. |
| `vm.chainId(uint256 chainId)` | Set the chain ID. |
| `vm.coinbase(address)` | Set the block.coinbase address. |
| `vm.difficulty(uint256)` | Set the block difficulty. |
| `vm.origin(address)` | Set tx.origin. |

## Assertions & Expectations

| Cheatcode | Description |
|-----------|-------------|
| `vm.expectRevert()` | Expect a revert on the next call. |
| `vm.expectRevert(bytes)` | Expect a specific revert reason or custom error. |
| `vm.expectEmit()` | Set up an expectation for an event emission. |
| `vm.expectCall(address)` | Expect a low-level call to a specific address. |
| `vm.expectCall(address, bytes)` | Expect a specific payload in the call. |
| `vm.expectCall(address, uint256, bytes)` | Expect a call with specific ETH and calldata. |
| `vm.expectSafeMemory(uint64, uint64)` | Assert memory safety. |
| `vm.expectSafeMemory(uint64, uint64, uint64, uint64)` | Memory safety for read/write ranges. |

## Recording Logs & Calls

| Cheatcode | Description |
|-----------|-------------|
| `vm.recordLogs()` | Start recording logs (events). |
| `vm.getRecordedLogs()` | Return recorded logs (Vm.Log[]). |
| `vm.record()` | Start recording storage reads/writes. |
| `vm.accesses(address)` | Return read/write slots of a contract since vm.record(). |

## Environment Variables & File I/O

| Cheatcode | Description |
|-----------|-------------|
| `vm.envString(string)` | Read a string env var. |
| `vm.envBool(string)` | Read a bool env var. |
| `vm.envUint(string)` | Read a uint256 env var. |
| `vm.envInt(string)` | Read an int256 env var. |
| `vm.envAddress(string)` | Read an address env var. |
| `vm.envBytes32(string)` | Read a bytes32 env var. |
| `vm.envBytes(string)` | Read a bytes env var. |
| `vm.envStringArray(string)` | Read a string[] env var. |
| `vm.envUintArray(string)` | Read a uint256[] env var. |
| `vm.envAddressArray(string)` | Read an address[] env var. |
| `vm.readFile(string)` | Read a file as a string. |
| `vm.readLine(string)` | Read one line from a file. |
| `vm.writeFile(string, string)` | Write a string to a file. |
| `vm.writeLine(string, string)` | Append a line to a file. |
| `vm.removeFile(string)` | Delete a file. |
| `vm.readJson(string)` | Read raw JSON string from a file. |
| `vm.parseJson(string)` | Extract value from JSON. |

## Deployment & Calls

| Cheatcode | Description |
|-----------|-------------|
| `vm.ffi(string[])` | Call an external shell command. ⚠️ Use carefully. |
| `vm.broadcast()` | Broadcast transactions in scripts. |
| `vm.broadcast(address)` | Broadcast from specific address. |
| `vm.startBroadcast()` | Begin a broadcast session. |
| `vm.stopBroadcast()` | End a broadcast session. |

## Utilities & Misc

| Cheatcode | Description |
|-----------|-------------|
| `vm.getCode(string)` | Read bytecode from a compiled contract. |
| `vm.label(address, string)` | Label an address for test traces. |
| `vm.assume(bool)` | Constrain fuzz test inputs. |
| `vm.toString(type)` | Convert values to strings (various overloads). |
| `vm.serializeString(name, key, value)` | Serialize to a JSON-style object. |
| `vm.serializeUint(name, key, value)` | Same for uint. |
| `vm.serializeAddress(name, key, value)` | Same for address. |
| `vm.serializeBool(name, key, value)` | Same for bool. |
| `vm.serializeBytes(name, key, value)` | Same for bytes. |
| `vm.serializeBytes32(name, key, value)` | Same for bytes32. |
| `vm.serializeInt(name, key, value)` | Same for int. |
| `vm.serializeJson(name)` | Export a named serialization group. |
| `vm.setNonce(address, uint256)` | Set the nonce for an address. |
| `vm.getNonce(address)` | Get the nonce for an address. |
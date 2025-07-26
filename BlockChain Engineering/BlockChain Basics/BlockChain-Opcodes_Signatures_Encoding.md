# Advanced Ethereum: EVM, Opcodes, Call Data, Selectors, and ABI Encoding

This guide is aimed at students and intermediate blockchain developers who want to understand how smart contracts actually work under the hood.

## Table of Contents

- [What is the EVM?](#what-is-the-evm)
- [EVM Opcodes](#evm-opcodes)
- [Function Selectors & Signatures](#function-selectors--signatures)
- [ABI Encoding & Decoding](#abi-encoding--decoding)
- [CALL, DELEGATECALL, STATICCALL](#call-delegatecall-staticcall)
- [Storage Layout Basics](#storage-layout-basics)
- [Low-Level Example](#low-level-example)
- [Debugging Tips](#debugging-tips)
- [Summary Cheatsheet](#summary-cheatsheet)
- [EVM Stack Model](#evm-stack-model)
- [Learn More](#learn-more)

## What is the EVM?

The Ethereum Virtual Machine (EVM) is a stack-based virtual machine that executes smart contracts written in low-level opcodes.

Key facts:
- It has no floating point numbers
- It operates on 256-bit words
- Memory, stack, and storage are separate
- Smart contracts are compiled into bytecode and executed in the EVM

## EVM Opcodes

Opcodes are low-level instructions like assembly.

Examples:

| Opcode | Meaning |
|--------|---------|
| PUSH1 | Push 1 byte to stack |
| MSTORE | Store a word in memory |
| SLOAD | Load a word from storage |
| SSTORE | Store a word in storage |
| CALL | Make a contract call |
| RETURN | Return memory to caller |

**Full list:** https://ethereum.org/en/developers/docs/evm/opcodes/

## Function Signatures & Selectors

When you call a smart contract function, you're not calling it by name. You're sending a selector.

### Function Signature

```solidity
function transfer(address to, uint256 amount)
```

Its function signature is:
```
transfer(address,uint256)
```

### Function Selector

The first 4 bytes of keccak256("transfer(address,uint256)")

```solidity
bytes4 selector = bytes4(keccak256("transfer(address,uint256)"));
```

This selector is what's sent to the EVM as the first 4 bytes of calldata.

## ABI Encoding & Decoding

Ethereum uses the Application Binary Interface (ABI) to encode function calls.

**Example:**
```solidity
transfer(0xAbC..., 1000)
```

Gets encoded as:
```
0xa9059cbb                                     ← function selector
000000000000000000000000abcdef1234567890...   ← address (padded to 32 bytes)
00000000000000000000000000000000000000000000000000000000000003e8   ← 1000
```

You can encode this using JavaScript:

```javascript
web3.eth.abi.encodeFunctionCall({
  name: "transfer",
  type: "function",
  inputs: [
    { type: "address", name: "to" },
    { type: "uint256", name: "amount" }
  ]
}, ["0xAbC...", "1000"]);
```

## CALL, DELEGATECALL, STATICCALL

These opcodes are how contracts talk to each other.

| Opcode | Description |
|--------|-------------|
| CALL | Normal external call. New context, new storage. |
| DELEGATECALL | Uses caller's context. Storage stays the same. Used in proxies. |
| STATICCALL | Same as CALL but read-only. |

Example:
```solidity
(bool success, bytes memory data) = address(target).delegatecall(
  abi.encodeWithSignature("foo(uint256)", 123)
);
```

## Storage Layout Basics

- Variables are stored in 32-byte slots
- First slot = storage[0], second = storage[1], etc.
- Mappings and dynamic arrays are hashed

```solidity
mapping(address => uint256) public balances;
```

To find balances[0xabc...], compute:
```
keccak256(abi.encodePacked(key, slot))
```

## Low-Level Example

```solidity
function lowLevelTransfer(address to, uint256 amount) public {
    bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    
    (bool success, ) = address(tokenAddress).call(data);
    require(success, "Transfer failed");
}
```

You can even write inline assembly (Yul):

```solidity
assembly {
    let result := call(gas(), tokenAddress, 0, add(data, 32), mload(data), 0, 0)
    if iszero(result) {
        revert(0, 0)
    }
}
```

## Debugging Tips

- Use `cast calldata "transfer(address,uint256)" 0xabc... 1000` to generate calldata
- Use hardhat trace, foundry trace, or Tenderly to debug opcodes
- Use evm.codes to view opcode meanings

## Summary Cheatsheet

| Concept | Tool or Keyword |
|---------|----------------|
| View opcodes | https://evm.codes |
| Get selector | `bytes4(keccak256(...))` |
| Encode calldata | `abi.encodeWithSignature(...)` |
| Decode logs | Use ethers.js or web3.js |
| Make low-level call | `address.call(...)` |

## EVM Stack Model

- **Stack:** max 1024 items, LIFO
- **Memory:** temporary per-call
- **Storage:** persistent per-contract
- **Gas:** each opcode costs gas

## Learn More

- [Ethereum Yellow Paper (EVM Spec)](https://ethereum.github.io/yellowpaper/paper.pdf)
- [evm.codes](https://evm.codes)
- [Solidity Docs: ABI](https://docs.soliditylang.org/en/latest/abi-spec.html)
- [Foundry Cheatbook](https://github.com/foundry-rs/foundry)
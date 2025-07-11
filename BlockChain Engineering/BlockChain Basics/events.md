# Events in Solidity – Smart Contract Development Guide

Events in Solidity are a powerful way for smart contracts to communicate with external applications (like a front-end or backend). This guide is designed to help **students and developers** understand how events work, why they're useful, and how to use them correctly in your smart contracts.

---

## What Are Events?

**Events** in Solidity are like logs that are stored on the blockchain. When an event is emitted, it **stores data in the transaction logs** and can be **listened to by external services**, such as web apps using Web3.js, Ethers.js, or The Graph.

> Think of events as a way for your smart contract to "announce" something important that happened.

---

## Why Use Events?

Events are useful for:

- **Tracking changes** (e.g., transfers, updates)
- **Debugging** and transaction history
- **Communicating with front-end apps**
- **Storing lightweight logs** without using much gas

---

## How to Declare and Emit Events

### Declaring an Event

```solidity
event Transferred(address indexed from, address indexed to, uint amount);
```

- `event` is the keyword
- `Transferred` is the name
- `indexed` means we can filter by this value later (e.g., by from or to)

### Emitting an Event

```solidity
emit Transferred(msg.sender, receiver, amount);
```

You emit the event inside a function where something significant happens.

### Example: Token Transfer

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleToken {
    mapping(address => uint) public balances;

    event Transfer(address indexed from, address indexed to, uint amount);

    constructor() {
        balances[msg.sender] = 1000;
    }

    function transfer(address to, uint amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount); // Inform the outside world
    }
}
```

## Where Are Events Stored?

- Events are stored in the transaction logs
- They are not directly accessible by other smart contracts
- However, external apps can read them via JSON-RPC, Web3.js, Ethers.js, etc.

## Listening to Events (Web3 Example)

```javascript
contract.events.Transfer((error, event) => {
  if (!error) {
    console.log("Transfer happened:", event.returnValues);
  }
});
```

Or with Ethers.js:

```javascript
contract.on("Transfer", (from, to, amount) => {
  console.log(`Transfer: ${amount} tokens from ${from} to ${to}`);
});
```

## Indexed Parameters

Indexed parameters make events easier to search/filter by address.

```solidity
event Transfer(address indexed from, address indexed to, uint amount);
```

You can filter by `from` or `to` on the frontend without scanning every single event.

## Events Are Not Storage

**Important Note:**

- Events are not persistent storage
- Do not use events to store critical data your contract needs to rely on later
- They are read-only logs for external use only

## Best Practices

| Practice | Explanation |
|----------|-------------|
| Use indexed wisely | For searchable fields like addresses |
| Emit only when needed | Don't bloat the logs unnecessarily |
| Name events clearly | e.g., Transfer, Minted, Burned |
| Keep arguments minimal | Log what's necessary and no more |
| Don't rely on events as state | Events are not accessible within contracts |

## Gas Costs

Events are cheaper than storing data in contract storage but still cost some gas. They're a good way to log history without bloating state.

## Real-World Examples

### ERC-20 Example:

```solidity
event Transfer(address indexed from, address indexed to, uint value);
event Approval(address indexed owner, address indexed spender, uint value);
```

### Marketplace Example:

```solidity
event ItemListed(uint itemId, address indexed seller, uint price);
event ItemSold(uint itemId, address indexed buyer, uint price);
```

## Tools That Use Events

- **The Graph** – for building subgraphs
- **Ethers.js / Web3.js** – for front-end interaction
- **Hardhat / Foundry** – for testing and debugging

## Summary

| Topic | Description |
|-------|-------------|
| What are Events? | Blockchain logs emitted by contracts |
| Why Use Them? | External communication, logging, analytics |
| Syntax | `event Name(...);` and `emit Name(...);` |
| Limitations | Not for internal contract storage |
| Indexed Params | Help with filtering & search |
| Front-End Usage | Subscribing via JS libraries |

## Further Reading

- [Solidity Docs – Events](https://docs.soliditylang.org/en/v0.8.17/contracts.html#events)
- [Ethers.js – Listening to Events](https://docs.ethers.io/v5/api/contract/contract/#Contract--events)
- [The Graph](https://thegraph.com/docs/)
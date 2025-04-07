# Blockchain and Solidity Tutorial

## Introduction
Blockchain is a decentralized, distributed ledger technology that securely records transactions across a network of computers. 
- Solidity is a programming language used to write smart contracts on blockchain platforms like Ethereum.

## Sending ETH Through a Function & Reverts
In Solidity, you can create functions to send Ether (ETH) from one address to another. Reverts are used to handle errors and revert the state changes if a condition is not met.
```solidity
pragma solidity ^0.8.0;

contract SendETH {
    function sendEth(address payable _recipient) public payable {
        require(msg.value > 0, "Must send ETH value greater than 0");
        _recipient.transfer(msg.value);
    }
}
```
[More on Reverts](https://docs.soliditylang.org/en/v0.8.0/control-structures.html#error-handling-assert-require-revert-and-exceptions)


### Fields in a Transaction
A transaction in Ethereum contains various fields such as sender, receiver, gas limit, gas price, nonce, and data.

### More on v,r,s
In Ethereum transactions, v, r, and s are components of the transaction signature. They are used to `verify the authenticity of the transaction`.

### payable
The payable modifier in Solidity allows a function to receive Ether along with a transaction.

### msg.value & Other Global Keywords
msg.value is a global variable in Solidity that contains the amount of Ether sent along with the transaction. Other global variables include `msg.sender`, `msg.data`, and `msg.sig`.

### require
The require statement in Solidity is used to validate conditions. If the condition evaluates to false, the transaction is reverted.

### revert
The revert statement in Solidity is used to revert the state changes and throw an exception with a custom error message.

# Chainlink & Oracles
What is a blockchain oracle?
- A blockchain oracle is a `bridge` between `blockchain smart contracts` and `external data sources`. It provides smart contracts with access to off-chain data.
[What is a blockchain oracle?](https://www.coindesk.com/learn/blockchain-101/what-is-blockchain-oracle)  

# Chainlink Features and Uses

| Feature                           | Description                                                                                                                         | Use                                                                                                                              |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Decentralized Oracle Network     | Chainlink provides a decentralized oracle network that connects smart contracts with real-world data and external APIs.           | Enables smart contracts to securely access off-chain data and interact with external systems.                                    |
| Data Feeds                        | Chainlink Price Feeds provide decentralized price data for various assets, ensuring reliability and tamper-resistance.              | Price feeds are used in decentralized finance (DeFi), gaming, insurance, and other applications requiring accurate asset prices. |
| Verifiable Random Function (VRF) | Chainlink VRF generates secure random numbers on the blockchain, ensuring fairness and security in various applications.          | Used in gaming, gambling, and other applications requiring random number generation.                                             |
| Keepers                           | Chainlink Keepers automate smart contract maintenance tasks, such as calling functions at predefined intervals or based on conditions. | Ensures the continuous operation of decentralized applications (DApps) by automating key processes.                            |
| API Calls                         | Chainlink allows smart contracts to make API calls to external endpoints, enabling access to off-chain data and services.           | Integrates external data sources, services, and information into smart contracts.                                                |
| External Adapters                 | Chainlink External Adapters extend the functionality of Chainlink nodes by allowing them to interact with external systems.         | Enhances the capabilities of Chainlink nodes to handle custom data sources and complex computations.                             |
| Off-chain Reporting               | Chainlink's off-chain reporting enables the aggregation of data from multiple oracles to ensure accuracy and reliability.          | Improves the reliability of oracle responses by aggregating data from multiple sources.                                           |
| Cross-chain Compatibility        | Chainlink supports cross-chain compatibility, allowing it to provide oracle services on various blockchain platforms.              | Extends the reach of Chainlink's oracle services to multiple blockchain ecosystems.                                             |

### What is the oracle problem?
The oracle problem refers to the challenge of ensuring the `accuracy and reliability` of data obtained from external sources by blockchain smart contracts.
[What is the oracle problem?](https://academy.binance.com/en/glossary/oracle)

### Chainlink
Chainlink is a decentralized oracle network that provides secure and reliable data feeds to smart contracts.
[Chainlink - Official Website](https://chain.link/) 

### Chainlink Price Feeds (Data Feeds)
Chainlink Price Feeds provide decentralized price data for various assets. They can be integrated into smart contracts to fetch real-time price information.
[Chainlink Price Feeds Documentation](https://docs.chain.link/docs/get-the-latest-price)  

### Chainlink VRF
Chainlink Verifiable Random Function (VRF) generates secure random numbers on the blockchain. It ensures fairness and security in decentralized applications such as gaming and gambling.
[Chainlink VRF Documentation](https://docs.chain.link/docs/chainlink-vrf)  

### Chainlink Keepers
Chainlink Keepers are decentralized service providers that automate smart contract maintenance tasks, such as calling functions at predefined intervals.
[Chainlink Keepers Documentation](https://docs.chain.link/docs/chainlink-keepers)  

### Chainlink API Calls
Chainlink allows smart contracts to make API calls to external endpoints, enabling access to off-chain data and services.
[Chainlink API Calls Documentation](https://docs.chain.link/docs/make-a-http-get-request)

### Importing Tokens into your Metamask
You can import tokens into the Metamask wallet by adding custom token addresses.

### Request and Receive Chainlink Model
The Request and Receive Chainlink model involves sending a request to a Chainlink oracle and receiving a response with the requested data.
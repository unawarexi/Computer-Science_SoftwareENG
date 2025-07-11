# Blockchain Subscriptions Guide

## 1. What Are Blockchain Subscriptions?

Subscriptions refer to the ability for a user or contract to register for ongoing services or receive periodic updates/payments. This can include:

- Recurring payments (e.g., pay X ETH every month)
- Data feeds (e.g., price updates)
- Service access (e.g., keep receiving oracle responses or AI compute)
- Event listening (e.g., off-chain apps "subscribing" to events)

## 2. Types of Subscriptions in Ethereum

### a. Smart Contract-Based Subscriptions

Users approve a smart contract to automatically deduct funds at intervals.

Techniques:
- ERC-20 approve + transferFrom
- Time-based conditions (block.timestamp)
- Role-based access (e.g., only owner can cancel)

### b. Event-Based Subscriptions

Off-chain systems use web3.js, ethers.js, or tools like The Graph to listen for event emissions in real time.

```solidity
event Subscribed(address indexed user, uint256 planId);
```

Off-chain app:

```javascript
contract.on("Subscribed", (user, planId) => {
    console.log(`New subscriber: ${user}`);
});
```

### c. Data Feed Subscriptions

Users or contracts access data feeds (e.g., Chainlink price oracles). The subscription is typically off-chain for access control, but the consumption is on-chain.

## 3. Chainlink Subscriptions (Key Part!)

Chainlink introduced SubscriptionManager for managing paid access to oracle services. This is used with:

### a. Chainlink VRF (Verifiable Random Function)

For provably fair randomness (lotteries, games). Requires a subscription for LINK token usage.

Workflow:
1. Create a subscription (on Chainlink UI or via contract)
2. Fund it with LINK
3. Add your consumer contract to the subscription
4. Request randomness → LINK is deducted from subscription

```solidity
VRFCoordinatorV2Interface coordinator = ...;
uint64 subId = coordinator.createSubscription();
coordinator.addConsumer(subId, address(myContract));
```

### b. Chainlink Automation (Keepers)

To automate function calls (e.g., trigger a lottery draw every day).

You register your contract and pay via LINK subscription or Upkeep balance.

### c. Chainlink Functions

Used for off-chain computation and web API calls.

- You subscribe and fund with LINK
- Chainlink Nodes fulfill your off-chain request
- Usage fees are deducted from the subscription

## 4. How to Build Subscription Logic in Solidity

Basic pattern:

```solidity
contract SubscriptionService {
    mapping(address => uint256) public expiry;

    function subscribe(uint256 months) external payable {
        require(msg.value == months * 0.01 ether, "Invalid payment");
        expiry[msg.sender] = block.timestamp + (30 days * months);
    }

    function isActive(address user) public view returns (bool) {
        return block.timestamp <= expiry[user];
    }
}
```

## 5. Off-Chain Subscription Management Tools

You can enhance subscriptions with:

- **The Graph**: Indexing events for dashboards
- **Webhooks + Chainlink Automation**: Automatic renewals
- **Node.js scripts**: To monitor expiry and notify users
- **IPFS or NFTs**: To represent subscription tokens

## 6. EIPs and Standards Related to Subscriptions

- **ERC-1337**: Proposed standard for subscription payments
- **ERC-721 + ERC-1155**: Can be extended for membership NFTs
- **ERC-4626**: Vaults for yield-based recurring payouts

## 7. Real Use Cases

| Use Case | How Subscriptions Work |
|----------|------------------------|
| Decentralized Netflix | Pay 0.01 ETH monthly to keep access |
| Chainlink VRF | Use LINK to keep randomness flowing |
| NFT Memberships | Expire after 30/90 days unless renewed |
| AI dApps (Chainlink Functions) | Pay to keep access to off-chain computation |

## 8. Best Practices

- Use block.timestamp + require to manage expiration
- Avoid gas-heavy renewals — favor manual or Automation
- Fund Chainlink subscriptions off-chain for easier management
- Emit Subscribed, Renewed, Cancelled events for tracking
- Add pausing/emergency withdrawal features
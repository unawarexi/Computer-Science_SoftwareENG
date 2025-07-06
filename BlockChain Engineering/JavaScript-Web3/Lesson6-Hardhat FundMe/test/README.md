# Hardhat Testing Concepts

This guide provides a brief overview of key testing concepts: **Unit Testing**, **Staging Test**, **Hardhat Deploy Fixtures**, **ethers.getContract**, **expect**, **ethers.utils.parseUnits**, and **Waffle Chai Matchers**.

---

## 1. Unit Testing

### What is Unit Testing?
**Unit testing** is the process of testing individual components of your smart contract (such as functions) to ensure they work as expected in isolation.

### Example:
```js
const { expect } = require("chai");

describe("MyContract", function () {
  it("should return the correct value", async function () {
    const MyContract = await ethers.getContractFactory("MyContract");
    const myContract = await MyContract.deploy();

    expect(await myContract.getValue()).to.equal(42);
  });
});
```


## 2. Staging Test

### What is a Staging Test?
Staging tests are used to test the smart contract in an environment that mimics the live environment (like testnets). These tests ensure everything works end-to-end before deploying to the main network.

Example:
- Deploy contracts on a testnet (e.g., `Rinkeby or Goerli`) and run staging tests to simulate a real-world deployment.


## 3. Hardhat Deploy Fixtures

### What are Fixtures?
Fixtures in Hardhat allow you to set up a deployment snapshot and reuse it across tests. This avoids re-deploying contracts for every test, saving time.

```js
describe("MyContract", function () {
  beforeEach(async function () {
    await deployments.fixture(["MyContract"]); // Load the fixture
  });
```



## 4. ethers.getContract

### What is ethers.getContract?
ethers.getContract is a Hardhat function that retrieves a deployed contract instance by name, allowing interaction with it in tests.

Example:
```js
const myContract = await ethers.getContract("MyContract");
// This returns the deployed instance of MyContract.
```


## 5. expect
### What is expect?
expect is an assertion function from the `Chai library`, used to verify that values in your tests are correct.

Example:
```js
expect(await myContract.getValue()).to.equal(100);
```


## 6. ethers.utils.parseUnits
### What is ethers.utils.parseUnits?
ethers.utils.parseUnits is used to convert a string representation of a token amount into a BigNumber using the token’s decimals.

Example:
```js
const amount = ethers.utils.parseUnits("100", 18);
// This converts 100 tokens (with 18 decimals) into the corresponding BigNumber format.
```


## 7. Waffle Chai Matchers
### What are Waffle Chai Matchers?
Waffle provides additional matchers for Chai that are specific to smart contract testing, making it easier to write assertions for blockchain-related data.

- ## Common Matchers:
- **expect(contract).to.emit(event)**: Check if an event was emitted.
- **expect(contract).to.be.reverted:** Check if a transaction was reverted.
- **expect(contract).to.be.revertedWith(message)**: Check if a transaction was reverted with a specific message.
Example:
```js
await expect(myContract.connect(user).transfer(otherUser, 100))
  .to.emit(myContract, "Transfer")
  .withArgs(user.address, otherUser.address, 100);
// This checks if the Transfer event was emitted with the correct arguments.
```


## Conclusion
- `**Unit Testing**` ensures that individual contract functions work correctly.
- `**Staging Tests**` simulate a real-world deployment on testnets.
- `**Hardhat Deploy Fixtures**` save deployment states and reuse them across tests.
- `**ethers.getContract**` retrieves deployed contract instances.
- `**expect**` is used to assert expected outcomes in tests.
- `**ethers.utils.parseUnits**` converts token amounts into BigNumber format.
- `**Waffle Chai Matchers**` simplify writing blockchain-specific test assertions.
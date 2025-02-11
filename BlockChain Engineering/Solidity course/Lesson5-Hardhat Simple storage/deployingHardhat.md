## Deploying SimpleStorage
- 1. **Create the SimpleStorage contract:** Create a `SimpleStorage.sol` file inside the contracts folder:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public storedData;

    function set(uint256 x) public {
        storedData = x;
    }

    function get() public view returns (uint256) {
        return storedData;
    }
}
```

- 2. **Compile the contract:** Run the following command to compile the contract:

```bash
npx hardhat compile
```

- 3. **Deploy the contract:** In the `scripts/deploy.js` file, write the deployment script:

```javascript
async function main() {
    const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
    const simpleStorage = await SimpleStorage.deploy();
    await simpleStorage.deployed();
    console.log("SimpleStorage deployed to:", simpleStorage.address);
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});
```

- 4.  **Run the deployment script:**

```bash
npx hardhat run scripts/deploy.js --network <network_name>
```

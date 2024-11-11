const hre = require("hardhat");


async function main() {
    // Get the contract factory for SimpleStorage
    const SimpleStorageFactory = await hre.ethers.getContractFactory("SimpleStorage");
    console.log("Deploying contract...");

    // Deploy the contract
    const SimpleStorage = await SimpleStorageFactory.deploy();
    await SimpleStorage.deployed()

    // Log the contract address
    console.log("Contract deployed to:", SimpleStorage.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

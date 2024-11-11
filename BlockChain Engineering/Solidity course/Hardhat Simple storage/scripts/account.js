async function main() {
    const [owner, ...accounts] = await ethers.getSigners();
    console.log("Deployer address:", owner.address);
    console.log("Other accounts:");
    accounts.forEach((account, index) => {
      console.log(`${index + 1}: ${account.address}`);
    });
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  
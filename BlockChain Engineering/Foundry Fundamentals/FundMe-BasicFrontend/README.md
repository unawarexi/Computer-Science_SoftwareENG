# FundMe Basic Frontend

#### Overview

The FundMe-BasicFrontend allows users to connect their wallet, fund the contract, and withdraw funds. It is a simple educational project to help you understand how to build a frontend that communicates with Ethereum smart contracts.

![App Screenshot 1](./assets/Screenshot%202025-06-25%20at%2018.28.10.png)
![App Screenshot 2](./assets/Screenshot%202025-06-25%20at%2018.29.41.png)

## Features

- Connect to MetaMask or other Ethereum wallets
- Fund the smart contract with ETH
- Withdraw funds from the contract (if you are the owner)
- View contract balance

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/unawarexi/FundMe-BasicFrontend.git
   cd FundMe-BasicFrontend
   ```

2. **Start your local blockchain (Anvil):**
   - Make sure you have [Foundry](https://book.getfoundry.sh/) installed.
   - In a new terminal, run:
     ```bash
     anvil
     ```
   - This will start a local Ethereum node at `http://127.0.0.1:8545`.

3. **Open the frontend:**
   - Open the `index.html` file in the root of this project.
   - The easiest way is to use the [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) extension in VS Code:
     - Right-click on `index.html` and select **"Open with Live Server"**.
     - Or, you can simply open `index.html` directly in your browser (double-click the file).

4. **Connect your wallet:**
   - Make sure MetaMask or another Ethereum wallet extension is installed in your browser.
   - Connect MetaMask to the local Anvil network (usually `http://127.0.0.1:8545`).
   - Import one of the Anvil test accounts using its private key (displayed in the terminal when you start Anvil).

5. **Interact with the contract:**
   - Use the frontend to fund or withdraw from the contract.
   - All transactions will be live on your local Anvil blockchain.

## Prerequisites

- Node.js and npm installed
- MetaMask or another Ethereum wallet extension

## Useful Links

- [Foundry Documentation](https://book.getfoundry.sh/)
- [MetaMask](https://metamask.io/)

---

Happy learning! If you have any questions, feel free to open an issue or submit a pull request.


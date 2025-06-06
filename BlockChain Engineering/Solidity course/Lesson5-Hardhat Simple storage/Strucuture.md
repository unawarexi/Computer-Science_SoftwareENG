# Hardhat Project Folder Structure and Naming Conventions

This guide provides a typical folder structure and naming conventions for a Hardhat-based blockchain development project.

## Project Structure

my-hardhat-project/ │ 
├── contracts/ │ ├── Token.sol │ ├── MyNFT.sol │ └── <ContractName>.sol │ 
├── scripts/ │ ├── deploy.js │ └── <script-name>.js │ 
├── test/ │ ├── Token.test.js │ ├── MyNFT.test.js │ └── <ContractName>.test.js │
├── artifacts/ │ └── ... (Auto-generated by Hardhat) │
 ├── cache/ │ └── ... (Auto-generated by Hardhat) │
  ├── node_modules/ │ └── ... (Auto-generated by npm or yarn) │
   ├── hardhat.config.js
    ├── package.json
     ├── .env 
     └── README.md



## Folder and File Descriptions

### 1. **`contracts/`**:
   This folder contains all Solidity smart contracts.
   
   **Naming Convention:**  
   - Files should follow the `PascalCase` naming convention.
   - The file name should match the contract name for clarity.
   
   **Files:**
   - `Token.sol`: A contract for an ERC20 token or custom token.
   - `MyNFT.sol`: A contract for creating NFTs using ERC721 or ERC1155 standards.
   - `<ContractName>.sol`: Custom smart contracts.

### 2. **`scripts/`**:
   This folder contains JavaScript/TypeScript files that automate contract deployment, interaction, and other actions.
   
   **Naming Convention:**  
   - Files should be named using `kebab-case` or `camelCase`.
   - Each file should reflect its purpose (e.g., `deploy.js` for deployment).
   
   **Files:**
   - `deploy.js`: Script to deploy smart contracts to the blockchain.
   - `<script-name>.js`: Additional utility scripts for interacting with contracts, migrating data, etc.

### 3. **`test/`**:
   Contains JavaScript or TypeScript test files for smart contracts.
   
   **Naming Convention:**  
   - Test files follow the `PascalCase.test.js` or `PascalCase.test.ts` convention, matching the name of the contract being tested.
   
   **Files:**
   - `Token.test.js`: Test file for the `Token.sol` contract.
   - `MyNFT.test.js`: Test file for the `MyNFT.sol` contract.
   - `<ContractName>.test.js`: Test file for a custom contract.

### 4. **`artifacts/`**:
   Auto-generated folder by Hardhat containing compiled smart contracts and ABIs (Application Binary Interface).
   
   **Naming Convention:**
   - Automatically generated by Hardhat.
   
   **Files:**
   - ABI and contract bytecode files created during the compilation phase.

### 5. **`cache/`**:
   Auto-generated folder by Hardhat to store temporary build information and cache.
   
   **Naming Convention:**
   - Automatically generated by Hardhat.
   
   **Files:**
   - Internal Hardhat cache data that accelerates the build process.

### 6. **`node_modules/`**:
   Contains all installed dependencies and packages required for the project.
   
   **Files:**
   - Dependencies listed in `package.json` are installed here.

### 7. **`hardhat.config.js`**:
   The main configuration file for Hardhat. This file contains network settings, Solidity compiler versions, plugins, and other project-specific configurations.

   **Naming Convention:**
   - Named as `hardhat.config.js` by default.
   
   **Typical Configurations:**
   - Network configuration (local, testnets, mainnets).
   - Solidity version.
   - Hardhat plugins (e.g., `@nomiclabs/hardhat-ethers`, `hardhat-waffle`).

### 8. **`package.json`**:
   Standard file for managing project dependencies, scripts, and project metadata. This file is essential for defining project dependencies like Hardhat, ethers.js, and testing libraries (Mocha, Chai).

   **Key Fields:**
   - `"dependencies"`: Lists the project's third-party libraries.
   - `"scripts"`: Defines useful scripts for automating tests, contract compilation, etc.

### 9. **`.env`**:
   A hidden file that contains environment variables such as API keys, private keys, and network settings. Ensure this file is added to `.gitignore` to prevent sensitive information from being publicly accessible.

   **Naming Convention:**
   - Use uppercase letters and underscores for environment variables (e.g., `PRIVATE_KEY`, `INFURA_API_KEY`).

### 10. **`README.md`**:
   A markdown file that provides an overview of the project, instructions for setting up the project locally, deploying contracts, running tests, and other essential information.

   **Typical Sections:**
   - Project description.
   - Installation instructions.
   - Usage guides.
   - Deployment and testing instructions.

---

## Suggested Naming Conventions:

- **Contracts**: `PascalCase.sol` (e.g., `MyToken.sol`).
- **Test files**: `PascalCase.test.js` (e.g., `MyToken.test.js`).
- **Scripts**: `kebab-case.js` or `camelCase.js` (e.g., `deploy-contract.js`).
- **Environment Variables**: `UPPERCASE_WITH_UNDERSCORES` (e.g., `PRIVATE_KEY`).

---

## Example Commands:

- Compile smart contracts:
```bash
  npx hardhat compile
```

- Deploy contracts using the deploy script:

```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

- Run tests:

```bash
npx hardhat test
```
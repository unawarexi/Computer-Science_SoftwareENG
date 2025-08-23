-include .env

.PHONY: deploy-all

# Deploy Token Contracts
deploy-token-sepolia:
	forge script script/DeployToken.s.sol:DeployToken \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

deploy-token-arbitrum:
	forge script script/DeployToken.s.sol:DeployToken \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Deploy Pools
deploy-pool-sepolia:
	forge script script/DeployBurnMintTokenPool.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

deploy-pool-arbitrum:
	forge script script/DeployBurnMintTokenPool.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Claim Admin
claim-admin-sepolia:
	forge script script/ClaimAdmin.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

claim-admin-arbitrum:
	forge script script/ClaimAdmin.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Accept Admin Role
accept-admin-sepolia:
	forge script script/AcceptAdminRole.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

accept-admin-arbitrum:
	forge script script/AcceptAdminRole.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Set Pool
set-pool-sepolia:
	forge script script/SetPool.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

set-pool-arbitrum:
	forge script script/SetPool.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Apply Chain Updates
apply-updates-sepolia:
	forge script script/ApplyChainUpdates.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

apply-updates-arbitrum:
	forge script script/ApplyChainUpdates.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ARBITRUM_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Mint Tokens
mint-sepolia:
	forge script script/MintTokens.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

# Transfer Tokens
transfer-sepolia:
	forge script script/TransferTokens.s.sol \
		--broadcast \
		--verify \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account cct-keystore \
		--sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

deploy-all: deploy-token-sepolia deploy-token-arbitrum deploy-pool-sepolia deploy-pool-arbitrum claim-admin-sepolia claim-admin-arbitrum accept-admin-sepolia accept-admin-arbitrum set-pool-sepolia set-pool-arbitrum apply-updates-sepolia apply-updates-arbitrum mint-sepolia transfer-sepolia

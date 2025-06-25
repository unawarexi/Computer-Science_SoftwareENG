# Variables
SEPOLIA_ENV    = .env.sepolia
MAINNET_ENV    = .env.mainnet
SEPOLIA_RPC    = $(shell cat $(SEPOLIA_ENV) | grep RPC_URL | cut -d '=' -f2)
SEPOLIA_KEY    = $(shell cat $(SEPOLIA_ENV) | grep PRIVATE_KEY | cut -d '=' -f2)
MAINNET_RPC    = $(shell cat $(MAINNET_ENV) | grep RPC_URL | cut -d '=' -f2)
MAINNET_KEY    = $(shell cat $(MAINNET_ENV) | grep PRIVATE_KEY | cut -d '=' -f2)

-include .env

# Default target
.DEFAULT_GOAL := build

# Phony targets
.PHONY: all build test clean deploy install gas snapshot lint format anvil fork-mainnet fork-test

# Build contracts
build:
	@forge build

# Run tests (local)
test:
	@forge test -vv

zktest :; foundryup-zksync && forge test --zksync && foundryup

# Run tests with forked mainnet
fork-test:
	@forge test --fork-url $(MAINNET_RPC) -vv --gas-report

# Clean build artifacts
clean:
	@forge clean

# Deploy contract
# for zksync, use `forge script script/$(CONTRACT).s.sol --zksync` flag
deploy:
	@forge script script/$(CONTRACT).s.sol \
		--rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) \
		--broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC) --private-key $(SEPOLIA_KEY) \
		--broadcast --verify

deploy-mainnet:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(MAINNET_RPC) --private-key $(MAINNET_KEY) \
		--broadcast --verify

deploy-local:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) \
		--broadcast

# Install dependencies
install:
	@forge install

# Gas report
gas:
	@forge test --gas-report

# Take a gas snapshot
snapshot:
	@forge snapshot

# Lint contracts (solhint required)
lint:
	@solhint 'src/**/*.sol'

# Format contracts (prettier-plugin-solidity required)
format:
	@npx prettier --write 'src/**/*.sol'

# Run local anvil node
anvil:
	@anvil --port 8545

# Run all main tasks
all: build test snapshot

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"


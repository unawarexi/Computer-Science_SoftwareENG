// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {RebaseTokenPool} from "../src/RebaseTokenPool.sol";
import {RebaseToken} from "../src/RebaseToken.sol";
import {IRebaseToken} from "../src/interfaces/IRebaseToken.sol";
import {Vault} from "../src/Vault.sol";
import {Pool} from "@ccip/contracts/src/v0.8/ccip/libraries/Pool.sol";
import {IERC20} from "@ccip/contracts/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {CCIPLocalSimulatorFork, Register} from "@chainlink/local/src/ccip/CCIPLocalSimulatorFork.sol";

/**
 * @title CrossChainTest
 * @notice Fork tests for cross-chain functionality using Chainlink CCIP
 * @dev Tests the actual cross-chain transfer of RebaseToken between Ethereum Sepolia and Arbitrum Sepolia
 */
contract CrossChainTest is Test {
    // Fork and simulation setup
    CCIPLocalSimulatorFork public ccipLocalSimulatorFork;
    uint256 public ethSepoliaFork;
    uint256 public arbSepoliaFork;
    
    // Chainlink CCIP chain selectors
    uint64 public constant ETH_SEPOLIA_CHAIN_SELECTOR = 16015286601757825753;
    uint64 public constant ARB_SEPOLIA_CHAIN_SELECTOR = 3478487238524512106;
    
    // Test contracts on both chains
    RebaseToken public ethRebaseToken;
    RebaseToken public arbRebaseToken;
    RebaseTokenPool public ethTokenPool;
    RebaseTokenPool public arbTokenPool;
    Vault public ethVault;
    Vault public arbVault;
    
    // Test addresses
    address public owner = makeAddr("owner");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public bridgeUser = makeAddr("bridgeUser");
    
    // Test constants
    uint256 public constant INITIAL_ETH_AMOUNT = 10 ether;
    uint256 public constant DEPOSIT_AMOUNT = 1 ether;
    uint256 public constant TRANSFER_AMOUNT = 0.5 ether;
    uint256 public constant CUSTOM_INTEREST_RATE = 3e25; // 3% annual rate
    
    // CCIP components
    Register.NetworkDetails ethNetworkDetails;
    Register.NetworkDetails arbNetworkDetails;

    function setUp() public {
        // Create forks
        ethSepoliaFork = vm.createSelectFork(vm.rpcUrl("sepolia-eth"));
        arbSepoliaFork = vm.createFork(vm.rpcUrl("arb-sepolia"));
        
        // Initialize CCIP Local Simulator Fork
        ccipLocalSimulatorFork = new CCIPLocalSimulatorFork();
        vm.makePersistent(address(ccipLocalSimulatorFork));
        
        // Get network details
        ethNetworkDetails = ccipLocalSimulatorFork.getNetworkDetails(block.chainid);
        
        // Setup on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        _setupEthereumSepolia();
        
        // Setup on Arbitrum Sepolia
        vm.selectFork(arbSepoliaFork);
        _setupArbitrumSepolia();
        
        // Fund test accounts
        _fundTestAccounts();
    }

    function _setupEthereumSepolia() internal {
        vm.startPrank(owner);
        
        // Deploy RebaseToken
        ethRebaseToken = new RebaseToken();
        
        // Deploy Vault
        ethVault = new Vault(IRebaseToken(address(ethRebaseToken)));
        
        // Grant mint and burn role to vault
        ethRebaseToken.grantMintAndBurnRole(address(ethVault));
        
        // Get network details for Ethereum Sepolia
        ethNetworkDetails = ccipLocalSimulatorFork.getNetworkDetails(block.chainid);
        
        // Setup allowlist for the pool
        address[] memory allowlist = new address[](2);
        allowlist[0] = ethNetworkDetails.routerAddress; // Router acts as onRamp/offRamp
        allowlist[1] = owner; // Owner for testing
        
        // Deploy Token Pool
        ethTokenPool = new RebaseTokenPool(
            IERC20(address(ethRebaseToken)),
            allowlist,
            ethNetworkDetails.rmnProxyAddress,
            ethNetworkDetails.routerAddress
        );
        
        // Grant mint and burn role to pool
        ethRebaseToken.grantMintAndBurnRole(address(ethTokenPool));
        
        vm.stopPrank();
    }

    function _setupArbitrumSepolia() internal {
        vm.startPrank(owner);
        
        // Get network details for Arbitrum Sepolia
        arbNetworkDetails = ccipLocalSimulatorFork.getNetworkDetails(block.chainid);
        
        // Deploy RebaseToken
        arbRebaseToken = new RebaseToken();
        
        // Deploy Vault
        arbVault = new Vault(IRebaseToken(address(arbRebaseToken)));
        
        // Grant mint and burn role to vault
        arbRebaseToken.grantMintAndBurnRole(address(arbVault));
        
        // Setup allowlist for the pool
        address[] memory allowlist = new address[](2);
        allowlist[0] = arbNetworkDetails.routerAddress; // Router acts as onRamp/offRamp
        allowlist[1] = owner; // Owner for testing
        
        // Deploy Token Pool
        arbTokenPool = new RebaseTokenPool(
            IERC20(address(arbRebaseToken)),
            allowlist,
            arbNetworkDetails.rmnProxyAddress,
            arbNetworkDetails.routerAddress
        );
        
        // Grant mint and burn role to pool
        arbRebaseToken.grantMintAndBurnRole(address(arbTokenPool));
        
        vm.stopPrank();
    }

    function _fundTestAccounts() internal {
        // Fund accounts on both chains
        vm.selectFork(ethSepoliaFork);
        vm.deal(user1, INITIAL_ETH_AMOUNT);
        vm.deal(user2, INITIAL_ETH_AMOUNT);
        vm.deal(bridgeUser, INITIAL_ETH_AMOUNT);
        
        vm.selectFork(arbSepoliaFork);
        vm.deal(user1, INITIAL_ETH_AMOUNT);
        vm.deal(user2, INITIAL_ETH_AMOUNT);
        vm.deal(bridgeUser, INITIAL_ETH_AMOUNT);
    }

    /*//////////////////////////////////////////////////////////////
                        FORK ENVIRONMENT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_forkSetup() public {
        // Test Ethereum Sepolia setup
        vm.selectFork(ethSepoliaFork);
        assertEq(block.chainid, 11155111); // Ethereum Sepolia chain ID
        assertTrue(address(ethRebaseToken) != address(0));
        assertTrue(address(ethVault) != address(0));
        assertTrue(address(ethTokenPool) != address(0));
        
        // Test Arbitrum Sepolia setup
        vm.selectFork(arbSepoliaFork);
        assertEq(block.chainid, 421614); // Arbitrum Sepolia chain ID
        assertTrue(address(arbRebaseToken) != address(0));
        assertTrue(address(arbVault) != address(0));
        assertTrue(address(arbTokenPool) != address(0));
    }

    function test_depositAndRedeemOnBothChains() public {
        // Test deposit and redeem on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        _testVaultOperations(ethVault, ethRebaseToken, user1);
        
        // Test deposit and redeem on Arbitrum Sepolia
        vm.selectFork(arbSepoliaFork);
        _testVaultOperations(arbVault, arbRebaseToken, user2);
    }

    function _testVaultOperations(Vault vault, RebaseToken token, address user) internal {
        uint256 initialBalance = user.balance;
        
        // Deposit
        vm.prank(user);
        vault.deposit{value: DEPOSIT_AMOUNT}();
        
        assertEq(token.balanceOf(user), DEPOSIT_AMOUNT);
        assertEq(user.balance, initialBalance - DEPOSIT_AMOUNT);
        
        // Redeem
        vm.prank(user);
        token.approve(address(vault), DEPOSIT_AMOUNT);
        
        vm.prank(user);
        vault.redeem(DEPOSIT_AMOUNT);
        
        assertEq(token.balanceOf(user), 0);
        assertEq(user.balance, initialBalance); // Should get ETH back
    }

    function test_interestAccrualOnBothChains() public {
        // Test interest accrual on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        _testInterestAccrual(ethVault, ethRebaseToken, user1);
        
        // Test interest accrual on Arbitrum Sepolia  
        vm.selectFork(arbSepoliaFork);
        _testInterestAccrual(arbVault, arbRebaseToken, user2);
    }

    function _testInterestAccrual(Vault vault, RebaseToken token, address user) internal {
        // Deposit tokens
        vm.prank(user);
        vault.deposit{value: DEPOSIT_AMOUNT}();
        
        uint256 initialBalance = token.balanceOf(user);
        
        // Fast forward time (1 year)
        vm.warp(block.timestamp + 365 days);
        
        // Check balance includes interest
        uint256 balanceWithInterest = token.balanceOf(user);
        assertGt(balanceWithInterest, initialBalance, "Interest should accrue over time");
        
        // Trigger interest minting by transferring to self
        vm.prank(user);
        token.transfer(user, 0);
        
        // Balance should now include the accrued interest
        uint256 finalBalance = token.balanceOf(user);
        assertGe(finalBalance, balanceWithInterest, "Interest should be minted");
    }

    function test_crossChainPoolOperations() public {
        // Setup cross-chain pool mappings
        _setupCrossChainMappings();
        
        // Test lock/burn on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        _testLockOrBurn();
        
        // Test release/mint on Arbitrum Sepolia
        vm.selectFork(arbSepoliaFork);
        _testReleaseOrMint();
    }

    function _setupCrossChainMappings() internal {
        // Setup Ethereum -> Arbitrum mapping
        vm.selectFork(ethSepoliaFork);
        vm.prank(owner);
        Pool.ChainUpdate[] memory ethChainUpdates = new Pool.ChainUpdate[](1);
        ethChainUpdates[0] = Pool.ChainUpdate({
            remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
            remotePoolAddress: abi.encode(address(arbTokenPool)),
            remoteTokenAddress: abi.encode(address(arbRebaseToken)),
            allowed: true,
            outboundRateLimiterConfig: _getDefaultRateLimiterConfig(),
            inboundRateLimiterConfig: _getDefaultRateLimiterConfig()
        });
        ethTokenPool.applyChainUpdates(ethChainUpdates);
        
        // Setup Arbitrum -> Ethereum mapping
        vm.selectFork(arbSepoliaFork);
        vm.prank(owner);
        Pool.ChainUpdate[] memory arbChainUpdates = new Pool.ChainUpdate[](1);
        arbChainUpdates[0] = Pool.ChainUpdate({
            remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
            remotePoolAddress: abi.encode(address(ethTokenPool)),
            remoteTokenAddress: abi.encode(address(ethRebaseToken)),
            allowed: true,
            outboundRateLimiterConfig: _getDefaultRateLimiterConfig(),
            inboundRateLimiterConfig: _getDefaultRateLimiterConfig()
        });
        arbTokenPool.applyChainUpdates(arbChainUpdates);
    }

    function _testLockOrBurn() internal {
        // First, user needs some tokens to burn
        vm.prank(bridgeUser);
        ethVault.deposit{value: TRANSFER_AMOUNT}();
        
        uint256 initialBalance = ethRebaseToken.balanceOf(bridgeUser);
        uint256 userInterestRate = ethRebaseToken.getUserInterestRate(bridgeUser);
        
        // Prepare lock/burn parameters
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(bridgeUser),
            remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
            originalSender: bridgeUser,
            amount: TRANSFER_AMOUNT,
            localToken: abi.encode(address(ethRebaseToken))
        });

        // Execute lock/burn (simulate router call)
        vm.prank(owner); // Using owner as authorized caller
        Pool.LockOrBurnOutV1 memory result = ethTokenPool.lockOrBurn(lockOrBurnIn);

        // Verify tokens were burned
        assertEq(ethRebaseToken.balanceOf(bridgeUser), initialBalance - TRANSFER_AMOUNT);
        
        // Verify interest rate was encoded correctly
        uint256 encodedInterestRate = abi.decode(result.destPoolData, (uint256));
        assertEq(encodedInterestRate, userInterestRate);
    }

    function _testReleaseOrMint() internal {
        uint256 sourceInterestRate = 5e25; // 5% rate from source chain
        uint256 initialBalance = arbRebaseToken.balanceOf(bridgeUser);
        
        // Prepare release/mint parameters
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(bridgeUser),
            receiver: bridgeUser,
            amount: TRANSFER_AMOUNT,
            localToken: abi.encode(address(arbRebaseToken)),
            remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(ethTokenPool)),
            sourcePoolData: abi.encode(sourceInterestRate),
            offchainTokenData: ""
        });

        // Execute release/mint (simulate router call)
        vm.prank(owner); // Using owner as authorized caller
        Pool.ReleaseOrMintOutV1 memory result = arbTokenPool.releaseOrMint(releaseOrMintIn);

        // Verify tokens were minted
        assertEq(arbRebaseToken.balanceOf(bridgeUser), initialBalance + TRANSFER_AMOUNT);
        assertEq(result.destinationAmount, TRANSFER_AMOUNT);
        
        // Verify interest rate was preserved
        assertEq(arbRebaseToken.getUserInterestRate(bridgeUser), sourceInterestRate);
    }

    function test_fullCrossChainFlow() public {
        _setupCrossChainMappings();
        
        // Step 1: User deposits on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        vm.prank(bridgeUser);
        ethVault.deposit{value: DEPOSIT_AMOUNT}();
        
        uint256 ethInitialBalance = ethRebaseToken.balanceOf(bridgeUser);
        uint256 userInterestRate = ethRebaseToken.getUserInterestRate(bridgeUser);
        
        // Step 2: Lock/Burn on Ethereum Sepolia
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(bridgeUser),
            remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
            originalSender: bridgeUser,
            amount: TRANSFER_AMOUNT,
            localToken: abi.encode(address(ethRebaseToken))
        });

        vm.prank(owner);
        Pool.LockOrBurnOutV1 memory lockResult = ethTokenPool.lockOrBurn(lockOrBurnIn);

        // Step 3: Release/Mint on Arbitrum Sepolia
        vm.selectFork(arbSepoliaFork);
        uint256 arbInitialBalance = arbRebaseToken.balanceOf(bridgeUser);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(bridgeUser),
            receiver: bridgeUser,
            amount: TRANSFER_AMOUNT,
            localToken: abi.encode(address(arbRebaseToken)),
            remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(ethTokenPool)),
            sourcePoolData: lockResult.destPoolData,
            offchainTokenData: ""
        });

        vm.prank(owner);
        arbTokenPool.releaseOrMint(releaseOrMintIn);

        // Step 4: Verify final state
        vm.selectFork(ethSepoliaFork);
        assertEq(ethRebaseToken.balanceOf(bridgeUser), ethInitialBalance - TRANSFER_AMOUNT);
        
        vm.selectFork(arbSepoliaFork);
        assertEq(arbRebaseToken.balanceOf(bridgeUser), arbInitialBalance + TRANSFER_AMOUNT);
        assertEq(arbRebaseToken.getUserInterestRate(bridgeUser), userInterestRate);
    }

    function test_crossChainWithAccruedInterest() public {
        _setupCrossChainMappings();
        
        // Step 1: User deposits and waits for interest to accrue on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        vm.prank(bridgeUser);
        ethVault.deposit{value: DEPOSIT_AMOUNT}();
        
        // Fast forward time to accrue interest
        vm.warp(block.timestamp + 180 days); // 6 months
        
        uint256 balanceWithInterest = ethRebaseToken.balanceOf(bridgeUser);
        assertGt(balanceWithInterest, DEPOSIT_AMOUNT, "Interest should have accrued");
        
        uint256 userInterestRate = ethRebaseToken.getUserInterestRate(bridgeUser);
        
        // Step 2: Bridge tokens with accrued interest
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(bridgeUser),
            remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
            originalSender: bridgeUser,
            amount: balanceWithInterest, // Bridge all tokens including interest
            localToken: abi.encode(address(ethRebaseToken))
        });

        vm.prank(owner);
        Pool.LockOrBurnOutV1 memory lockResult = ethTokenPool.lockOrBurn(lockOrBurnIn);

        // Step 3: Mint on Arbitrum with preserved interest rate
        vm.selectFork(arbSepoliaFork);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(bridgeUser),
            receiver: bridgeUser,
            amount: balanceWithInterest,
            localToken: abi.encode(address(arbRebaseToken)),
            remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(ethTokenPool)),
            sourcePoolData: lockResult.destPoolData,
            offchainTokenData: ""
        });

        vm.prank(owner);
        arbTokenPool.releaseOrMint(releaseOrMintIn);

        // Step 4: Verify interest rate preservation and continue accruing
        assertEq(arbRebaseToken.balanceOf(bridgeUser), balanceWithInterest);
        assertEq(arbRebaseToken.getUserInterestRate(bridgeUser), userInterestRate);
        
        // Fast forward more time and verify interest continues to accrue
        vm.warp(block.timestamp + 180 days); // Another 6 months
        uint256 newBalance = arbRebaseToken.balanceOf(bridgeUser);
        assertGt(newBalance, balanceWithInterest, "Interest should continue accruing on destination chain");
    }

    function test_multipleUsersCorssChainTransfer() public {
        _setupCrossChainMappings();
        
        address[] memory users = new address[](3);
        users[0] = user1;
        users[1] = user2;  
        users[2] = bridgeUser;
        
        // Each user deposits on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        for (uint i = 0; i < users.length; i++) {
            vm.prank(users[i]);
            ethVault.deposit{value: DEPOSIT_AMOUNT}();
        }
        
        // Bridge all users to Arbitrum Sepolia
        for (uint i = 0; i < users.length; i++) {
            uint256 userBalance = ethRebaseToken.balanceOf(users[i]);
            uint256 userInterestRate = ethRebaseToken.getUserInterestRate(users[i]);
            
            // Lock/Burn on Ethereum
            Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
                receiver: abi.encode(users[i]),
                remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
                originalSender: users[i],
                amount: userBalance,
                localToken: abi.encode(address(ethRebaseToken))
            });

            vm.prank(owner);
            Pool.LockOrBurnOutV1 memory lockResult = ethTokenPool.lockOrBurn(lockOrBurnIn);

            // Release/Mint on Arbitrum
            vm.selectFork(arbSepoliaFork);
            
            Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
                originalSender: abi.encode(users[i]),
                receiver: users[i],
                amount: userBalance,
                localToken: abi.encode(address(arbRebaseToken)),
                remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
                sourcePoolAddress: abi.encode(address(ethTokenPool)),
                sourcePoolData: lockResult.destPoolData,
                offchainTokenData: ""
            });

            vm.prank(owner);
            arbTokenPool.releaseOrMint(releaseOrMintIn);

            // Verify each user's state
            assertEq(arbRebaseToken.balanceOf(users[i]), userBalance);
            assertEq(arbRebaseToken.getUserInterestRate(users[i]), userInterestRate);
            
            vm.selectFork(ethSepoliaFork);
        }
    }

    /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _getDefaultRateLimiterConfig() internal pure returns (Pool.RateLimiterConfig memory) {
        return Pool.RateLimiterConfig({
            isEnabled: false,
            capacity: 0,
            rate: 0
        });
    }

    /*//////////////////////////////////////////////////////////////
                            FUZZ TESTS
    //////////////////////////////////////////////////////////////*/

    function testFuzz_crossChainTransfer(uint256 depositAmount, uint256 timeElapsed) public {
        // Bound inputs
        depositAmount = bound(depositAmount, 0.01 ether, 5 ether);
        timeElapsed = bound(timeElapsed, 1 days, 365 days);
        
        _setupCrossChainMappings();
        
        // Deposit on Ethereum Sepolia
        vm.selectFork(ethSepoliaFork);
        vm.deal(bridgeUser, depositAmount + 1 ether); // Extra for gas
        
        vm.prank(bridgeUser);
        ethVault.deposit{value: depositAmount}();
        
        // Let time pass
        vm.warp(block.timestamp + timeElapsed);
        
        uint256 balanceWithInterest = ethRebaseToken.balanceOf(bridgeUser);
        uint256 userInterestRate = ethRebaseToken.getUserInterestRate(bridgeUser);
        
        // Bridge to Arbitrum
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(bridgeUser),
            remoteChainSelector: ARB_SEPOLIA_CHAIN_SELECTOR,
            originalSender: bridgeUser,
            amount: balanceWithInterest,
            localToken: abi.encode(address(ethRebaseToken))
        });

        vm.prank(owner);
        Pool.LockOrBurnOutV1 memory lockResult = ethTokenPool.lockOrBurn(lockOrBurnIn);

        vm.selectFork(arbSepoliaFork);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(bridgeUser),
            receiver: bridgeUser,
            amount: balanceWithInterest,
            localToken: abi.encode(address(arbRebaseToken)),
            remoteChainSelector: ETH_SEPOLIA_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(ethTokenPool)),
            sourcePoolData: lockResult.destPoolData,
            offchainTokenData: ""
        });

        vm.prank(owner);
        arbTokenPool.releaseOrMint(releaseOrMintIn);

        // Verify final state
        assertEq(arbRebaseToken.balanceOf(bridgeUser), balanceWithInterest);
        assertEq(arbRebaseToken.getUserInterestRate(bridgeUser), userInterestRate);
        assertGe(balanceWithInterest, depositAmount); // have accrued some interest
    }
}
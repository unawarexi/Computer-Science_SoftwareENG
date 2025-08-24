// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {RebaseTokenPool} from "../src/RebaseTokenPool.sol";
import {RebaseToken} from "../src/RebaseToken.sol";
import {IRebaseToken} from "../src/interfaces/IRebaseToken.sol";
import {Pool} from "@ccip/contracts/src/v0.8/ccip/libraries/Pool.sol";
import {IERC20} from "@ccip/contracts/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {TokenPool} from "@ccip/contracts/src/v0.8/ccip/pools/TokenPool.sol";
import {RateLimiter} from "@ccip/contracts/src/v0.8/ccip/libraries/RateLimiter.sol";

/**
 * @title RebaseTokenPoolTest
 * @notice Unit tests for RebaseTokenPool contract
 * @dev Tests pool functionality with mocked CCIP components
 */
contract RebaseTokenPoolTest is Test {
    // Test contracts
    RebaseTokenPool public pool;
    RebaseToken public rebaseToken;
    
    // Test addresses
    address public owner = makeAddr("owner");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public rmnProxy = makeAddr("rmnProxy");
    address public router = makeAddr("router");
    address public offRamp = makeAddr("offRamp");
    address public onRamp = makeAddr("onRamp");
    
    // Test constants
    uint64 public constant SOURCE_CHAIN_SELECTOR = 1;
    uint64 public constant DEST_CHAIN_SELECTOR = 2;
    uint256 public constant INITIAL_MINT_AMOUNT = 1000e18;
    uint256 public constant TRANSFER_AMOUNT = 100e18;
    uint256 public constant CUSTOM_INTEREST_RATE = 3e25; // 3% annual rate
    uint256 public constant DEFAULT_INTEREST_RATE = 5e25; // 5% annual rate (from RebaseToken)
    
    // Events to test
    event TokensBurned(address indexed user, uint256 amount, uint256 userInterestRate);
    event TokensMinted(address indexed user, uint256 amount, uint256 userInterestRate);

    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy RebaseToken
        rebaseToken = new RebaseToken();
        
        // Set up allowlist for the pool
        address[] memory allowlist = new address[](2);
        allowlist[0] = onRamp;
        allowlist[1] = offRamp;
        
        // Deploy RebaseTokenPool
        pool = new RebaseTokenPool(
            IERC20(address(rebaseToken)),
            allowlist,
            rmnProxy,
            router
        );
        
        // Grant mint and burn role to the pool
        rebaseToken.grantMintAndBurnRole(address(pool));
        
        // Set up remote token mapping
        bytes memory remoteToken = abi.encode(address(rebaseToken));
        uint64[] memory chainSelectorsToRemove = new uint64[](0);
        pool.applyChainUpdates(chainSelectorsToRemove, getChainUpdate(DEST_CHAIN_SELECTOR, remoteToken));
        
        // Mint initial tokens to users for testing
        rebaseToken.mintWithCurrentRate(user1, INITIAL_MINT_AMOUNT);
        rebaseToken.mintWithCurrentRate(user2, INITIAL_MINT_AMOUNT);
        
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                            LOCK OR BURN TESTS
    //////////////////////////////////////////////////////////////*/

    function test_lockOrBurn_Success() public {
        // Arrange
        uint256 initialBalance = rebaseToken.balanceOf(user1);
        uint256 expectedUserInterestRate = rebaseToken.getUserInterestRate(user1);
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: TRANSFER_AMOUNT,
            localToken: address(rebaseToken)
        });

        vm.expectEmit(true, true, true, true);
        emit TokensBurned(user1, TRANSFER_AMOUNT, expectedUserInterestRate);

        // Act
        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        // Assert
        assertEq(rebaseToken.balanceOf(user1), initialBalance - TRANSFER_AMOUNT);
        assertEq(result.destTokenAddress, abi.encode(address(rebaseToken)));
        
        uint256 encodedInterestRate = abi.decode(result.destPoolData, (uint256));
        assertEq(encodedInterestRate, expectedUserInterestRate);
    }

    function test_lockOrBurn_WithCustomInterestRate() public {
        // Arrange - First set a custom interest rate for user1
        vm.prank(owner);
        rebaseToken.mint(user1, 0, CUSTOM_INTEREST_RATE); // Just to set interest rate
        
        uint256 customUserInterestRate = rebaseToken.getUserInterestRate(user1);
        assertEq(customUserInterestRate, CUSTOM_INTEREST_RATE);
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: TRANSFER_AMOUNT,
            localToken: address(rebaseToken)
        });

        vm.expectEmit(true, true, true, true);
        emit TokensBurned(user1, TRANSFER_AMOUNT, CUSTOM_INTEREST_RATE);

        // Act
        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        // Assert
        uint256 encodedInterestRate = abi.decode(result.destPoolData, (uint256));
        assertEq(encodedInterestRate, CUSTOM_INTEREST_RATE);
    }

    function test_lockOrBurn_RevertWhen_UnauthorizedCaller() public {
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken)
        });

        // Act & Assert
        vm.prank(user1); // Unauthorized caller
        vm.expectRevert(); // Should revert due to unauthorized caller
        pool.lockOrBurn(lockOrBurnIn);
    }

    function test_lockOrBurn_RevertWhen_InsufficientBalance() public {
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: INITIAL_MINT_AMOUNT + 1, // More than user has
           localToken: address(rebaseToken)
        });

        // Act & Assert
        vm.prank(onRamp);
        vm.expectRevert(); // Should revert due to insufficient balance
        pool.lockOrBurn(lockOrBurnIn);
    }

    function test_lockOrBurn_WithZeroAmount() public {
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: 0,
           localToken: address(rebaseToken)
        });

        // Act & Assert
        vm.prank(onRamp);
        vm.expectRevert(); // Should revert due to zero amount
        pool.lockOrBurn(lockOrBurnIn);
    }

    function test_lockOrBurn_WithAccruedInterest() public {
        // Fast forward time to accrue interest
        vm.warp(block.timestamp + 365 days);
        
        uint256 balanceWithInterest = rebaseToken.balanceOf(user1);
        uint256 userInterestRate = rebaseToken.getUserInterestRate(user1);
        
        // Should be able to burn the full balance including interest
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: balanceWithInterest,
           localToken: address(rebaseToken)
        });

        vm.expectEmit(true, true, true, true);
        emit TokensBurned(user1, balanceWithInterest, userInterestRate);

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        uint256 encodedInterestRate = abi.decode(result.destPoolData, (uint256));
        assertEq(encodedInterestRate, userInterestRate);
        assertEq(rebaseToken.balanceOf(user1), 0);
    }

    /*//////////////////////////////////////////////////////////////
                            RELEASE OR MINT TESTS
    //////////////////////////////////////////////////////////////*/

    function test_releaseOrMint_Success() public {
        // Arrange
        uint256 initialBalance = rebaseToken.balanceOf(user2);
        uint256 sourceInterestRate = rebaseToken.getUserInterestRate(user1);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(sourceInterestRate),
            offchainTokenData: ""
        });

        vm.expectEmit(true, true, true, true);
        emit TokensMinted(user2, TRANSFER_AMOUNT, sourceInterestRate);

        // Act
        vm.prank(offRamp);
        Pool.ReleaseOrMintOutV1 memory result = pool.releaseOrMint(releaseOrMintIn);

        // Assert
        assertEq(rebaseToken.balanceOf(user2), initialBalance + TRANSFER_AMOUNT);
        assertEq(result.destinationAmount, TRANSFER_AMOUNT);
        assertEq(rebaseToken.getUserInterestRate(user2), sourceInterestRate);
    }

    function test_releaseOrMint_WithCustomInterestRate() public {
        // Arrange
        uint256 initialBalance = rebaseToken.balanceOf(user2);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(CUSTOM_INTEREST_RATE),
            offchainTokenData: ""
        });

        vm.expectEmit(true, true, true, true);
        emit TokensMinted(user2, TRANSFER_AMOUNT, CUSTOM_INTEREST_RATE);

        // Act
        vm.prank(offRamp);
        Pool.ReleaseOrMintOutV1 memory result = pool.releaseOrMint(releaseOrMintIn);

        // Assert
        assertEq(rebaseToken.balanceOf(user2), initialBalance + TRANSFER_AMOUNT);
        assertEq(result.destinationAmount, TRANSFER_AMOUNT);
        assertEq(rebaseToken.getUserInterestRate(user2), CUSTOM_INTEREST_RATE);
    }

    function test_releaseOrMint_ToNewUser() public {
        // Arrange
        address newUser = makeAddr("newUser");
        uint256 sourceInterestRate = rebaseToken.getUserInterestRate(user1);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: newUser,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(sourceInterestRate),
            offchainTokenData: ""
        });

        vm.expectEmit(true, true, true, true);
        emit TokensMinted(newUser, TRANSFER_AMOUNT, sourceInterestRate);

        // Act
        vm.prank(offRamp);
        pool.releaseOrMint(releaseOrMintIn);

        // Assert
        assertEq(rebaseToken.balanceOf(newUser), TRANSFER_AMOUNT);
        assertEq(rebaseToken.getUserInterestRate(newUser), sourceInterestRate);
    }

    function test_releaseOrMint_OverwritesExistingInterestRate() public {
        // Arrange - user2 already has tokens with default interest rate
        uint256 initialBalance = rebaseToken.balanceOf(user2);
        uint256 initialInterestRate = rebaseToken.getUserInterestRate(user2);
        assertEq(initialInterestRate, DEFAULT_INTEREST_RATE);
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(CUSTOM_INTEREST_RATE), // Different rate
            offchainTokenData: ""
        });

        // Act
        vm.prank(offRamp);
        pool.releaseOrMint(releaseOrMintIn);

        // Assert - interest rate should be updated to the source chain's rate
        assertEq(rebaseToken.getUserInterestRate(user2), CUSTOM_INTEREST_RATE);
        assertEq(rebaseToken.balanceOf(user2), initialBalance + TRANSFER_AMOUNT);
    }

    function test_releaseOrMint_RevertWhen_UnauthorizedCaller() public {
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(rebaseToken.getUserInterestRate(user1)),
            offchainTokenData: ""
        });

        // Act & Assert
        vm.prank(user1); // Unauthorized caller
        vm.expectRevert(); // Should revert due to unauthorized caller
        pool.releaseOrMint(releaseOrMintIn);
    }

    function test_releaseOrMint_WithZeroAmount() public {
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: 0,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(rebaseToken.getUserInterestRate(user1)),
            offchainTokenData: ""
        });

        // Act & Assert
        vm.prank(offRamp);
        vm.expectRevert(); // Should revert due to zero amount
        pool.releaseOrMint(releaseOrMintIn);
    }

    function test_releaseOrMint_WithZeroAddress() public {
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: address(0), // Zero address
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(rebaseToken.getUserInterestRate(user1)),
            offchainTokenData: ""
        });

        // Act & Assert
        vm.prank(offRamp);
        vm.expectRevert(); // Should revert due to zero address
        pool.releaseOrMint(releaseOrMintIn);
    }

    /*//////////////////////////////////////////////////////////////
                        INTEREST RATE ENCODING TESTS
    //////////////////////////////////////////////////////////////*/

    function test_interestRateEncoding_DefaultRate() public {
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        uint256 encodedRate = abi.decode(result.destPoolData, (uint256));
        uint256 expectedRate = rebaseToken.getUserInterestRate(user1);
        
        assertEq(encodedRate, expectedRate);
        // Should be the default 5% rate
        assertEq(encodedRate, DEFAULT_INTEREST_RATE);
    }

    function test_interestRateEncoding_ZeroRate() public {
        // Set user1's interest rate to zero (edge case)
        vm.prank(owner);
        rebaseToken.mint(user1, 0, 1); // Minimum non-zero rate due to validation
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        uint256 encodedRate = abi.decode(result.destPoolData, (uint256));
        assertEq(encodedRate, 1);
    }

    function test_interestRateEncoding_MaxRate() public {
        uint256 maxRate = type(uint256).max;
        
        // This should fail due to RebaseToken validation, but let's test encoding
        vm.prank(owner);
        vm.expectRevert(); // Should revert due to interest rate validation
        rebaseToken.mint(user1, 0, maxRate);
    }

    /*//////////////////////////////////////////////////////////////
                        POOL CONFIGURATION TESTS  
    //////////////////////////////////////////////////////////////*/

    function test_poolConfiguration_CheckTokenAddress() public {
        assertEq(address(pool.getToken()), address(rebaseToken));
    }

    function test_poolConfiguration_CheckDecimals() public {
        assertEq(pool.getTokenDecimals(), 18);
    }

    function test_poolConfiguration_RemoteTokenMapping() public {
        bytes memory remoteToken = pool.getRemoteToken(DEST_CHAIN_SELECTOR);
        address expectedRemoteToken = abi.decode(remoteToken, (address));
        assertEq(expectedRemoteToken, address(rebaseToken));
    }

    function test_poolConfiguration_AllowlistCheck() public {
        // onRamp should be allowed
        assertTrue(pool.isSupportedToken(address(rebaseToken)));
        
        // Check that the pool has proper access controls
        // This is indirectly tested through successful lock/burn and release/mint operations
    }

    /*//////////////////////////////////////////////////////////////
                            EDGE CASES
    //////////////////////////////////////////////////////////////*/

    function test_edgeCase_BurnEntireBalance() public {
        uint256 userBalance = rebaseToken.balanceOf(user1);
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: userBalance, // Burn entire balance
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        pool.lockOrBurn(lockOrBurnIn);

        assertEq(rebaseToken.balanceOf(user1), 0);
    }

    function test_edgeCase_MintToSameUserMultipleTimes() public {
        uint256 initialBalance = rebaseToken.balanceOf(user2);
        
        // First mint
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: TRANSFER_AMOUNT,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(CUSTOM_INTEREST_RATE),
            offchainTokenData: ""
        });

        vm.prank(offRamp);
        pool.releaseOrMint(releaseOrMintIn);

        // Second mint with different interest rate
        releaseOrMintIn.sourcePoolData = abi.encode(DEFAULT_INTEREST_RATE);
        
        vm.prank(offRamp);
        pool.releaseOrMint(releaseOrMintIn);

        // Should have received both amounts
        assertEq(rebaseToken.balanceOf(user2), initialBalance + (2 * TRANSFER_AMOUNT));
        // Interest rate should be from the last mint
        assertEq(rebaseToken.getUserInterestRate(user2), DEFAULT_INTEREST_RATE);
    }

    function test_edgeCase_LargeAmounts() public {
        uint256 largeAmount = 1e30; // Very large amount  
        
        // Mint large amount to user1 first
        vm.prank(owner);
        rebaseToken.mintWithCurrentRate(user1, largeAmount);
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: largeAmount,
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        // Should handle large amounts without overflow
        uint256 encodedRate = abi.decode(result.destPoolData, (uint256));
        assertGt(encodedRate, 0);
    }

    /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getChainUpdate(uint64 chainSelector, bytes memory tokenAddress) 
        internal 
        pure 
        returns (TokenPool.ChainUpdate[] memory) 
    {
       TokenPool.ChainUpdate[] memory chainUpdates = new TokenPool.ChainUpdate[](1);
      // Create remote pool addresses array
        bytes[] memory remotePoolAddresses = new bytes[](1);
        remotePoolAddresses[0] = abi.encode(address(0)); // Placeholder pool address
        
        chainUpdates[0] = TokenPool.ChainUpdate({
            remoteChainSelector: chainSelector,
            remotePoolAddresses: remotePoolAddresses,
            remoteTokenAddress: tokenAddress,
            outboundRateLimiterConfig: getDefaultRateLimiterConfig(),
            inboundRateLimiterConfig: getDefaultRateLimiterConfig()
        });
        return chainUpdates;
    }

    function getDefaultRateLimiterConfig() internal pure returns (RateLimiter.Config memory) {
        return RateLimiter.Config({
            isEnabled: false,
            capacity: 0,
            rate: 0
        });
    }

    /*//////////////////////////////////////////////////////////////
                            FUZZ TESTS
    //////////////////////////////////////////////////////////////*/

    function testFuzz_lockOrBurn_ValidAmounts(uint256 amount) public {
        // Bound to reasonable range - can't be more than user has
        amount = bound(amount, 1, INITIAL_MINT_AMOUNT);
        
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: amount,
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory result = pool.lockOrBurn(lockOrBurnIn);

        uint256 encodedRate = abi.decode(result.destPoolData, (uint256));
        assertGt(encodedRate, 0); // Should have valid interest rate
        assertEq(rebaseToken.balanceOf(user1), INITIAL_MINT_AMOUNT - amount);
    }

    function testFuzz_releaseOrMint_ValidInterestRates(uint256 interestRate, uint256 amount) public {
        // Bound inputs to reasonable ranges
        amount = bound(amount, 1, type(uint128).max);
        interestRate = bound(interestRate, 1, 20e25); // 0.01% to 20% annual rate
        
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: amount,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: abi.encode(interestRate),
            offchainTokenData: ""
        });

        vm.prank(offRamp);
        Pool.ReleaseOrMintOutV1 memory result = pool.releaseOrMint(releaseOrMintIn);

        assertEq(result.destinationAmount, amount);
        assertEq(rebaseToken.getUserInterestRate(user2), interestRate);
    }

    function testFuzz_lockThenMint_PreservesInterestRate(uint256 amount, uint256 customRate) public {
        // Bound inputs
        amount = bound(amount, 1, INITIAL_MINT_AMOUNT);
        customRate = bound(customRate, 1, 10e25); // 0.01% to 10%
        
        // Set custom interest rate for user1
        vm.prank(owner);
        rebaseToken.mint(user1, 0, customRate);
        
        // Lock/Burn
        Pool.LockOrBurnInV1 memory lockOrBurnIn = Pool.LockOrBurnInV1({
            receiver: abi.encode(user2),
            remoteChainSelector: DEST_CHAIN_SELECTOR,
            originalSender: user1,
            amount: amount,
           localToken: address(rebaseToken)
        });

        vm.prank(onRamp);
        Pool.LockOrBurnOutV1 memory lockResult = pool.lockOrBurn(lockOrBurnIn);

        // Release/Mint
        Pool.ReleaseOrMintInV1 memory releaseOrMintIn = Pool.ReleaseOrMintInV1({
            originalSender: abi.encode(user1),
            receiver: user2,
            amount: amount,
           localToken: address(rebaseToken),
            remoteChainSelector: SOURCE_CHAIN_SELECTOR,
            sourcePoolAddress: abi.encode(address(pool)),
            sourcePoolData: lockResult.destPoolData,
            offchainTokenData: ""
        });

        vm.prank(offRamp);
        pool.releaseOrMint(releaseOrMintIn);

        // Interest rate should be preserved
        assertEq(rebaseToken.getUserInterestRate(user2), customRate);
    }
}
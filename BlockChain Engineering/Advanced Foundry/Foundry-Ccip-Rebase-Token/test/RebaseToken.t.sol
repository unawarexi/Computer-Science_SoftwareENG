// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {IRebaseToken} from "../src/interfaces/IRebaseToken.sol";
import {RebaseToken} from "../src/RebaseToken.sol";

contract RebaseTokenTest is Test {
    // Constants
    uint256 public constant REWARD_SUPPLY = 1e18;
    uint256 public constant INITIAL_INTEREST_RATE = (5 * 1e27) / 1e8; // 5% annual
    uint256 public constant SECONDS_IN_YEAR = 365 days;
    uint256 public constant INTEREST_RATE_PRECISION = 1e27;

    // Contracts
    Vault private vault;
    RebaseToken private rebaseToken;

    // Test accounts
    address public owner = makeAddr("owner");
    address public user = makeAddr("user");
    address public user2 = makeAddr("user2");
    address public unauthorized = makeAddr("unauthorized");

    // Events for testing
    event InterestRateSet(uint256 newInterestRate);
    event Deposit(address indexed _user, uint256 _amount);
    event Redeem(address indexed _user, uint256 _amount);

    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy contracts
        rebaseToken = new RebaseToken();
        vault = new Vault(IRebaseToken(address(rebaseToken)));
        
        // Grant vault the mint and burn role
        rebaseToken.grantMintAndBurnRole(address(vault));

         // Give the owner some ETH first
         vm.deal(owner, REWARD_SUPPLY);
    
        
        // Fund vault with ETH for redemptions
        (bool success, ) = payable(address(vault)).call{value: REWARD_SUPPLY}("");
        require(success, "Failed to fund vault");
        
        vm.stopPrank();
    }

    // ================================
    // REBASE TOKEN TESTS
    // ================================

    function testInitialState() public {
        // Test initial interest rate
        assertEq(rebaseToken.getInterestRate(), INITIAL_INTEREST_RATE);
        
        // Test initial roles
        assertTrue(rebaseToken.hasRole(rebaseToken.DEFAULT_ADMIN_ROLE(), owner));
        assertTrue(rebaseToken.hasRole(rebaseToken.MINT_AND_BURN_ROLE(), owner));
        assertTrue(rebaseToken.hasRole(rebaseToken.MINT_AND_BURN_ROLE(), address(vault)));
    }

    function testSetInterestRateDecrease() public {
        vm.startPrank(owner);
        
        uint256 newRate = INITIAL_INTEREST_RATE / 2; // 2.5%
        
        vm.expectEmit(true, false, false, true);
        emit InterestRateSet(newRate);
        
        rebaseToken.setInterestRate(newRate);
        assertEq(rebaseToken.getInterestRate(), newRate);
        
        vm.stopPrank();
    }

    function testSetInterestRateCannotIncrease() public {
        vm.startPrank(owner);
        
        uint256 higherRate = INITIAL_INTEREST_RATE * 2; // 10%
        
        vm.expectRevert(
            abi.encodeWithSelector(
                RebaseToken.RebaseToken_InterestRateCanOnlyDecrease.selector,
                INITIAL_INTEREST_RATE,
                higherRate
            )
        );
        
        rebaseToken.setInterestRate(higherRate);
        
        vm.stopPrank();
    }

    function testSetInterestRateCannotBeZero() public {
        vm.startPrank(owner);
        
        vm.expectRevert(RebaseToken.RebaseToken_InterestRateCannotBeZero.selector);
        rebaseToken.setInterestRate(0);
        
        vm.stopPrank();
    }

    function testSetInterestRateOnlyOwner() public {
        vm.startPrank(unauthorized);
        
        vm.expectRevert(); // Should revert with Ownable: caller is not the owner
        rebaseToken.setInterestRate(INITIAL_INTEREST_RATE / 2);
        
        vm.stopPrank();
    }

    function testMintWithCurrentRate() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        assertEq(rebaseToken.balanceOf(user), amount);
        assertEq(rebaseToken.getUserInterestRate(user), INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testMintWithCustomRate() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        uint256 customRate = INITIAL_INTEREST_RATE / 2;
        
        rebaseToken.mint(user, amount, customRate);
        
        assertEq(rebaseToken.balanceOf(user), amount);
        assertEq(rebaseToken.getUserInterestRate(user), customRate);
        
        vm.stopPrank();
    }

    function testMintToZeroAddress() public {
        vm.startPrank(owner);
        
        vm.expectRevert(RebaseToken.RebaseToken_MintToZeroAddress.selector);
        rebaseToken.mint(address(0), 1000e18, INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testMintZeroAmount() public {
        vm.startPrank(owner);
        
        vm.expectRevert(RebaseToken.RebaseToken_AmountCannotBeZero.selector);
        rebaseToken.mint(user, 0, INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testInterestAccrual() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        uint256 initialBalance = rebaseToken.balanceOf(user);
        assertEq(initialBalance, amount);
        
        // Fast forward 1 year
        vm.warp(block.timestamp + SECONDS_IN_YEAR);
        
        uint256 balanceAfterYear = rebaseToken.balanceOf(user);
        
        // Should be approximately 5% more (1050e18)
        uint256 expectedInterest = (amount * INITIAL_INTEREST_RATE) / INTEREST_RATE_PRECISION;
        assertApproxEqAbs(balanceAfterYear, amount + expectedInterest, 1e10);
        
        vm.stopPrank();
    }

    function testInterestAccrualPartialYear() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        // Fast forward 6 months
        vm.warp(block.timestamp + (SECONDS_IN_YEAR / 2));
        
        uint256 balanceAfterSixMonths = rebaseToken.balanceOf(user);
        
        // Should be approximately 2.5% more
        uint256 expectedInterest = (amount * INITIAL_INTEREST_RATE) / INTEREST_RATE_PRECISION / 2;
        assertApproxEqAbs(balanceAfterSixMonths, amount + expectedInterest, 1e10);
        
        vm.stopPrank();
    }

    function testTransferWithInterestAccrual() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        vm.stopPrank();
        
        // Fast forward time to accrue interest
        vm.warp(block.timestamp + (SECONDS_IN_YEAR / 4)); // 3 months
        
        vm.startPrank(user);
        
        uint256 balanceBeforeTransfer = rebaseToken.balanceOf(user);
        uint256 transferAmount = 500e18;
        
        // Transfer tokens to user2
        rebaseToken.transfer(user2, transferAmount);
        
        // Check balances
        assertEq(rebaseToken.balanceOf(user), balanceBeforeTransfer - transferAmount);
        assertEq(rebaseToken.balanceOf(user2), transferAmount);
        
        // Check that user2 inherited the current interest rate
        assertEq(rebaseToken.getUserInterestRate(user2), INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testBurnFrom() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        // Fast forward to accrue interest
        vm.warp(block.timestamp + (SECONDS_IN_YEAR / 4));
        
        uint256 balanceBeforeBurn = rebaseToken.balanceOf(user);
        uint256 burnAmount = 300e18;
        
        rebaseToken.burnFrom(burnAmount, user);
        
        assertEq(rebaseToken.balanceOf(user), balanceBeforeBurn - burnAmount);
        
        vm.stopPrank();
    }

    function testGrantAndRevokeRoles() public {
        vm.startPrank(owner);
        
        // Grant role to user
        rebaseToken.grantMintAndBurnRole(user);
        assertTrue(rebaseToken.hasRole(rebaseToken.MINT_AND_BURN_ROLE(), user));
        
        // Revoke role from user
        rebaseToken.revokeMintAndBurnRole(user);
        assertFalse(rebaseToken.hasRole(rebaseToken.MINT_AND_BURN_ROLE(), user));
        
        vm.stopPrank();
    }

    // ================================
    // VAULT TESTS
    // ================================

    function testVaultDeposit() public {
        uint256 depositAmount = 1e18;
        
        vm.startPrank(user);
        vm.deal(user, depositAmount);
        
        vm.expectEmit(true, false, false, true);
        emit Deposit(user, depositAmount);
        
        vault.deposit{value: depositAmount}();
        
        assertEq(rebaseToken.balanceOf(user), depositAmount);
        assertEq(rebaseToken.getUserInterestRate(user), INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testVaultDepositWithInterestAccrual() public {
        uint256 depositAmount = 5e18;
        
        vm.startPrank(user);
        vm.deal(user, depositAmount);
        
        vault.deposit{value: depositAmount}();
        
        uint256 initialBalance = rebaseToken.balanceOf(user);
        
        // Fast forward 1 hour
        vm.warp(block.timestamp + 1 hours);
        
        uint256 balanceAfterHour = rebaseToken.balanceOf(user);
        assertGt(balanceAfterHour, initialBalance);
        
        // Fast forward another hour
        vm.warp(block.timestamp + 1 hours);
        
        uint256 finalBalance = rebaseToken.balanceOf(user);
        assertGt(finalBalance, balanceAfterHour);
        
        // Interest should compound consistently
        assertApproxEqAbs(
            finalBalance - balanceAfterHour,
            balanceAfterHour - initialBalance,
            1e10 // Small tolerance for rounding
        );
        
        vm.stopPrank();
    }

    // Note: The redeem function has issues - it calls burn() instead of burnFrom()
    // and the interface doesn't match the implementation
    function testVaultRedeem() public {
        uint256 depositAmount = 5e18;
        
        vm.startPrank(user);
        vm.deal(user, depositAmount);
        
        vault.deposit{value: depositAmount}();
        
        // User should have tokens now
        assertEq(rebaseToken.balanceOf(user), depositAmount);
        
        // Redeem the tokens
        vm.expectEmit(true, false, false, true);
        emit Redeem(user, depositAmount);
        
        vault.redeem(depositAmount);
        
        // User should have no tokens left
        assertEq(rebaseToken.balanceOf(user), 0);
        
        // User should receive the underlying asset back
        assertEq(address(user).balance, depositAmount);
        
        vm.stopPrank();
    }
    // function testVaultRedeemFails() public {
    //     uint256 depositAmount = 5e18;
        
    //     vm.startPrank(user);
    //     vm.deal(user, depositAmount);
        
    //     vault.deposit{value: depositAmount}();
        
    //     // This should fail because the interface and implementation don't match
    //     vm.expectRevert();
    //     vault.redeem(depositAmount);
        
    //     vm.stopPrank();
    // }

    // function testVaultRedeemInvalidAmount() public {
    //     vm.startPrank(user);
        
    //     vm.expectRevert("Vault__InvalidAmount");
    //     vault.redeem(0);
        
    //     vm.stopPrank();
    // }

    function testGetRebaseTokenAddress() public {
        assertEq(vault.getRebaseTokenAddress(), address(rebaseToken));
    }

    // ================================
    // FUZZ TESTS
    // ================================

    function testFuzzDeposit(uint256 _amount) public {
        _amount = bound(_amount, 1e5, type(uint96).max); // Reasonable bounds
        
        vm.startPrank(user);
        vm.deal(user, _amount);
        
        vault.deposit{value: _amount}();
        
        assertEq(rebaseToken.balanceOf(user), _amount);
        
        vm.stopPrank();
    }

    function testFuzzMint(uint256 _amount, uint256 _rate) public {
        _amount = bound(_amount, 1, type(uint128).max);
        _rate = bound(_rate, 1, INITIAL_INTEREST_RATE); // Rate can only decrease
        
        vm.startPrank(owner);
        
        rebaseToken.mint(user, _amount, _rate);
        
        assertEq(rebaseToken.balanceOf(user), _amount);
        assertEq(rebaseToken.getUserInterestRate(user), _rate);
        
        vm.stopPrank();
    }

    function testFuzzInterestAccrual(uint256 _amount, uint256 _timeElapsed) public {
        _amount = bound(_amount, 1e18, type(uint128).max);
        _timeElapsed = bound(_timeElapsed, 1, SECONDS_IN_YEAR * 10); // Up to 10 years
        
        vm.startPrank(owner);
        
        rebaseToken.mintWithCurrentRate(user, _amount);
        
        vm.warp(block.timestamp + _timeElapsed);
        
        uint256 finalBalance = rebaseToken.balanceOf(user);
        
        // Balance should always be greater than or equal to initial amount
        assertGe(finalBalance, _amount);
        
        // Calculate expected interest
        uint256 expectedInterest = (_amount * INITIAL_INTEREST_RATE * _timeElapsed) 
            / INTEREST_RATE_PRECISION / SECONDS_IN_YEAR;
        
        assertApproxEqAbs(finalBalance, _amount + expectedInterest, _amount / 1e6); // 0.0001% tolerance
        
        vm.stopPrank();
    }

    function testFuzzTransfer(uint256 _mintAmount, uint256 _transferAmount) public {
        _mintAmount = bound(_mintAmount, 1e18, type(uint128).max);
        _transferAmount = bound(_transferAmount, 1, _mintAmount);
        
        vm.startPrank(owner);
        rebaseToken.mintWithCurrentRate(user, _mintAmount);
        vm.stopPrank();
        
        vm.startPrank(user);
        
        rebaseToken.transfer(user2, _transferAmount);
        
        assertEq(rebaseToken.balanceOf(user), _mintAmount - _transferAmount);
        assertEq(rebaseToken.balanceOf(user2), _transferAmount);
        
        vm.stopPrank();
    }

    function testFuzzSetInterestRate(uint256 _newRate) public {
        _newRate = bound(_newRate, 1, INITIAL_INTEREST_RATE); // Can only decrease
        
        vm.startPrank(owner);
        
        rebaseToken.setInterestRate(_newRate);
        assertEq(rebaseToken.getInterestRate(), _newRate);
        
        vm.stopPrank();
    }

    // ================================
    // EDGE CASE TESTS
    // ================================

    function testZeroBalanceInterest() public {
        vm.startPrank(owner);
        
        // Mint zero tokens (should fail)
        vm.expectRevert(RebaseToken.RebaseToken_AmountCannotBeZero.selector);
        rebaseToken.mint(user, 0, INITIAL_INTEREST_RATE);
        
        vm.stopPrank();
    }

    function testTransferMaxAmount() public {
        vm.startPrank(owner);
        
        uint256 amount = 1000e18;
        rebaseToken.mintWithCurrentRate(user, amount);
        
        vm.stopPrank();
        
        vm.warp(block.timestamp + 1000); // Add some interest
        
        vm.startPrank(user);
        
        uint256 balanceBeforeTransfer = rebaseToken.balanceOf(user);
        
        // Transfer max amount (type(uint256).max should transfer full balance)
        rebaseToken.transfer(user2, type(uint256).max);
        
        assertEq(rebaseToken.balanceOf(user), 0);
        assertEq(rebaseToken.balanceOf(user2), balanceBeforeTransfer);
        
        vm.stopPrank();
    }

    function testMultipleUsersIndependentInterest() public {
        vm.startPrank(owner);
        
        uint256 amount1 = 1000e18;
        uint256 amount2 = 2000e18;
        uint256 rate1 = INITIAL_INTEREST_RATE;
        uint256 rate2 = INITIAL_INTEREST_RATE / 2;
        
        rebaseToken.mint(user, amount1, rate1);
        
        vm.warp(block.timestamp + 1000);
        
        rebaseToken.mint(user2, amount2, rate2);
        
        vm.warp(block.timestamp + SECONDS_IN_YEAR);
        
        uint256 user1Balance = rebaseToken.balanceOf(user);
        uint256 user2Balance = rebaseToken.balanceOf(user2);
        
        // User1 should have more interest than user2 (higher rate, longer time)
        uint256 user1Interest = user1Balance - amount1;
        uint256 user2Interest = user2Balance - amount2;
        
        assertGt(user1Interest, user2Interest);
        
        vm.stopPrank();
    }
}
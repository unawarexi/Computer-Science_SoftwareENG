// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {PreBuiltToken} from "../src/PreBuilt-Token.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract PreBuiltTokenTest is Test{
    PreBuiltToken public token; 
    DeployOurToken public deployer;// Deploy the token with 1 million initial supply
    uint256 public constant STARTING_BALALNCE = 500_000 * 10 ** 18; // 1 million tokens with 18 decimals
        
    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    // Set up the test environment
    function setUp() public {
        deployer = new DeployOurToken(); // Deploy the token contract
        token = deployer.run(); // Call the run function to deploy the token
        vm.prank(msg.sender); // Set the context to the test contract
        token.transfer(bob, STARTING_BALALNCE); // Transfer 500,000 tokens to Bob


        // assertEq(token.totalSupply(), 1_000_000 * 10 ** 18); // Check if the total supply is correct
        // assertEq(token.name(), "PreBuiltToken"); // Check the name of the token
        // assertEq(token.symbol(), "PBT"); // Check the symbol of the token
        // assertEq(token.decimals(), 18); // Check the decimals of the token
        // assertEq(token.balanceOf(address(this)), 1_000_000 * 10 ** 18); // Check if the deployer has the initial supply
    }

    function testBobHasTokens() public view {
        assertEq(token.balanceOf(bob), STARTING_BALALNCE); // Check if Bob has the correct balance
    }

    function testTransferTokens() public {
        uint256 transferAmount = 100_000 * 10 ** 18; // 100,000 tokens with 18 decimals
        vm.prank(bob); // Set the context to Bob
        token.transfer(alice, transferAmount); // Bob transfers tokens to Alice
        assertEq(token.balanceOf(alice), transferAmount); // Check if Alice received the tokens
        assertEq(token.balanceOf(bob), STARTING_BALALNCE - transferAmount); // Check if Bob's balance is updated
    }

    function testAllowanceAndTransferFrom() public {
        uint256 allowanceAmount = 50_000 * 10 ** 18; // 50,000 tokens with 18 decimals
        vm.prank(bob); // Set the context to Bob
        token.approve(address(this), allowanceAmount); // Bob approves the test contract to spend tokens on his behalf
        assertEq(token.allowance(bob, address(this)), allowanceAmount); // Check if the allowance is set correctly

        vm.prank(address(this)); // Set the context to the test contract
        token.transferFrom(bob, alice, allowanceAmount); // Transfer tokens from Bob to Alice
        assertEq(token.balanceOf(alice), allowanceAmount); // Check if Alice received the tokens
        assertEq(token.balanceOf(bob), STARTING_BALALNCE - allowanceAmount); // Check if Bob's balance is updated
    }

    // Test initial token deployment and basic properties
    function testInitialDeployment() public view {
        assertEq(token.totalSupply(), 1_000_000 * 10 ** 18); // Check total supply
        assertEq(token.name(), "PreBuiltToken"); // Check token name
        assertEq(token.symbol(), "PBT"); // Check token symbol
        assertEq(token.decimals(), 18); // Check decimals
        // Check deployer balance (should be total supply minus what was transferred to Bob)
        assertEq(token.balanceOf(msg.sender), 1_000_000 * 10 ** 18 - STARTING_BALALNCE);
    }

    // Test transfer to zero address should fail
    function testTransferToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert(); // Expect the transaction to revert
        token.transfer(address(0), 1000);
    }

    // Test transfer with insufficient balance should fail
    function testTransferInsufficientBalance() public {
        vm.prank(bob);
        vm.expectRevert(); // Expect the transaction to revert
        token.transfer(alice, STARTING_BALALNCE + 1); // Try to transfer more than Bob has
    }

    // Test transfer of zero tokens should work
    function testTransferZeroTokens() public {
        uint256 initialBobBalance = token.balanceOf(bob);
        uint256 initialAliceBalance = token.balanceOf(alice);
        
        vm.prank(bob);
        bool success = token.transfer(alice, 0);
        
        assertTrue(success);
        assertEq(token.balanceOf(bob), initialBobBalance); // Bob's balance unchanged
        assertEq(token.balanceOf(alice), initialAliceBalance); // Alice's balance unchanged
    }

    // Test approval functionality
    function testApproval() public {
        uint256 approvalAmount = 100_000 * 10 ** 18;
        
        vm.prank(bob);
        bool success = token.approve(alice, approvalAmount);
        
        assertTrue(success);
        assertEq(token.allowance(bob, alice), approvalAmount);
    }

    // Test multiple approvals (should overwrite previous approval)
    function testMultipleApprovals() public {
        uint256 firstApproval = 100_000 * 10 ** 18;
        uint256 secondApproval = 200_000 * 10 ** 18;
        
        vm.prank(bob);
        token.approve(alice, firstApproval);
        assertEq(token.allowance(bob, alice), firstApproval);
        
        vm.prank(bob);
        token.approve(alice, secondApproval);
        assertEq(token.allowance(bob, alice), secondApproval); // Should overwrite
    }

    // Test transferFrom without sufficient allowance should fail
    function testTransferFromInsufficientAllowance() public {
        uint256 allowanceAmount = 50_000 * 10 ** 18;
        
        vm.prank(bob);
        token.approve(alice, allowanceAmount);
        
        vm.prank(alice);
        vm.expectRevert(); // Expect the transaction to revert
        token.transferFrom(bob, alice, allowanceAmount + 1); // Try to transfer more than allowed
    }

    // Test transferFrom with zero allowance should fail
    function testTransferFromZeroAllowance() public {
        vm.prank(alice);
        vm.expectRevert(); // Expect the transaction to revert
        token.transferFrom(bob, alice, 1000); // Alice has no allowance from Bob
    }

    // Test transferFrom updates allowance correctly
    function testTransferFromUpdatesAllowance() public {
        uint256 allowanceAmount = 100_000 * 10 ** 18;
        uint256 transferAmount = 30_000 * 10 ** 18;
        
        vm.prank(bob);
        token.approve(alice, allowanceAmount);
        
        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount);
        
        assertEq(token.allowance(bob, alice), allowanceAmount - transferAmount);
    }

    // Test transferFrom to zero address should fail
    function testTransferFromToZeroAddress() public {
        uint256 allowanceAmount = 50_000 * 10 ** 18;
        
        vm.prank(bob);
        token.approve(alice, allowanceAmount);
        
        vm.prank(alice);
        vm.expectRevert(); // Expect the transaction to revert
        token.transferFrom(bob, address(0), allowanceAmount);
    }

    // Test transferFrom with insufficient balance should fail
    function testTransferFromInsufficientBalance() public {
        // Give Alice a huge allowance but Bob doesn't have enough tokens
        uint256 allowanceAmount = 1_000_000_000 * 10 ** 18; // Way more than Bob has
        
        vm.prank(bob);
        token.approve(alice, allowanceAmount);
        
        vm.prank(alice);
        vm.expectRevert(); // Expect the transaction to revert
        token.transferFrom(bob, alice, STARTING_BALALNCE + 1); // More than Bob's balance
    }

    // Test self-transfer
    function testSelfTransfer() public {
        uint256 initialBalance = token.balanceOf(bob);
        uint256 transferAmount = 1000 * 10 ** 18;
        
        vm.prank(bob);
        bool success = token.transfer(bob, transferAmount);
        
        assertTrue(success);
        assertEq(token.balanceOf(bob), initialBalance); // Balance should remain the same
    }

    // Test approve to self
    function testApproveToSelf() public {
        uint256 approvalAmount = 100_000 * 10 ** 18;
        
        vm.prank(bob);
        bool success = token.approve(bob, approvalAmount);
        
        assertTrue(success);
        assertEq(token.allowance(bob, bob), approvalAmount);
    }

    // Test transferFrom to self
    function testTransferFromToSelf() public {
        uint256 allowanceAmount = 50_000 * 10 ** 18;
        uint256 transferAmount = 30_000 * 10 ** 18;
        uint256 initialBalance = token.balanceOf(bob);
        
        vm.prank(bob);
        token.approve(bob, allowanceAmount);
        
        vm.prank(bob);
        bool success = token.transferFrom(bob, bob, transferAmount);
        
        assertTrue(success);
        assertEq(token.balanceOf(bob), initialBalance); // Balance unchanged
        assertEq(token.allowance(bob, bob), allowanceAmount - transferAmount); // Allowance should decrease
    }

    // Test balance queries for non-existent accounts
    function testBalanceOfNonExistentAccount() public {
        address nonExistentAccount = makeAddr("NonExistent");
        assertEq(token.balanceOf(nonExistentAccount), 0);
    }

    // Test allowance queries for non-existent approvals
    function testAllowanceOfNonExistentApproval() public {
        address randomAccount = makeAddr("Random");
        assertEq(token.allowance(bob, randomAccount), 0);
        assertEq(token.allowance(randomAccount, bob), 0);
    }

    // Test multiple transfers in sequence
    function testMultipleTransfers() public {
        uint256 transferAmount = 10_000 * 10 ** 18;
        
        // Bob -> Alice
        vm.prank(bob);
        token.transfer(alice, transferAmount);
        
        // Alice -> Bob
        vm.prank(alice);
        token.transfer(bob, transferAmount / 2);
        
        assertEq(token.balanceOf(alice), transferAmount / 2);
        assertEq(token.balanceOf(bob), STARTING_BALALNCE - (transferAmount / 2));
    }

    // Test large number handling
    function testLargeNumbers() public {
        uint256 largeAmount = type(uint256).max / 2; // Very large but safe number
        
        // This should fail because Bob doesn't have enough tokens
        vm.prank(bob);
        vm.expectRevert();
        token.transfer(alice, largeAmount);
    }

    // Test approve with zero amount (should clear allowance)
    function testApproveZeroAmount() public {
        uint256 initialApproval = 100_000 * 10 ** 18;
        
        // Set initial approval
        vm.prank(bob);
        token.approve(alice, initialApproval);
        assertEq(token.allowance(bob, alice), initialApproval);
        
        // Clear approval
        vm.prank(bob);
        token.approve(alice, 0);
        assertEq(token.allowance(bob, alice), 0);
    }

    // Test event emissions (if you want to test events)
    function testTransferEvent() public {
        uint256 transferAmount = 1000 * 10 ** 18;
        
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, transferAmount);
        token.transfer(alice, transferAmount);
    }

    function testApprovalEvent() public {
        uint256 approvalAmount = 1000 * 10 ** 18;
        
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, approvalAmount);
        token.approve(alice, approvalAmount);
    }

    // Events (need to be declared to test them)
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
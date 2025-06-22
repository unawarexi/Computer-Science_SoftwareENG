// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// Import Test utilities from Foundry
import {Test, console} from "forge-std/Test.sol";
// Import the FundMe contract to test
import {FundMe} from "../src/FundMe.sol";

// Minimal mock for Chainlink AggregatorV3Interface
contract MockV3Aggregator {
    uint8 public decimals = 8;
    int256 public answer;
    uint256 public version = 1;

    constructor(int256 _answer) {
        answer = _answer;
    }

    function latestRoundData()
        external
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        // Return dummy data, only answer is relevant for price
        return (0, answer, 0, 0, 0);
    }
}

contract FundMeTest is Test {
    FundMe fundMe;
    MockV3Aggregator mockPriceFeed;
    address OWNER = address(0xABCD);
    address USER = address(0xBEEF);

    // This runs before each test
    function setUp() external {
        // Deploy a mock price feed with a price of $2000 (scaled to 8 decimals)
        mockPriceFeed = new MockV3Aggregator(2000e8);
        // Deploy FundMe contract, setting OWNER as the deployer
        vm.prank(OWNER);
        fundMe = new FundMe(address(mockPriceFeed));
    }

    // Test that the minimum USD constant is correct
    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Test that the owner is set correctly
    function testOwnerIsDeployer() public view {
        assertEq(fundMe.getOwner(), OWNER);
    }

    // Test funding with enough ETH succeeds and updates mapping
    function testFundUpdatesFunderData() public {
        // Calculate minimum ETH needed to pass the USD check
        uint256 minEth = (fundMe.MINIMUM_USD() * 1e18) / 2000e8;
        vm.deal(USER, 10 ether); // Give USER some ETH
        vm.prank(USER); // Next call is from USER
        fundMe.fund{value: minEth}();
        // Check that mapping is updated
        assertEq(fundMe.getAddressToAmountFunded(USER), minEth);
        // Check that USER is added to funders array
        assertEq(fundMe.getFunder(0), USER);
    }

    // Test funding with not enough ETH reverts
    function testFundFailsIfNotEnoughEth() public {
        vm.deal(USER, 1 ether);
        vm.prank(USER);
        // Should revert with error message
        vm.expectRevert(bytes("You need to spend more ETH!"));
        fundMe.fund{value: 1}();
    }

    // Test only owner can withdraw
    function testOnlyOwnerCanWithdraw() public {
        // Fund contract first
        uint256 minEth = (fundMe.MINIMUM_USD() * 1e18) / 2000e8;
        vm.deal(USER, 10 ether);
        vm.prank(USER);
        fundMe.fund{value: minEth}();

        // Try to withdraw as USER (should revert)
        vm.prank(USER);
        vm.expectRevert(); // Custom error, so no message needed
        fundMe.withdraw();

        // Withdraw as OWNER (should succeed)
        vm.prank(OWNER);
        fundMe.withdraw();
        // After withdraw, mapping should be reset
        assertEq(fundMe.getAddressToAmountFunded(USER), 0);
    }

    // Test cheaperWithdraw resets funders and mapping
    function testCheaperWithdrawWorks() public {
        uint256 minEth = (fundMe.MINIMUM_USD() * 1e18) / 2000e8;
        vm.deal(USER, 10 ether);
        vm.prank(USER);
        fundMe.fund{value: minEth}();

        vm.prank(OWNER);
        fundMe.cheaperWithdraw();
        // Mapping and funders array should be reset
        assertEq(fundMe.getAddressToAmountFunded(USER), 0);
        // Funders array is private, but getFunder(0) should now revert
        vm.expectRevert();
        fundMe.getFunder(0);
    }

    // Test getPriceFeed returns the correct address
    function testGetPriceFeedReturnsCorrectAddress() public view {
        assertEq(address(fundMe.getPriceFeed()), address(mockPriceFeed));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title RebaseToken
 * @author Dr.Dre
 * @notice This is a cross-chain rebase token that incentivizes users to deposit into a vault and gain interest as rewards.
 * @dev The interest rate can only decrease, never increase.
 */
contract RebaseToken is ERC20Burnable {
    // ------------------------------ Errors ------------------------------

    /// @notice Thrown when attempting to increase the interest rate
    error RebaseToken_InterestRateCanOnlyDecrease(
        uint256 attempted,
        uint256 current
    );
    error RebaseToken_InterestRateCannotBeZero();
    error RebaseToken_MintToZeroAddress();

    // ------------------------------ State Variables ------------------------------

    // Global interest rate (scaled by INTEREST_RATE_PRECISION for accuracy)
    uint256 private s_interestRate = 5e10;

    uint256 private constant INTEREST_RATE_PRECISION = 1e10;
    uint256 private constant SECONDS_IN_YEAR = 365 days;

    mapping(address => uint256) private s_userInterestRate;
    mapping(address => uint256) private s_userLastRebaseTimestamp;

    // ------------------------------ Events ------------------------------

    /// @notice Emitted when a new (lower) interest rate is set
    event InterestRateSet(uint256 newInterestRate);

    // ------------------------------ Constructor ------------------------------

    constructor() ERC20("RebaseToken", "RBT") {
        // Initialize the ERC20 token with a name and symbol
    }

    // ------------------------------ External Functions ------------------------------

    /**
     * @notice Updates the global interest rate
     * @dev This function only allows decreasing the interest rate.
     *      Any attempt to increase it will result in a revert.
     * @param _newInterestRate The new interest rate to be set (must be <= current)
     */
    function setInterestRate(uint256 _newInterestRate) external {
        if (_newInterestRate > s_interestRate) {
            revert RebaseToken_InterestRateCanOnlyDecrease(
                _newInterestRate,
                s_interestRate
            );
        }

        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    /**
     * @notice Returns the current global interest rate
     */
    function getInterestRate() external view returns (uint256) {
        return s_interestRate;
    }

    /**
     * @notice Returns the interest rate for a specific user
     * @param _user The address of the user
     */
    function getUserInterestRate( address _user) external view returns (uint256) {
        return s_userInterestRate[_user];
    }


    /**
     * @notice Returns the user's balance with accrued interest
     * @param account The address to query balance for
     */
    function balanceOf(address account) public view override returns (uint256) {
        uint256 lastRebaseTimestamp = s_userLastRebaseTimestamp[account];

        if (lastRebaseTimestamp == 0) {
            return super.balanceOf(account); // No interest accrued yet
        }

        uint256 timeElapsed = block.timestamp - lastRebaseTimestamp;
        uint256 baseBalance = super.balanceOf(account);

        uint256 interest = (baseBalance * s_interestRate * timeElapsed) /
            INTEREST_RATE_PRECISION /
            SECONDS_IN_YEAR;

        return baseBalance + interest;
    }

    /**
     * @notice Internal function to mint accrued interest for a user
     * @param _user The address to mint interest for
     */
    function _mintAccruedInterest(address _user) internal {
        uint256 lastRebaseTimestamp = s_userLastRebaseTimestamp[_user];

        if (lastRebaseTimestamp == 0) {
            s_userLastRebaseTimestamp[_user] = block.timestamp;
            return;
        }

        uint256 timeElapsed = block.timestamp - lastRebaseTimestamp;
        uint256 baseBalance = super.balanceOf(_user);

        uint256 interest = (baseBalance *
            s_userInterestRate[_user] *
            timeElapsed) /
            INTEREST_RATE_PRECISION /
            SECONDS_IN_YEAR;

        if (interest > 0) {
            _mint(_user, interest);
        }

        // Update timestamp and sync interest rate
        s_userLastRebaseTimestamp[_user] = block.timestamp;
        s_userInterestRate[_user] = s_interestRate;
    }

    // ------------------------------ Minting Functionality ------------------------------

    /**
     * @notice Mints new tokens to a specified address and sets the user's interest rate
     * @param _to The address to mint tokens to
     * @param _amount The amount of tokens to mint
     * @dev This function sets the user's interest rate to the current global interest rate
     *      and mints the specified amount of tokens to the given address.
     *      It is assumed that the caller has the necessary permissions to mint tokens.
     */
    function mint(address _to, uint256 _amount) external {
        if (_to != address(0)) {
            revert RebaseToken_MintToZeroAddress();
        }
        if (_amount > 0) {
            revert RebaseToken_InterestRateCannotBeZero();
        }
        _mintAccruedInterest(_to); // Mint any accrued interest before minting new tokens
        _mint(_to, _amount); // Mint new tokens
    }
}

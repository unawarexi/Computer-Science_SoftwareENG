// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title RebaseToken
 * @author Dr.Dre
 * @notice This is a cross-chain rebase token that incentivizes users to deposit into a vault and gain interest as rewards.
 * @dev The interest rate can only decrease, never increase.
 */
contract RebaseToken is ERC20Burnable, Ownable, AccessControl {
    // ------------------------------ Errors ------------------------------

    /// @notice Thrown when attempting to increase the interest rate
    error RebaseToken_InterestRateCanOnlyDecrease(
        uint256 currentInterestRate,
        uint256 newInterestRate
    );
    error RebaseToken_InterestRateCannotBeZero();
    error RebaseToken_MintToZeroAddress();
    error RebaseToken_AmountCannotBeZero();
    error RebaseToken_InsufficientBalance();

    // ------------------------------ State Variables ------------------------------

    // Global interest rate (scaled by INTEREST_RATE_PRECISION for accuracy)
    uint256 private constant INTEREST_RATE_PRECISION = 1e27;
    uint256 private s_interestRate = (5 * INTEREST_RATE_PRECISION ) / 1e8; // 5% annual rate (adjusted for 1e18 precision)
    uint256 private constant SECONDS_IN_YEAR = 365 days;
    bytes32 public constant MINT_AND_BURN_ROLE = keccak256("MINT_AND_BURN_ROLE");
    
    mapping(address => uint256) private s_userInterestRate;
    mapping(address => uint256) private s_userLastRebaseTimestamp;

    // ------------------------------ Events ------------------------------

    /// @notice Emitted when a new (lower) interest rate is set
    event InterestRateSet(uint256 newInterestRate);

    // ------------------------------ Constructor ------------------------------

    constructor() ERC20("RebaseToken", "RBT") {
        // Initialize the ERC20 token with a name and symbol
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINT_AND_BURN_ROLE, msg.sender);
    }

    /**
     * @notice Grants mint and burn role to an account
     * @param _account The account to grant the role to
     */
    function grantMintAndBurnRole(address _account) external onlyOwner { 
        _grantRole(MINT_AND_BURN_ROLE, _account);
    }

    /**
     * @notice Revokes mint and burn role from an account
     * @param _account The account to revoke the role from
     */
    function revokeMintAndBurnRole(address _account) external onlyOwner {
        _revokeRole(MINT_AND_BURN_ROLE, _account);
    }

    // ------------------------------ External Functions ------------------------------

    /**
     * @notice Updates the global interest rate
     * @dev This function only allows decreasing the interest rate.
     *      Any attempt to increase it will result in a revert.
     * @param _newInterestRate The new interest rate to be set (must be <= current)
     */
    function setInterestRate(uint256 _newInterestRate) external onlyOwner {
        if (_newInterestRate == 0) {
            revert RebaseToken_InterestRateCannotBeZero();
        }
        
        if (_newInterestRate > s_interestRate) {
            revert RebaseToken_InterestRateCanOnlyDecrease(
                s_interestRate, _newInterestRate
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
    function getUserInterestRate(address _user) external view returns (uint256) {
        return s_userInterestRate[_user];
    }



    /**
     * @notice Returns the balance of a user, including accrued interest
     * @param account The address of the user
     * @return The total balance of the user, including accrued interest
     */
    function balanceOf(address account) public view override returns (uint256) {
        uint256 accumulatedInterest = _calculateAccruedInterest(account);
        return super.balanceOf(account) + accumulatedInterest;
    }


    /**
     * @notice Transfers tokens from the caller to a specified address
     * @param _recipient The address to transfer tokens to
     * @param _amount The amount of tokens to transfer
     * @return A boolean indicating success
     */
    function transfer(address _recipient, uint256 _amount) public override returns (bool) {
        if (_amount == type(uint256).max) {
            _amount = balanceOf(msg.sender);
        }
        
        _mintAccruedInterest(msg.sender); // Mint any accrued interest before transferring
        _mintAccruedInterest(_recipient); // Mint any accrued interest for the recipient
        
        // Initialize recipient if they don't have tokens yet
        if (super.balanceOf(_recipient) == 0) {
            s_userInterestRate[_recipient] = s_interestRate;
            s_userLastRebaseTimestamp[_recipient] = block.timestamp;
        }
        
        return super.transfer(_recipient, _amount);
    }



    /**
     * @notice Transfers tokens from one address to another on behalf of the owner
     * @param _sender The address from which to transfer tokens
     * @param _recipient The address to transfer tokens to
     * @param _amount The amount of tokens to transfer
     * @return A boolean indicating success
     */
    function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
        _mintAccruedInterest(_sender); // Mint any accrued interest for the sender
        _mintAccruedInterest(_recipient); // Mint any accrued interest for the recipient
        
        if (balanceOf(_sender) < _amount) {
            revert RebaseToken_InsufficientBalance();
        }

        // Initialize recipient if they don't have tokens yet
        if (super.balanceOf(_recipient) == 0) {
            s_userInterestRate[_recipient] = s_userInterestRate[_sender]; // Set interest rate from sender
            s_userLastRebaseTimestamp[_recipient] = block.timestamp; // Initialize last rebase timestamp
        }
        
        return super.transferFrom(_sender, _recipient, _amount);
    }



    /**
     * @notice Burns a specified amount of tokens from a specified address
     * @param _value The amount of tokens to burn
     * @param _from The address to burn tokens from
     * @dev This function allows authorized users to burn tokens from any address.
     */
    function burnFrom(uint256 _value, address _from) public onlyRole(MINT_AND_BURN_ROLE) {
        _mintAccruedInterest(_from); // Mint any accrued interest before burning
        _burn(_from, _value); // Burn the specified amount of tokens from the address
    }



    /**
     * @notice Mints new tokens to a specified address and sets the user's interest rate
     * @param _to The address to mint tokens to
     * @param _amount The amount of tokens to mint
     * @param _userInterestRate The interest rate to set for the user
     * @dev This function sets the user's interest rate to the specified value
     *      and mints the specified amount of tokens to the given address.
     */
    function mint(address _to, uint256 _amount, uint256 _userInterestRate) public onlyRole(MINT_AND_BURN_ROLE) {
        if (_to == address(0)) {
            revert RebaseToken_MintToZeroAddress();
        }
        if (_amount == 0) {
            revert RebaseToken_AmountCannotBeZero();
        }
        
        _mintAccruedInterest(_to); // Mint any accrued interest before minting new tokens
        
        // Sets the users interest rate to either their bridged value if they are bridging or to the current interest rate if they are depositing.
        s_userInterestRate[_to] = _userInterestRate;
        s_userLastRebaseTimestamp[_to] = block.timestamp;
        
        _mint(_to, _amount); // Mint new tokens
    }



    /**
     * @notice Simple mint function that uses current global interest rate
     * @param _to The address to mint tokens to
     * @param _amount The amount of tokens to mint
     */
    function mintWithCurrentRate(address _to, uint256 _amount) external onlyRole(MINT_AND_BURN_ROLE) {
        mint(_to, _amount, s_interestRate);
    }



    // ------------------------------ Internal Functions ------------------------------

    /**
     * @notice Calculates the accumulated interest for a user
     * @param _user The address of the user
     * @return The amount of interest accrued by the user
     */
    function _calculateAccruedInterest(address _user) internal view returns (uint256) {
        uint256 lastRebaseTimestamp = s_userLastRebaseTimestamp[_user];
        if (lastRebaseTimestamp == 0 || s_userInterestRate[_user] == 0) {
            return 0; // No interest accrued yet or no interest rate set
        }

        uint256 timeElapsed = block.timestamp - lastRebaseTimestamp;
        uint256 baseBalance = super.balanceOf(_user);

        if (baseBalance == 0 || timeElapsed == 0) {
            return 0;
        }

        uint256 interest = (baseBalance * s_userInterestRate[_user] * timeElapsed) /
            INTEREST_RATE_PRECISION /
            SECONDS_IN_YEAR;

        return interest;
    }

    /**
     * @notice Internal function to mint accrued interest for a user
     * @param _user The address to mint interest for
     */
    function _mintAccruedInterest(address _user) internal {
        uint256 lastRebaseTimestamp = s_userLastRebaseTimestamp[_user];

        if (lastRebaseTimestamp == 0) {
            s_userLastRebaseTimestamp[_user] = block.timestamp;
            if (s_userInterestRate[_user] == 0) {
                s_userInterestRate[_user] = s_interestRate;
            }
            return;
        }

        uint256 interest = _calculateAccruedInterest(_user);

        if (interest > 0) {
            _mint(_user, interest);
        }

        // Update timestamp but don't overwrite user's existing interest rate
        s_userLastRebaseTimestamp[_user] = block.timestamp;
    }
}
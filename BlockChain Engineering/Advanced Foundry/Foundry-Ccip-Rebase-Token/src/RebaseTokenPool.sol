// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {TokenPool} from "@ccip/contracts/src/v0.8/ccip/pools/TokenPool.sol";
import {IERC20} from "@ccip/contracts/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {Pool} from "@ccip/contracts/src/v0.8/ccip/libraries/Pool.sol";
import {IRebaseToken} from "./interfaces/IRebaseToken.sol";

/**
 * @title RebaseTokenPool
 * @notice CCIP token pool for cross-chain transfers of RebaseToken
 * @dev This pool handles burning on source chain and minting on destination chain
 *      while preserving user interest rates across chains
 */
contract RebaseTokenPool is TokenPool {
    
    // Events for better observability
    event TokensBurned(address indexed user, uint256 amount, uint256 userInterestRate);
    event TokensMinted(address indexed user, uint256 amount, uint256 userInterestRate);

    constructor(
        IERC20 _token,
        address[] memory _allowlist,
        address _rmnProxy, 
        address _router
    ) TokenPool(_token, 18, _allowlist, _rmnProxy, _router) {}

    /**
     * @notice Burns tokens on the source chain before cross-chain transfer
     * @param lockOrBurnIn The lock or burn parameters
     * @return lockOrBurnOut The result containing destination token address and pool data
     */
    function lockOrBurn(Pool.LockOrBurnInV1 calldata lockOrBurnIn) external override returns (Pool.LockOrBurnOutV1 memory lockOrBurnOut) {
        _validateLockOrBurn(lockOrBurnIn);
        
        // Get the original sender's interest rate before burning
        uint256 userInterestRate = IRebaseToken(address(i_token)).getUserInterestRate(lockOrBurnIn.originalSender);
        
        // Burn tokens from the original sender (not from the pool contract)
        IRebaseToken(address(i_token)).burnFrom(lockOrBurnIn.amount, lockOrBurnIn.originalSender);
        
        // Emit event for tracking
        emit TokensBurned(lockOrBurnIn.originalSender, lockOrBurnIn.amount, userInterestRate);
        
        lockOrBurnOut = Pool.LockOrBurnOutV1({
            destTokenAddress: getRemoteToken(lockOrBurnIn.remoteChainSelector),
            destPoolData: abi.encode(userInterestRate)
        });
    }

    /**
     * @notice Mints tokens on the destination chain after cross-chain transfer
     * @param releaseOrMintIn The release or mint parameters
     * @return The result containing the destination amount
     */
    function releaseOrMint(Pool.ReleaseOrMintInV1 calldata releaseOrMintIn) external override returns (Pool.ReleaseOrMintOutV1 memory) {
        _validateReleaseOrMint(releaseOrMintIn);
        
        // Decode the user's original interest rate from source chain
        uint256 userInterestRate = abi.decode(releaseOrMintIn.sourcePoolData, (uint256));
        
        // Mint tokens to the receiver with their original interest rate
        IRebaseToken(address(i_token)).mint(
            releaseOrMintIn.receiver, 
            releaseOrMintIn.amount, 
            userInterestRate
        );
        
        // Emit event for tracking
        emit TokensMinted(releaseOrMintIn.receiver, releaseOrMintIn.amount, userInterestRate);

        return Pool.ReleaseOrMintOutV1({
            destinationAmount: releaseOrMintIn.amount
        });
    }
}
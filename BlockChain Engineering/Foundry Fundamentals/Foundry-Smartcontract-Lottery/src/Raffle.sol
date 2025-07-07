// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Raffle {

    error Raffle_NotEnoughETH(uint256 sent, uint256 required);


    address payable[] private s_players;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;

    event Raffle_Entered(address indexed player, uint256 amount);


    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp; // Initialize the last timestamp to the current block timestamp
    }
    // Function to enter the raffle
    // The function requires a minimum amount of ETH to be sent with the transaction
    function enterRaffle() public payable {
        // require(
        //     msg.value >= i_entranceFee,
        //     "Not enough ETH to enter the raffle"
        // );
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughETH(msg.value, i_entranceFee);
        }
        s_players.push(payable(msg.sender));
        emit Raffle_Entered(msg.sender, msg.value);
    }

    function pickWinner() external view {
        // Check if enough time has passed since the last winner was picked
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert("Not enough time has passed since the last winner was picked");
        }
        
    }

    // View functions to retrieve information about the raffle
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    // Functions to retrieve player information
    function getPlayer(uint256 index) public view returns (address) {}

    // Returns the list of players in the raffle
    function getPlayers() public view returns (address[] memory) {}

    // Returns the number of players in the raffle
    function getNumberOfPlayers() public view returns (uint256) {}
}

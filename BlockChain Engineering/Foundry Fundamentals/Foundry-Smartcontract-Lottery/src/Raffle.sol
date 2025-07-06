// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Raffle {
    address[] private players;
    uint256 private immutable i_entranceFee;

    error NotEnoughETH(uint256 sent, uint256 required);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require(
        //     msg.value >= i_entranceFee,
        //     "Not enough ETH to enter the raffle"
        // );
        if (msg.value < i_entranceFee) {
            revert NotEnoughETH(msg.value, i_entranceFee);
        }
        players.push(msg.sender);
    }

    function pickWinner() public {}

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

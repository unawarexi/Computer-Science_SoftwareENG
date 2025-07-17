// SPDX-License-Identifier:MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";



contract BasicNft is ERC721{
    unit256 private s_tokenCounter;
    constructor()  ERC721("Doggie", "DOG"){
        s_tokenCounter = 0;
        
    }


    function mintNft() public returns(uint256){
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
        return s_tokenCounter - 1;
    }

    function tokenURI(uint256 tokenId) public view returns(string memory){
        require(_exists(tokenId), "Token does not exist");
        return "ipfs://QmXnnyufdzAWLxk1b2d3Z5z5z5z5z5z5z5z5z5z5z5z5z";
    }
}
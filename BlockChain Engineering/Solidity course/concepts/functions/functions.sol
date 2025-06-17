// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentFunctions {
    string public studentName;
    uint public age;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not allowed");
        _;
    }

    // Visibility examples
    function publicFunc() public pure returns (string memory) {
        return "Public";
    }
    function externalFunc() external pure returns (string memory) {
        return "External";
    }
    function internalFunc() internal pure returns (string memory) {
        return "Internal";
    }
    function privateFunc() private pure returns (string memory) {
        return "Private";
    }

    // State mutability examples
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
    function receiveEther() public payable {}

    // Parameters and return values
    function setStudent(string memory _name, uint _age) public onlyOwner {
        studentName = _name;
        age = _age;
    }
    function getStudent() public view returns (string memory, uint) {
        return (studentName, age);
    }
    function isAdult() public view returns (bool) {
        return age >= 18;
    }

    // Multiple returns
    uint public id = 1;
    function getData() public view returns (uint, string memory) {
        return (id, studentName);
    }

    // Named return variables
    function getInfo() public view returns (uint _age, string memory _name) {
        _age = age;
        _name = studentName;
    }

    // Modifiers in use
    function secureFunction() public onlyOwner {
        // protected logic
    }

    // Internal function calls
    function total() public view returns (uint) {
        return addInternal(5, 10);
    }
    function addInternal(uint x, uint y) internal pure returns (uint) {
        return x + y;
    }

    // Fallback & receive functions
    receive() external payable {}
    fallback() external payable {}

    // Function overloading
    function set(uint _id) public onlyOwner {
        id = _id;
    }
    function set(string memory _name) public onlyOwner {
        studentName = _name;
    }
}
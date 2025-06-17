// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataExamples {
    // Array
    string[] public names;

    // Mapping
    mapping(address => uint) public balances;

    // Struct
    struct Book {
        string title;
        string author;
    }
    Book[] public library;

    // Enum
    enum State { Waiting, Active, Completed }
    State public currentState;

    function addName(string memory name) public {
        names.push(name);
    }

    function setBalance(uint amount) public {
        balances[msg.sender] = amount;
    }

    function addBook(string memory _title, string memory _author) public {
        library.push(Book(_title, _author));
    }

    function activate() public {
        currentState = State.Active;
    }
}
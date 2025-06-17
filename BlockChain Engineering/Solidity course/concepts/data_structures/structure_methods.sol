// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructureMethodsDemo {
    // --- Array Methods ---
    uint[] public numbers;

    function addNumber(uint x) public {
        numbers.push(x);
    }

    function removeLastNumber() public {
        require(numbers.length > 0, "Empty array");
        numbers.pop();
    }

    function getNumberAt(uint idx) public view returns (uint) {
        require(idx < numbers.length, "Out of bounds");
        return numbers[idx];
    }

    function updateNumberAt(uint idx, uint newValue) public {
        require(idx < numbers.length, "Out of bounds");
        numbers[idx] = newValue;
    }

    function getNumbersLength() public view returns (uint) {
        return numbers.length;
    }

    function sumNumbers() public view returns (uint sum) {
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
    }

    // --- Fixed-size Array Methods ---
    uint[3] public fixedArr = [1, 2, 3];

    function setFixedAt(uint idx, uint val) public {
        require(idx < fixedArr.length, "Out of bounds");
        fixedArr[idx] = val;
    }

    function getFixedAt(uint idx) public view returns (uint) {
        require(idx < fixedArr.length, "Out of bounds");
        return fixedArr[idx];
    }

    // --- Struct Methods ---
    struct Student {
        string name;
        uint age;
        uint score;
    }

    Student public student;
    Student[] public students;

    function setStudent(string memory _name, uint _age, uint _score) public {
        student = Student(_name, _age, _score);
    }

    function addStudent(string memory _name, uint _age, uint _score) public {
        students.push(Student(_name, _age, _score));
    }

    function getStudentAt(uint idx) public view returns (string memory, uint, uint) {
        require(idx < students.length, "Out of bounds");
        Student storage s = students[idx];
        return (s.name, s.age, s.score);
    }

    function updateStudentScore(uint idx, uint newScore) public {
        require(idx < students.length, "Out of bounds");
        students[idx].score = newScore;
    }

    // --- Mapping Methods ---
    mapping(address => uint) public balances;

    function setBalance(address user, uint amount) public {
        balances[user] = amount;
    }

    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    function increaseBalance(address user, uint amount) public {
        balances[user] += amount;
    }

    function decreaseBalance(address user, uint amount) public {
        require(balances[user] >= amount, "Insufficient balance");
        balances[user] -= amount;
    }

    // --- Nested Mapping Methods ---
    mapping(address => mapping(uint => bool)) public userFlags;

    function setUserFlag(address user, uint flag, bool value) public {
        userFlags[user][flag] = value;
    }

    function getUserFlag(address user, uint flag) public view returns (bool) {
        return userFlags[user][flag];
    }

    // --- Enum Methods ---
    enum Status { Pending, Approved, Rejected }
    Status public status = Status.Pending;

    function setStatus(Status _status) public {
        status = _status;
    }

    function approve() public {
        status = Status.Approved;
    }

    function reject() public {
        status = Status.Rejected;
    }

    function isApproved() public view returns (bool) {
        return status == Status.Approved;
    }

    // --- Multidimensional Array Methods ---
    uint[][] public matrix;

    function addRow(uint[] memory row) public {
        matrix.push(row);
    }

    function getRow(uint idx) public view returns (uint[] memory) {
        require(idx < matrix.length, "Out of bounds");
        return matrix[idx];
    }

    function addToMatrix(uint rowIdx, uint value) public {
        require(rowIdx < matrix.length, "Row out of bounds");
        matrix[rowIdx].push(value);
    }

    // --- Utility: Clear All Dynamic Array ---
    function clearNumbers() public {
        delete numbers;
    }

    // --- Utility: Reset Struct Array ---
    function clearStudents() public {
        delete students;
    }
}

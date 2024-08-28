// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Score {
    mapping(address => uint8) public scores;
    address public teacher;

    constructor(address _teacher){
        teacher = _teacher;
    }

    modifier onlyTeacher() {
        require (msg.sender == teacher, "You are not the teacher");
        _;
    }

    function modifyScore(address student, uint8 score) external onlyTeacher {
        require(score <= 100, "score > 100");
        scores[student] = score;
    }
    
}

interface IScore {
    function modifyScore(address student, uint8 score) external;
}

contract Teacher {
    IScore public scoreAddress;

    function setScoreAddress(IScore _score) public {
        scoreAddress = _score;
    }

    function modifyScore(address student, uint8 score) public {
        scoreAddress.modifyScore(student, score);
    }
    
}


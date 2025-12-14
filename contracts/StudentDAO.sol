// SPDX-License-Identifier
pragma solidity ^0.8.0;

contract StudentDAO {
    // 紀錄每個學生的餘額
    mapping(address => uint256) public balances;

    // 存錢 (Deposit)
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    // 取錢 (Withdraw) - 這裡含有重入漏洞！
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // 錯誤發生點 
        // 1. Interaction (互動): 先把錢轉出去
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        // 2. Effect (更新狀態): 錢轉完才扣除餘額
        balances[msg.sender] = 0;
    }

    // 查詢合約總餘額
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
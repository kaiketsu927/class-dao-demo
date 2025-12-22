// SPDX-License-Identifier: MIT
// 1222更新
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
    // 真正安全的實作邏輯: Check - Effect - Interact
    function withdraw() public {
        // 1.檢查餘額(check)
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        // 錯誤發生點 
        // 2. Interaction (互動): 先把錢轉出去
        // sent接到true或false // .call()把所有gas傳給sender

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        // 3. Effect (更新狀態, effect): 錢轉完才扣除餘額
        balances[msg.sender] = 0;
    }

    // 查詢合約總餘額
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
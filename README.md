# Class DAO Security Demo (Reentrancy Attack)

這是為了區塊鏈課程期末專案製作的 DAO 安全演示。
本專案包含一個有漏洞的 DAO 合約 (`StudentDAO`) 以及一個攻擊者合約 (`MaliciousStudent`)，並使用 TypeScript 腳本模擬攻擊過程。

## 專案內容
* **StudentDAO.sol**: 模擬班級金庫，含有 Reentrancy 漏洞 (Checks-Effects-Interactions 順序錯誤)。
* **MaliciousStudent.sol**: 攻擊者合約，利用 `receive()` 函數進行遞迴提款。
* **attack.ts**: 自動化演示腳本。

## 如何執行

1. 安裝依賴
\`\`\`bash
npm install
\`\`\`

2. 執行攻擊演示
\`\`\`bash
npx hardhat run scripts/attack.ts
\`\`\`
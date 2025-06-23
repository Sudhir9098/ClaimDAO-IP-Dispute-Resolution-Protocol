const hre = require("hardhat");

async function main() {
  const ClaimDAO = await hre.ethers.getContractFactory("ClaimDAO");
  const claimDAO = await ClaimDAO.deploy();

  await claimDAO.deployed();
  console.log("ClaimDAO contract deployed to:", claimDAO.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}); 

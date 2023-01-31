import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const SharkPunks = await ethers.getContractFactory("SharkPunks");
  const sharkPunks = await SharkPunks.deploy();

  await sharkPunks.deployed();

  console.log("SharkPunks deployed to:", sharkPunks.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

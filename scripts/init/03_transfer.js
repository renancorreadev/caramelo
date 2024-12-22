/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable import/first */
require('dotenv').config();
import { ethers } from 'hardhat';

async function transferTokens(preSaleAddress) {
  const provider = new ethers.JsonRpcProvider('http://localhost:8545');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const Caramelo = await ethers.getContractFactory('Caramelo', wallet);
  const caramelo = Caramelo.attach(process.env.CARAMELO_ADDRESS);

  console.log('Transferindo tokens para o contrato PreSale...');
  const tokensToTransfer = ethers.parseUnits('84000000000', 6);
  const tx = await caramelo.transfer(preSaleAddress, tokensToTransfer);
  await tx.wait();
  console.log('Tokens transferidos com sucesso para o contrato PreSale.');
}

const preSaleAddress = process.env.PRE_SALE_ADDRESS;
transferTokens(preSaleAddress).catch((err) => console.error(err));

/* eslint-disable @typescript-eslint/no-var-requires */
require('dotenv').config();
const { ethers } = require('hardhat');

async function initializePreSale(preSaleAddress) {
  // Conectar ao RPC com sua chave privada
  const provider = new ethers.JsonRpcProvider('http://localhost:8545');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Conectar ao contrato CarameloPreSale
  const CarameloPreSale = await ethers.getContractFactory(
    'CarameloPreSale',
    wallet
  );
  const carameloPreSale = CarameloPreSale.attach(preSaleAddress);

  console.log('Inicializando a pré-venda...');
  const tx = await carameloPreSale.initializePreSale();
  await tx.wait();
  console.log('Pré-venda inicializada com sucesso!');
}

const preSaleAddress = process.env.PRE_SALE_ADDRESS;

initializePreSale(preSaleAddress).catch((err) => {
  console.error('Erro ao inicializar a pré-venda:', err);
});

/* eslint-disable @typescript-eslint/no-var-requires */
import { ethers } from 'hardhat';
require('dotenv').config();

async function addMultipleToWhitelist(ownerAddress, whitelistAddresses) {
  // Conectar ao RPC com sua chave privada
  const provider = new ethers.JsonRpcProvider('http://localhost:8545');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Conectar ao contrato CarameloPreSale
  const CarameloPreSale = await ethers.getContractFactory(
    'CarameloPreSale',
    wallet
  );
  const carameloPreSale = CarameloPreSale.attach(process.env.PRE_SALE_ADDRESS);

  console.log('Adicionando múltiplos endereços à whitelist...');

  if (wallet.address.toLowerCase() !== ownerAddress.toLowerCase()) {
    throw new Error(
      'Chave privada não corresponde ao endereço do proprietário.'
    );
  }

  // Adicionar os endereços à whitelist
  const tx = await carameloPreSale.addMultipleToWhitelist(whitelistAddresses);
  await tx.wait();

  console.log('Endereços adicionados à whitelist com sucesso:');
  whitelistAddresses.forEach((address, index) => {
    console.log(`Investor ${index + 1}: ${address}`);
  });
}

// Endereço do proprietário e endereços da whitelist
const ownerAddress = process.env.OWNER_ADDRESS;
const whitelistAddresses = [
  '0x0000000000000000000000000000000000000001',
  '0x0000000000000000000000000000000000000002',
];

// Executar o script
addMultipleToWhitelist(ownerAddress, whitelistAddresses).catch((err) => {
  console.error('Erro ao adicionar endereços à whitelist:', err);
});

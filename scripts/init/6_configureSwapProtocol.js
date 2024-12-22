/* eslint-disable @typescript-eslint/no-var-requires */
require('dotenv').config();
const { ethers } = require('hardhat');

async function configureSwapProtocol(ownerAddress, routerAddress) {
  // Conectar ao RPC com sua chave privada
  const provider = new ethers.JsonRpcProvider('http://localhost:8545');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Conectar ao contrato Caramelo
  const Caramelo = await ethers.getContractFactory('Caramelo', wallet);
  const caramelo = Caramelo.attach(process.env.CARAMELO_ADDRESS);

  console.log('Configurando Swap Protocol...');

  if (wallet.address.toLowerCase() !== ownerAddress.toLowerCase()) {
    throw new Error(
      'Chave privada não corresponde ao endereço do proprietário.'
    );
  }

  const tx = await caramelo.configureSwapProtocol(routerAddress);
  await tx.wait();

  console.log(
    `Swap Protocol configurado com sucesso para o router: ${routerAddress}`
  );
}

const ownerAddress = process.env.OWNER_ADDRESS;
const routerAddress = process.env.ROUTER_ADDRESS;

configureSwapProtocol(ownerAddress, routerAddress).catch((err) => {
  console.error('Erro ao configurar Swap Protocol:', err);
});

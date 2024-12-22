/* eslint-disable @typescript-eslint/no-var-requires */
const { JsonRpcProvider, Wallet, Contract } = require('ethers');
const carameloInterface = require('../../artifacts/contracts/Caramelo.sol/Caramelo.json');
require('dotenv').config();

async function initializeTokenomics(ownerAddress) {
  const provider = new JsonRpcProvider('http://127.0.0.1:8545');
  const wallet = new Wallet(
    '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
    provider
  );

  // Use a ABI do contrato para obter o contrato
  const carameloAbi = carameloInterface.abi;

  const caramelo = new Contract(
    process.env.CARAMELO_ADDRESS,
    carameloAbi,
    wallet
  );

  console.log('Inicializando tokenomics...');
  console.log('wallet.address:', wallet.address.toLowerCase());
  console.log('ownerAddress.toLowerCase():', ownerAddress.toLowerCase());

  if (wallet.address.toLowerCase() !== ownerAddress.toLowerCase()) {
    throw new Error(
      'Chave privada não corresponde ao endereço do proprietário.'
    );
  }

  const tx = await caramelo.initializeTokenomics();
  await tx.wait();

  console.log('Tokenomics inicializado com sucesso!');
  console.log('tx: ', tx);
}

const ownerAddress = process.env.OWNER_ADDRESS;

// Executar o script
initializeTokenomics(ownerAddress).catch((err) => {
  console.error('Erro ao inicializar tokenomics:', err);
});

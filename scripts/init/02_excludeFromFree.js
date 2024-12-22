/* eslint-disable @typescript-eslint/no-var-requires */
const { ethers } = require('hardhat');
require('dotenv').config();

async function excludeFromFee() {
  // Conecta usando sua chave privada
  const provider = new ethers.JsonRpcProvider(process.env.RPC);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  console.log('PRIVATE_KEY', process.env.PRIVATE_KEY);
  console.log('CARAMELO_ADDRESS:', process.env.CARAMELO_ADDRESS);
  console.log('OWNER_ADDRESS:', process.env.OWNER_ADDRESS);

  // Conecta ao contrato Caramelo
  const Caramelo = await ethers.getContractFactory('Caramelo', wallet);
  const caramelo = Caramelo.attach(process.env.CARAMELO_ADDRESS);

  console.log('Excluindo PreSale das taxas...');
  const tx = await caramelo.excludeFromFee(
    '0x8c08E9672Be9EDB9C61ab97f08be4C0d34f2c763'
  );
  await tx.wait();
  console.log('Contrato PreSale excluído das taxas.');
}

excludeFromFee().catch((err) => console.error(err));

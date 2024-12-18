import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import '@openzeppelin/hardhat-upgrades';
import env from 'dotenv';
import '@nomicfoundation/hardhat-foundry';
import 'solidity-docgen';

env.config();

const config: HardhatUserConfig = {
  solidity: '0.8.22',
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545',
      accounts: ["0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba"],
    },
    mumbai: {
      url: process.env.POLYGON_RPC_URL,
      accounts: [process.env.PRIVATE_KEY as string],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v6',
  },
  docgen: {
    outputDir: 'docs',
  },
};

export default config;

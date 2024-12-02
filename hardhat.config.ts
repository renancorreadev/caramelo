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

import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { defineChain } from 'viem';
import {
  opBNB,
  opBNBTestnet,
} from 'wagmi/chains';


const customLocalhost = defineChain({
  id: 31337,
  name: 'Localhost',
  nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
  rpcUrls: {
    default: { 
      http: ['http://127.0.0.1:8545'] 
    },
    public: { 
      http: ['http://127.0.0.1:8545'] 
    }
  }
});

export const config = getDefaultConfig({
  appName: 'RainbowKit demo',
  projectId: 'YOUR_PROJECT_ID',
  chains: [
    opBNB,
    opBNBTestnet,
    ...([customLocalhost]),
  ],
  ssr: true,
});
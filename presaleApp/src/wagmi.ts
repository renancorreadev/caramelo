import { connectorsForWallets } from '@rainbow-me/rainbowkit';
import {
  rainbowWallet,
  walletConnectWallet,
  binanceWallet,
  coinbaseWallet
} from '@rainbow-me/rainbowkit/wallets';
import { bsc } from 'viem/chains';

import { createConfig, http } from 'wagmi';


const connectors = connectorsForWallets(
  [
    {
      groupName: 'Recommended',
      wallets: [rainbowWallet, walletConnectWallet, binanceWallet, coinbaseWallet],
    },
  ],
  {
    appName: 'Caramelo',
    projectId: '1874f7d69584a7d65db6382fd0760fcf',
  }
);


export const config = createConfig({
  connectors,
  chains: [bsc],
  transports: {
    [bsc.id]: http(),
  },
  ssr: true,
});
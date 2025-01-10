import { connectorsForWallets } from '@rainbow-me/rainbowkit';
import {
  rainbowWallet,
  walletConnectWallet,
  binanceWallet,
  imTokenWallet,
  metaMaskWallet,
  trustWallet,
  ledgerWallet,
  coinbaseWallet,
  injectedWallet,
} from '@rainbow-me/rainbowkit/wallets';
import { bsc } from 'viem/chains';

import { createConfig, http } from 'wagmi';


function walletConnect() {

  return walletConnectWallet({
    projectId: '1874f7d69584a7d65db6382fd0760fcf',
  });
}

const connectors = connectorsForWallets(
  [
    {
      groupName: 'Recommended',
      wallets: [
        rainbowWallet, 
        walletConnect,
        binanceWallet, 
        coinbaseWallet,
        imTokenWallet,
        metaMaskWallet,
        trustWallet,
        ledgerWallet,
        injectedWallet
      ],
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
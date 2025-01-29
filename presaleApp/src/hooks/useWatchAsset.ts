/* eslint-disable @typescript-eslint/no-explicit-any */
import { EIP1193Provider } from 'viem';
import { useAccount } from 'wagmi';

export const useWatchAsset = () => {
  const { isConnected, connector } = useAccount();

  if (!isConnected || !connector) {
    return { watchAsset: null };
  }

  return {
    watchAsset: async (token: any) => {
      try {
        const provider = await connector.getProvider();

        await (provider as EIP1193Provider)?.request({
          // See details: https://docs.metamask.io/wallet/reference/wallet_watchasset/
          method: 'wallet_watchAsset',
          params: {
            type: 'ERC20',
            options: token,
          },
        });
      } catch (error) {
        console.error('Failed to watch asset:', error);
      }
    },
  };
};
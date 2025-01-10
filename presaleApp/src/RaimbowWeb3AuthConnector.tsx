import { Web3AuthConnector } from "@web3auth/web3auth-wagmi-connector";
import { Web3Auth } from "@web3auth/modal";
import { EthereumPrivateKeyProvider } from "@web3auth/ethereum-provider";
import { CHAIN_NAMESPACES, WEB3AUTH_NETWORK, WALLET_ADAPTERS} from "@web3auth/base";
import { Wallet, WalletDetailsParams } from "@rainbow-me/rainbowkit";
import { createConnector as createWagmiConnector } from "wagmi";
import { WalletServicesPlugin } from "@web3auth/wallet-services-plugin";


const clientId = "BNxY0wHqtpjHtw9EP_NQ6biJ7_Y62JqrA8itRW-dNNdm97gPIDrCBu3zGDfLNjaRBIA5tD3a6b7chlMDlvvCEDI";

  const chainConfig = {
    chainNamespace: CHAIN_NAMESPACES.EIP155,
    chainId: "0x38", 
    rpcTarget: "https://bsc-dataseed.binance.org/", 
    displayName: "Binance Smart Chain Mainnet",
    blockExplorerUrl: "https://bscscan.com/",
    ticker: "BNB",
    tickerName: "Binance Coin",
    logo: "https://cryptologos.cc/logos/binance-coin-bnb-logo.png",
  };
  
const privateKeyProvider = new EthereumPrivateKeyProvider({ config: { chainConfig } });

const web3AuthInstance = new Web3Auth({
  useAAWithExternalWallet: true,
  clientId,
  web3AuthNetwork: WEB3AUTH_NETWORK.SAPPHIRE_MAINNET,
  privateKeyProvider,
  uiConfig: {
    mode: "dark", // Apenas configurações básicas
    defaultLanguage: "pt",
    modalZIndex: '2147483647',
  },
});

const walletServicesPlugin = new WalletServicesPlugin();

web3AuthInstance.addPlugin(walletServicesPlugin);

const modalConfig = {
  [WALLET_ADAPTERS.AUTH]: {
    label: "Login Social",
    loginMethods: {
      google: {
        name: "Login com Google",
        showOnModal: true, // Exibe no modal
      },
      github: {
        name: "Login com GitHub",
        showOnModal: true, // Exibe no modal
      },
      facebook: {
        name: "Login com Facebook",
        showOnModal: true, 
      },
    },
    showOnModal: true, 
  },
};


export const rainbowWeb3AuthConnector = (): Wallet => ({
  id: "web3auth",
  name: "Login Social",
  rdns: "web3auth",
  iconUrl: "https://i.ibb.co/wJvGtXS/dog.png",
  iconBackground: "#fff",
  installed: true,
  downloadUrls: {},
  createConnector: (walletDetails: WalletDetailsParams) =>
    createWagmiConnector((config) => ({
      ...Web3AuthConnector({
        web3AuthInstance,
        modalConfig,
      })(config),
      ...walletDetails,
    })),
});

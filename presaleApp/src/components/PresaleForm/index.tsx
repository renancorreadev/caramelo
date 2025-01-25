/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @next/next/no-img-element */
import React, { useCallback, useEffect, useState } from 'react';
import { ethers, formatUnits } from 'ethers';
import { useWalletClient, useAccount, useBalance } from 'wagmi';
import {
  CarameloPreSale__factory,
  Caramelo__factory,
} from '../../utils/typechain';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { BsCurrencyBitcoin } from 'react-icons/bs';
import { useIsMobile } from '@/hooks/useMobile';
import toast from 'react-hot-toast';

const CONTRACT_ADDRESS =
  process.env.NEXT_PUBLIC_CARAMELO_PRESALE_CONTRACT || '';
const TOKEN_ADDRESS = process.env.NEXT_PUBLIC_CARAMELO_CONTRACT || '';

const PresaleForm = () => {
  const { data: walletClient } = useWalletClient();
  const { data: balance } = useBalance();
  const { isConnected, address } = useAccount();

  const [isMetaMask, setIsMetaMask] = useState<boolean>(false);
  const [contract, setContract] = useState<any>(null);
  const [amount, setAmount] = useState<string>('');
  const [remaining, setRemaining] = useState<string>('0');
  const [totalRaised, setTotalRaised] = useState<string>('0');
  const [carameloBalance, setCarameloBalance] = useState<string>('0');
  const [tokenContract, setTokenContract] = useState<any>(null);
  const [BNBBalance, setBNBBalance] = useState<number | null>(null);
  const isMobile = useIsMobile();
  const allowedAddresses = [
    '0xdCA1b295fAb25ebCFA1BF3834599Bd8606A64bF6'.toLowerCase(),
    '0x14864Bc81FEed0ec2AA2E1826f82b1801D55C47f'.toLowerCase(),
    '0x5707595910eC3D839d8348720E9C7E1d47784457'.toLowerCase(),
    '0x5C63ccd7eA8f1676F7A8E20C0084De8e7d98E419'.toLowerCase(),
  ];

  useEffect(() => {
    try {
      if (typeof window !== 'undefined' && window.ethereum?.isMetaMask) {
        setIsMetaMask(true);
      }

      if (!walletClient) return;
      const bnbBalance = formatUnits(balance?.value || 0, 18);
      setBNBBalance(Number(bnbBalance));

      const setupContract = async () => {
        const provider = new ethers.BrowserProvider(walletClient);
        const signer = await provider.getSigner();
        const contractInstance = CarameloPreSale__factory.connect(
          CONTRACT_ADDRESS,
          signer
        );

        const tokenContractInstance = Caramelo__factory.connect(
          TOKEN_ADDRESS,
          signer
        );
        setContract(contractInstance);
        setTokenContract(tokenContractInstance);
      };

      setupContract();
    } catch (error) {
      toast.error('Erro ao carregar informações.');
      console.error('Erro ao carregar informações:', error);
    }
  }, [walletClient, balance]);

  const loadPresaleInfo = useCallback(async () => {
    if (!contract) return;

    try {
      const remainingTokens = await contract.tokensRemaining();
      const totalRaisedBNB = await contract.totalBNBReceived();
      const carameloTokenBalance = await tokenContract.balanceOf(
        walletClient?.account.address
      );

      setRemaining(ethers.formatUnits(remainingTokens, 6));
      setTotalRaised(ethers.formatUnits(totalRaisedBNB, 18));
      setCarameloBalance(ethers.formatUnits(carameloTokenBalance, 9));
    } catch (error) {
      toast.error('Erro ao carregar informações da pré-venda.');
      console.error('Erro ao carregar informações:', error);
    }
  }, [contract, tokenContract, walletClient]);

  const handleBuy = async () => {
    if (!contract) {
      toast.error('Conecte sua carteira antes de comprar.');
      return;
    }

    if (!amount || parseFloat(amount) <= 0) {
      toast.error('Por favor, insira um valor válido de BNB.');
      return;
    }

    if (BNBBalance && parseFloat(amount) > BNBBalance) {
      toast.error('Saldo insuficiente de BNB.');
      return;
    }

    try {
      toast.loading('Processando compra...');

      const tx = await contract.buyTokens({
        value: ethers.parseEther(amount),
      });
      await tx.wait();
      toast.dismiss();
      toast.success('Compra realizada com sucesso!');
      loadPresaleInfo();
    } catch (error) {
      console.error('Erro ao comprar tokens:', error);
      toast.error(parseContractError(error));
    }
  };

  const parseContractError = (error: any): string => {
    console.error('Erro detectado:', error);
  
    if (error?.data?.message) {
      const errorMsg = error.data.message;
  
      if (errorMsg.includes('InsufficientFunds')) {
        return 'Saldo insuficiente para compra. Verifique seu saldo e tente novamente.';
      }
  
      if (errorMsg.includes('InvalidPhase')) {
        return 'A pré-venda não está ativa no momento. Aguarde a fase correta.';
      }
  
      if (errorMsg.includes('PreSaleNotActive')) {
        return 'A pré-venda ainda não está ativa. Tente novamente mais tarde.';
      }
  
      if (errorMsg.includes('NoTokensAvailable')) {
        return 'Não há tokens suficientes disponíveis para compra. Tente um valor menor.';
      }
  
      if (errorMsg.includes('InvalidTokenAmount')) {
        return 'A quantidade de tokens inserida é inválida. Insira um valor válido.';
      }
  
      if (errorMsg.includes('PreSaleAlreadyInitialized')) {
        return 'A pré-venda já foi inicializada. Não é possível reiniciá-la.';
      }
  
      if (errorMsg.includes('ZeroAddress')) {
        return 'Endereço de destino inválido. Verifique os dados e tente novamente.';
      }
  
      if (errorMsg.includes('WithdrawalFailed')) {
        return 'Falha ao tentar sacar os fundos. Entre em contato com o suporte.';
      }
  
      if (errorMsg.includes('MaxTokensBuyExceeded')) {
        return 'Você excedeu o limite máximo de tokens permitidos. Tente um valor menor.';
      }
  
      if (errorMsg.includes('InvalidPhaseRate')) {
        return 'Taxa de fase inválida. Entre em contato com o suporte para mais informações.';
      }
    } 
    
    // Captura de erro quando não há saldo suficiente para gas/BNB
    if (error?.code === 'CALL_EXCEPTION' && error.reason === null && error.data === null) {
      return 'Saldo insuficiente para pagar o gás da transação. Deposite BNB em sua carteira.';
    }
  
    if (error?.message) {
      if (error.message.includes('insufficient funds')) {
        return 'Saldo insuficiente na carteira para completar a transação.';
      }
    }
  
    return 'Erro desconhecido. Por favor, tente novamente mais tarde.';
  };
  

  const handleAddToken = async () => {
    const tokenDetails = {
      type: 'ERC20',
      options: {
        address: TOKEN_ADDRESS,
        symbol: 'CARAMELO',
        decimals: 9,
        image: 'https://i.postimg.cc/wB37FMbj/caramelo-Token.png',
      },
    };

    try {
      const wasAdded = await window.ethereum.request({
        method: 'wallet_watchAsset',
        params: tokenDetails,
      });

      if (wasAdded) {
        alert('Token added to MetaMask!');
      } else {
        alert('Token addition declined.');
      }
    } catch (error) {
      console.error('Error adding token:', error);
      alert('An error occurred. Please try again.');
    }
  };

  useEffect(() => {
    if (contract) loadPresaleInfo();
  }, [contract, loadPresaleInfo]);

  if (!isConnected) {
    return (
      <div className="bg-gray-800 text-white p-6 rounded-xl shadow-md max-w-md mx-auto text-center">
        <h2 className="text-xl font-bold mb-4">Conecte sua carteira</h2>
        <p className="text-gray-400">
          Para acessar a pré-venda, conecte sua carteira usando o botão acima.
        </p>
      </div>
    );
  }

  return (
    <div
      id="presale-form"
      className="bg-gray-700 text-white p-10 rounded-2xl shadow-lg max-w-5xl mx-auto space-y-8 lg:space-y-0 lg:flex lg:items-start lg:gap-10"
    >
      {/* Informações do Presale */}
      <div className="flex-1 space-y-6">
        <h1 className="text-4xl font-extrabold text-carameloAccent text-center lg:text-left">
          🚀 Pré-venda Caramelo 🚀
        </h1>
        <div className="bg-gray-800 p-6 rounded-lg shadow-md">
          <div className="mb-6 xs:flex xs:flex-col">
            <div className="flex sm:items-center sm:gap-3 mb-2 xs:justify-start">
              <BsCurrencyBitcoin className="text-yellow-400 text-3xl" />
              <span className="text-gray-400 text-lg font-medium">
                Tokens Disponíveis
              </span>
            </div>
            <div className="bg-gray-700 h-4 rounded-lg overflow-hidden mb-2">
              <div
                className="bg-carameloAccent h-full transition-all duration-300 "
                style={{ width: `${(Number(remaining) / 1000000) * 100}%` }}
              />
            </div>
            <div className="sm:text-start text-sm text-gray-400 xs:flex xs:justify-center xs:items-center">
              {remaining}
            </div>
          </div>

          {isConnected &&
            allowedAddresses.includes(address?.toLowerCase() || '') && (
              <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-4 gap-2">
                <div className="flex items-center gap-3">
                  <img src="/bnb.png" alt="BNB" className="w-8 h-8" />
                  <span className="text-gray-400 text-lg">
                    BNB Arrecadados:
                  </span>
                </div>
                <span className="font-semibold text-white text-lg sm:text-right">
                  {Number(totalRaised).toFixed(1)} BNB
                </span>
              </div>
            )}

          <div className="flex flex-col sm:flex-row sm:items-center justify-around mb-4 gap-2">
            <div className="flex items-center gap-3 w-full">
              <img src="/dog.png" alt="Caramelo" className="w-8 h-8" />
              <span className="text-gray-400 text-lg sm:w-full">
                Saldo Caramelo:
              </span>
            </div>
            <span className="font-semibold text-white text-lg sm:text-right sm:w-full sm:flex sm:flex-col sm:items-end">
              {carameloBalance} CARAMELO
            </span>
          </div>
        </div>
      </div>

      {/* Formulário de Compra */}
      <div className="flex-1 bg-gray-800 p-6 rounded-lg shadow-md space-y-6">
        <div>
          <label
            htmlFor="bnb"
            className="block text-gray-300 text-lg font-medium mb-2"
          >
            Quantidade em BNB
          </label>
          <input
            id="bnb"
            type="number"
            placeholder="Digite a quantidade de BNB"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="w-full p-4 rounded-lg bg-gray-700 border border-gray-600 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-carameloAccent"
          />
        </div>
        {!isMobile && <ConnectButton label="Connectar" />}
        {isMobile && (
          <div className="flex flex-col justify-between">
            <div className="flex items-center gap-2">
              <span className="text-gray-400 text-lg">Saldo BNB:</span>
              <img src="/bnb.png" alt="BNB" className="w-5 h-5" />
            </div>

            <span className="font-semibold text-white text-lg">
              {Number(BNBBalance).toFixed(6)} BNB
            </span>
          </div>
        )}

        <button
          onClick={handleBuy}
          className="w-full bg-carameloAccent text-white font-bold py-4 rounded-lg shadow-lg hover:bg-yellow-500 hover:text-gray-900 transition-all duration-300"
        >
          Comprar Tokens
        </button>
        {isMetaMask && (
          <button
            onClick={handleAddToken}
            className="w-full bg-gray-700 text-carameloAccent font-bold py-4 rounded-lg shadow-lg hover:bg-gray-600 hover:text-yellow-400 transition-all duration-300"
          >
            Adicionar Token à Carteira
          </button>
        )}
      </div>
    </div>
  );
};

export default PresaleForm;

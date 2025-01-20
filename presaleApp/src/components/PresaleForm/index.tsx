/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @next/next/no-img-element */
import React, { useCallback, useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { useWalletClient, useAccount } from 'wagmi';
import {
  CarameloPreSale__factory,
  Caramelo__factory,
} from '../../utils/typechain';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { BsCurrencyBitcoin } from 'react-icons/bs';

const CONTRACT_ADDRESS =
  process.env.NEXT_PUBLIC_CARAMELO_PRESALE_CONTRACT || '';
const TOKEN_ADDRESS = process.env.NEXT_PUBLIC_CARAMELO_CONTRACT || '';

const PresaleForm = () => {
  const { isConnected, address } = useAccount();
  const { data: walletClient } = useWalletClient();
  const [isMetaMask, setIsMetaMask] = useState(false);

  const [contract, setContract] = useState<any>(null);
  const [amount, setAmount] = useState('');
  const [remaining, setRemaining] = useState('0');
  const [totalRaised, setTotalRaised] = useState('0');
  const [carameloBalance, setCarameloBalance] = useState('0');
  const [tokenContract, setTokenContract] = useState<any>(null);

  const allowedAddresses = [
    '0xdCA1b295fAb25ebCFA1BF3834599Bd8606A64bF6'.toLowerCase(),
    '0x14864Bc81FEed0ec2AA2E1826f82b1801D55C47f'.toLowerCase(),
    '0x5707595910eC3D839d8348720E9C7E1d47784457'.toLowerCase(),
  ];

  useEffect(() => {
    if (typeof window !== 'undefined' && window.ethereum?.isMetaMask) {
      setIsMetaMask(true);
    }

    if (!walletClient) return;

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
  }, [walletClient]);

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
      console.error('Erro ao carregar informações:', error);
    }
  }, [contract, tokenContract, walletClient]);

  const handleBuy = async () => {
    if (!contract) {
      alert('Conecte sua carteira antes de comprar.');
      return;
    }

    try {
      const tx = await contract.buyTokens({
        value: ethers.parseEther(amount),
      });
      await tx.wait();
      alert('Compra realizada com sucesso!');
      loadPresaleInfo();
    } catch (error) {
      console.error('Erro ao comprar tokens:', error);
      alert('Erro ao comprar tokens.');
    }
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
          <div className="mb-6">
            <div className="flex items-center gap-3 mb-2">
              <BsCurrencyBitcoin className="text-yellow-400 text-3xl" />
              <span className="text-gray-400 text-lg font-medium">
                Tokens Disponíveis
              </span>
            </div>
            <div className="bg-gray-700 h-4 rounded-lg overflow-hidden mb-2">
              <div
                className="bg-carameloAccent h-full transition-all duration-300"
                style={{ width: `${(Number(remaining) / 1000000) * 100}%` }}
              />
            </div>
            <div className="text-start text-sm text-gray-400">
              {remaining} Tokens
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

          <div className="flex flex-col items-start gap-2">
            <div className="flex items-center gap-3">
              <img src="/dog.png" alt="Caramelo" className="w-8 h-8" />
              <span className="text-gray-400 text-lg ">Saldo Caramelo:</span>
            </div>
            <span className="font-semibold text-white text-xl pl-11">
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

        <ConnectButton label="Connectar" />

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

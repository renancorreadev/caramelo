/* eslint-disable react-hooks/exhaustive-deps */
/* eslint-disable @typescript-eslint/no-explicit-any */
"use client";

import React, { useCallback, useEffect, useState } from "react";
import { ethers } from "ethers";
import { useWalletClient, useAccount } from "wagmi";
import { CarameloPreSale__factory } from "@/utils/typechain";

const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CARAMELO_PRESALE_CONTRACT || "";
const TOKEN_ADDRESS = process.env.NEXT_PUBLIC_CARAMELO_CONTRACT || ""; // Endereço do token

const PresaleForm = () => {
  const { isConnected } = useAccount();
  const { data: walletClient } = useWalletClient();

  const [contract, setContract] = useState<any>(null);
  const [amount, setAmount] = useState("");
  const [remaining, setRemaining] = useState("0");
  const [totalRaised, setTotalRaised] = useState("0");

  useEffect(() => {
    if (!walletClient) return;

    const setupContract = async () => {
      const provider = new ethers.BrowserProvider(walletClient);
      const signer = await provider.getSigner();
      const contractInstance = CarameloPreSale__factory.connect(
        CONTRACT_ADDRESS,
        signer
      );
      setContract(contractInstance);
    };

    setupContract();
  }, [walletClient]);

  const loadPresaleInfo = useCallback(async () => {
    if (!contract) return;

    try {
      const remainingTokens = await contract.tokensRemaining();
      const totalRaisedBNB = await contract.totalBNBReceived();

      setRemaining(ethers.formatUnits(remainingTokens, 6));
      setTotalRaised(ethers.formatUnits(totalRaisedBNB, 18));
    } catch (error) {
      console.error("Erro ao carregar informações:", error);
    }
  }, [contract]);

  const handleBuy = async () => {
    if (!contract) {
      alert("Conecte sua carteira antes de comprar.");
      return;
    }

    try {
      const tx = await contract.buyTokens({
        value: ethers.parseEther(amount),
      });
      await tx.wait();
      alert("Compra realizada com sucesso!");
      loadPresaleInfo();
    } catch (error) {
      console.error("Erro ao comprar tokens:", error);
      alert("Erro ao comprar tokens.");
    }
  };

  const handleAddToken = async () => {
    const tokenDetails = {
      type: 'ERC20',
      options: {
        address: TOKEN_ADDRESS,
        symbol: 'CARAMELO',
        decimals: 6,
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
    <div className="bg-gray-700 text-white p-8 rounded-2xl shadow-lg max-w-md mx-auto relative">
      <h1 className="text-3xl font-extrabold text-carameloAccent mb-6 text-center">
        🚀 Pré-venda Caramelo 🚀
      </h1>
      <div className="bg-gray-800 p-4 rounded-lg mb-6 shadow-md">
        <div className="flex justify-between items-center mb-2">
          <span className="text-gray-400">Tokens Disponíveis:</span>
          <span className="font-semibold text-white">{remaining}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-gray-400">BNB Arrecadados:</span>
          <span className="font-semibold text-white">{totalRaised} BNB</span>
        </div>
      </div>
      <div className="mb-4">
        <label htmlFor="bnb" className="block text-gray-300 text-sm font-medium mb-2">
          Quantidade em BNB
        </label>
        <input
          id="bnb"
          type="number"
          placeholder="Digite a quantidade de BNB"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          className="w-full p-3 rounded-lg bg-gray-700 border border-gray-600 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-carameloAccent"
        />
      </div>
      <button
        onClick={handleBuy}
        className="w-full bg-carameloAccent text-white font-bold py-3 rounded-lg shadow-[0_4px_10px_rgba(255,215,0,0.5)] hover:bg-yellow-500 hover:text-gray-900 transition-all duration-300 mb-4"
      >
        Comprar Tokens
      </button>
      <button
        onClick={handleAddToken}
        className="w-full bg-gray-800 text-carameloAccent font-bold py-3 rounded-lg shadow-[0_4px_10px_rgba(255,215,0,0.5)] hover:bg-gray-700 hover:text-yellow-400 transition-all duration-300"
      >
        Adicionar Token à MetaMask
      </button>
      <div className="absolute top-0 left-0 w-full h-2 rounded-t-2xl bg-carameloAccent"></div>
    </div>
  );
};

export default PresaleForm;

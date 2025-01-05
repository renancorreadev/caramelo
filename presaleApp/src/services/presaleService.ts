import { ethers } from "ethers";
import { CarameloPreSale__factory } from "../utils/typechain"; // Importa a factory gerada automaticamente pelo Typechain

const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL || "";
const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CARAMELO_PRESALE_CONTRACT || "";
const PRIVATE_KEY = process.env.NEXT_PUBLIC_PRIVATE_KEY || "";

// Configuração do provedor e signer
const provider = new ethers.JsonRpcProvider(RPC_URL);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);

// Função para obter o contrato tipado usando a Factory
export const getContract = () => {
  const contract = CarameloPreSale__factory.connect(CONTRACT_ADDRESS, signer);
  return contract;
};

// Função para comprar tokens
export const buyTokens = async (amount: string) => {
  const contract = getContract();
  const tx = await contract.buyTokens({
    value: ethers.parseEther(amount),
  });
  await tx.wait();
  console.log("Tokens comprados com sucesso!");
};

// Função para buscar informações da pré-venda
export const fetchPresaleInfo = async () => {
  const contract = getContract();
  const remaining = await contract.tokensRemaining();
  const totalRaised = await contract.totalBNBReceived();

  return {
    remaining: ethers.formatUnits(remaining, 6),
    totalRaised: ethers.formatUnits(totalRaised, 18),
  };
};

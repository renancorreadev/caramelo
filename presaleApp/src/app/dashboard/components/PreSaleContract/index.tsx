/* eslint-disable @typescript-eslint/no-explicit-any */
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { useWalletClient } from "wagmi";
import { CarameloPreSale__factory } from "@/utils/typechain";
import { Container } from "@/components/Container";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";

export const PreSaleContract = () => {
  const { data: walletClient } = useWalletClient();

  const [contract, setContract] = useState<any>(null);
  const [data, setData] = useState<any>({});
  const [inputs, setInputs] = useState<Record<string, string>>({});

  useEffect(() => {
    const setupContract = async () => {
      if (!walletClient) return;

      const provider = new ethers.BrowserProvider(walletClient);
      const signer = await provider.getSigner();
      const contractInstance = CarameloPreSale__factory.connect(
        process.env.NEXT_PUBLIC_CARAMELO_PRESALE_CONTRACT!,
        signer
      );

      setContract(contractInstance);
    };

    setupContract();
  }, [walletClient]);

  const fetchData = async (fnName: string) => {
    if (!contract || typeof contract[fnName] !== "function") {
      console.error(`O método ${fnName} não existe no contrato.`);
      return;
    }
    try {
      const result = await contract[fnName]();
      setData((prev: any) => ({ ...prev, [fnName]: result.toString() }));
    } catch (error) {
      console.error(`Erro ao buscar ${fnName}:`, error);
    }
  };

  const handleTransaction = async (fnName: string, args: any[]) => {
    if (!contract || typeof contract[fnName] !== "function") {
      console.error(`O método ${fnName} não existe no contrato.`);
      return;
    }
    try {
      const tx = await contract[fnName](...args);
      await tx.wait();
      alert(`${fnName} executado com sucesso!`);
    } catch (error) {
      console.error(`Erro ao executar ${fnName}:`, error);
    }
  };

  const handleInputChange = (key: string, value: string) => {
    setInputs((prev) => ({ ...prev, [key]: value }));
  };

const contractFunctions = [
  { name: "initializePreSale", type: "nonpayable", args: [] },
  { name: "tokensRemaining", type: "view", args: [] },
  { name: "totalBNBReceived", type: "view", args: [] },
  { name: "buyTokens", type: "payable", args: [] },
  { name: "endPreSale", type: "nonpayable", args: [] },
  { name: "withdrawFunds", type: "nonpayable", args: [] },
  { name: "addToWhitelist", type: "nonpayable", args: ["account"] },
  { name: "addMultipleToWhitelist", type: "nonpayable", args: ["accounts"] },
  { name: "removeFromWhitelist", type: "nonpayable", args: ["account"] },
  { name: "updateMaxTokensBuy", type: "nonpayable", args: ["newLimit"] },
  { name: "updatePhase", type: "nonpayable", args: ["newPhase"] },
  { name: "updatePhaseRate", type: "nonpayable", args: ["phase", "newRate"] },
];


  return (
    <Container className="w-full h-full">
      <div className="bg-gray-700 text-white p-8 rounded-2xl shadow-lg w-full h-full">
        <h1 className="text-3xl font-extrabold text-carameloAccent mb-6 text-center">
          PreSale Contract Dashboard
        </h1>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {contractFunctions.map((fn) => (
            <div
              key={fn.name}
              className="bg-gray-800 p-4 rounded-lg shadow-md flex flex-col gap-4"
            >
              <h2 className="text-lg font-bold">{fn.name}</h2>
              {fn.type === "view" ? (
                <>
                  <Button onClick={() => fetchData(fn.name)}>Fetch</Button>
                  <div className="bg-gray-900 text-carameloAccent p-2 rounded-md">
                    {data[fn.name] || "No Data"}
                  </div>
                </>
              ) : (
                <>
                  {fn.args.map((arg) => (
                    <Input
                      key={`${fn.name}-${arg}`}
                      placeholder={arg}
                      value={inputs[`${fn.name}-${arg}`] || ""}
                      onChange={(e) =>
                        handleInputChange(`${fn.name}-${arg}`, e.target.value)
                      }
                    />
                  ))}
                  <Button
                    onClick={() =>
                      handleTransaction(
                        fn.name,
                        fn.args.map((arg) => inputs[`${fn.name}-${arg}`])
                      )
                    }
                  >
                    Execute
                  </Button>
                </>
              )}
            </div>
          ))}
        </div>
      </div>
    </Container>
  );
};



"use client";

import { trackEvent } from "@/utils/bpixel";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import React from "react";

export const ConnectWalletMessage = () => {
  return (
    <div className="bg-gray-800 text-white p-6 rounded-xl shadow-md max-w-md mx-auto text-center">
      <h2 className="text-xl font-bold">Conecte sua carteira</h2>
      <p className="text-gray-400">
        Para acessar a pré-venda, conecte sua carteira usando o botão acima.
      </p>

      <div  id="connect-wallet" className="flex center gap-2 mx-4 my-4 justify-center" onClick={() => trackEvent("Connect Wallet")}>
       <ConnectButton />
      </div>
    </div>
  );
};
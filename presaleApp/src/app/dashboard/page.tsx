'use client';

import React, { useEffect, useState } from 'react';
import { useAccount } from 'wagmi';

import { Container } from '@/components/Container';
import { CarameloContract, PreSaleContract } from './components';

const ADMIN_ADDRESS = '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc';

const AdminPage = () => {
  const { address, isConnected } = useAccount();

  const [isAdmin, setIsAdmin] = useState(false);

  useEffect(() => {
    if (address?.toLowerCase() === ADMIN_ADDRESS.toLowerCase()) {
      setIsAdmin(true);
    } else {
      setIsAdmin(false);
    }
  }, [address]);

  if (!isConnected || !isAdmin) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-200">
        <div className="bg-white shadow-lg rounded-lg p-8 max-w-md text-center">
          <h1 className="text-3xl font-bold text-red-600 mb-4">
            Acesso Negado
          </h1>
          <p className="text-gray-700 mb-6">
            Você precisa estar conectado com a conta de administrador para
            acessar esta página.
          </p>
        </div>
      </div>
    );
  }

  return (
    <Container className="p-14 max-w-max">
      <div className="bg-gray-700 text-white p-14 rounded-2xl shadow-lg w-full">
        <h1 className="text-3xl font-extrabold text-carameloAccent mb-6 text-center">
          🛠️ Administração Caramelo 🛠️
        </h1>

        <div className="flex flex-wrap gap-4">
          <div className="flex-1 min-w-[300px] bg-gray-800 p-4 rounded-lg shadow-md">
            <CarameloContract />
          </div>
          <div className="flex-1 min-w-[300px] bg-gray-800 p-4 rounded-lg shadow-md">
            <PreSaleContract />
          </div>
        </div>
      </div>
    </Container>
  );
};

export default AdminPage;

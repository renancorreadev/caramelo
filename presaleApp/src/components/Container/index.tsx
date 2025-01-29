'use client';

import React from 'react';
import { useIsMobile } from '@/hooks/useMobile';

interface ContainerProps {
  children: React.ReactNode;
  className?: string;
}

const CONTRACT_ADDRESS = '0xe600B09584619274984CB58a2C2ac9A954D6e349'; // Substitua pelo endereço real
const BSC_SCAN_URL = `https://bscscan.com/address/${CONTRACT_ADDRESS}`;

export const Container: React.FC<ContainerProps> = ({
  children,
  className,
}) => {
  const isMobile = useIsMobile();

  return (
    <div
      className={`relative w-full bg-gray-900 text-white flex flex-col items-center ${className}`}
    >
      {/* Contêiner do vídeo */}
      <div
        id="video-container"
        className="absolute inset-0 z-0 overflow-hidden"
      >
        <video
          id="video-header"
          autoPlay
          playsInline
          loop
          muted
          className="w-full h-full object-cover opacity-10"
        >
          <source src="/media/carameloheader.mp4" type="video/mp4" />
        </video>
      </div>

      {/* Contêiner para o conteúdo */}
      <div className="relative z-10 flex flex-col items-center w-full xs:pt-[6rem] xs:pb-[2rem] sm:py-[9rem]">
        {children}
      </div>

      {/* Rodapé com link para o contrato na BSC */}
      <div className="relative z-10 w-full flex justify-center py-4 bg-gray-800">
        <span className="comic-neue font-bold mr-2">📜 Endereço do Token: </span>
        <a
          href={BSC_SCAN_URL}
          target="_blank"
          rel="noopener noreferrer"
          className="text-yellow-400 text-sm font-semibold hover:underline flex items-center gap-2"
        >
          {isMobile ? (
            <span className="comic-neue  block font-bold">
              {`${CONTRACT_ADDRESS.substring(0, 6)}...${CONTRACT_ADDRESS.slice(
                -6
              )}`}
            </span>
          ) : (
            <span className="comic-neue font-bold">{CONTRACT_ADDRESS}</span>
          )}
        </a>
      </div>
    </div>
  );
};

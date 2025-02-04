'use client';

import React, { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import { Container } from '@/components/Container';
import PresaleForm from '@/components/PresaleForm';
import { useAccount } from 'wagmi';
import { Hero } from '@/components/HomeContent';

// Desativando SSR para os componentes propensos a problemas
const DynamicPageContent = dynamic(
  () => import('@/components/HomeContent').then((mod) => mod.PageContent),
  { ssr: false }
);
const DynamicWhitePaper = dynamic(
  () => import('@/components/HomeContent').then((mod) => mod.WhitePaper),
  { ssr: false }
);

export default function Home() {
  const { isConnected } = useAccount();
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) {
    return <div className="loading-spinner">Carregando...</div>;
  }

  return isConnected ? (
    <div id="connected">
      <Container>
        <div className="xs:!mx-6 overflow-hidden">
          <PresaleForm />

          {/* Seção de vídeo responsiva */}
          <div className="flex flex-col items-center sm:mt-8 xs:mt-4 sm:gap-6 xs:gap-4 text-center">
            <h2 className="text-white font-bold text-2xl">Como comprar?</h2>
            <p className="text-gray-200 max-w-[600px]">
              Assista ao vídeo abaixo para entender como comprar os tokens da pré-venda do Caramelo.
            </p>

            {/* Container do iframe centralizado */}
            <div className="w-full flex justify-center">
              <iframe
                className="w-full max-w-[560px] aspect-video rounded-lg shadow-lg"
                src="https://www.youtube.com/embed/KOr2ttjv1jU?si=cpc_dIF7zBkALDTS"
                title="YouTube video player"
                frameBorder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                referrerPolicy="strict-origin-when-cross-origin"
                allowFullScreen
              ></iframe>
            </div>
          </div>
        </div>
      </Container>

      <div className="p-0">
        <DynamicPageContent />
      </div>
      <div>
        <DynamicWhitePaper />
      </div>
    </div>
  ) : (
    <div className="content comic-neue relative mb-0">
      <Hero />

      <div className="xs:mt-[-130px]">
        <DynamicPageContent />
      </div>

      <div>
        <DynamicWhitePaper />
      </div>
    </div>
  );
}

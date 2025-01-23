"use client";

import React, { useEffect, useState } from "react";
import dynamic from "next/dynamic";
import { Container } from "@/components/Container";
import PresaleForm from "@/components/PresaleForm";
import { useAccount } from "wagmi";
import { Hero } from "@/components/HomeContent";

// Desativando SSR para os componentes propensos a problemas
const DynamicPageContent = dynamic(() => import('@/components/HomeContent').then(mod => mod.PageContent), { ssr: false });
const DynamicWhitePaper = dynamic(() => import('@/components/HomeContent').then(mod => mod.WhitePaper), { ssr: false });

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

'use client';

import { Container } from '@/components/Container';
import { ConnectWalletMessage, Roadmap } from '@/components/HomeContent';
import CarameloWhitePaper from '@/components/HomeContent/CarameloWhitePaper';
import PresaleForm from '@/components/PresaleForm';
import { useAccount } from 'wagmi';

export default function Home() {
  const { isConnected } = useAccount();

  return isConnected ? (
    <Container>
      <PresaleForm />
    </Container>
  ) : (
    <Container>
      <div className="bg-gray-900 min-h-screen w-full">
        <div className="relative w-full h-40 overflow-hidden">
          <div
            className="absolute inset-0 bg-repeat opacity-40 pointer-events-none w-full h-full"
            style={{
              backgroundImage: "url('/dog.png')",
              backgroundSize: '80px 80px',
              backgroundAttachment: 'fixed',
            }}
          />

          <div className="absolute inset-0 bg-gradient-to-b from-transparent via-gray-900 to-gray-900"></div>
        </div>

        <div className="xs:mx-6 lg:mx-12">
          <CarameloWhitePaper />
        </div>
            
        <div className='xs:mx-6 py-8 lg:mx-12'>
        <Roadmap />
        </div>
        <div className="xs:mx-6 mb-8">
          <ConnectWalletMessage />
        </div>
      </div>
    </Container>
  );
}

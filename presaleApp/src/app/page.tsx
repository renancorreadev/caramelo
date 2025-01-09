'use client';

import { Container } from '@/components/Container';
import {
  ConnectWalletMessage,
  Roadmap,
} from '@/components/HomeContent';
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
      <div className="bg-gray-900 min-h-screen py-12 px-6">
        <CarameloWhitePaper />
        <Roadmap />
        <ConnectWalletMessage />
      </div>
    </Container>
  );
}

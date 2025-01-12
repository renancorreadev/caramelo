/* eslint-disable @next/next/no-img-element */
'use client';

import { Container } from '@/components/Container';
import PresaleForm from '@/components/PresaleForm';
import { useAccount } from 'wagmi';

import { Hero, PageContent, WhitePaper } from '@/components/HomeContent';

export default function Home() {
  const { isConnected } = useAccount();

  return isConnected ? (
    <div id="connected"  >
      <Container>
        <div className="xs:!mx-6 overflow-hidden" 
        >
          <PresaleForm />
        </div>
      </Container>
      <div className="" style={{ padding: '0' }}>
        {' '}
        <PageContent />
      </div>
      <div>
        <WhitePaper />
      </div>
    </div>
  ) : (
    <div
      className="content comic-neue"
      style={{ padding: '0', position: 'relative', marginBottom: '0px' }}
    >
      <Hero />

      <div className="xs:mt-[-130px]">
        {' '}
        <PageContent />
      </div>

      <div>
        <WhitePaper />
      </div>
    </div>
  );
}

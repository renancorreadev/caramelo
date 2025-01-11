/* eslint-disable @next/next/no-img-element */
'use client';

import { Container } from '@/components/Container';
import PresaleForm from '@/components/PresaleForm';
import { useAccount } from 'wagmi';

import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  const { isConnected } = useAccount();

  return isConnected ? (
    <Container>
      <div className="xs:!mx-6">
        <PresaleForm />
      </div>
    </Container>
  ) : (
    <div
      className="content comic-neue"
      style={{ padding: '0', position: 'relative' }}
    >
      <div
        id="video-container"
        style={{
          position: 'relative',
          width: '100vw',
          height: '100vh', // Garante altura máxima para o vídeo
          overflow: 'hidden',
        }}
      >
        <video
          id="video-header"
          autoPlay
          playsInline
          loop
          muted
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            position: 'absolute',
            top: 0,
            left: 0,
            zIndex: 1,
          }}
        >
          <source src="/media/carameloheader.mp4" type="video/mp4" />
        </video>

        {/* Conteúdo centralizado no vídeo */}
        <div
          id="content"
          style={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            zIndex: 2,
            textAlign: 'center',
            color: '#fff',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          {/* Imagem do cachorro */}
          <a
            href="#"
            target="_blank"
            onClick={() =>
              document
                .querySelector('#ShootingDoges')
                ?.setAttribute('style', 'display: flex;')
            }
          >
            <img
              className="dogelogo"
              src="/images/caramelo.svg"
              alt="Caramelo Coin"
              style={{
                maxWidth: '450px',
                marginBottom: '20px',
              }}
            />
          </a>

          {/* Título */}
          <h1
            id="title"
            className="d_text_display d_span_opacity comic-neue font-bold"
            style={{
              fontSize: '4rem',
              marginBottom: '10px',
            }}
          >
            <span id="dynamic_c">C</span>ARAMELOCOIN
          </h1>

          {/* Subtítulo */}
          <p
            className="subtitle poppins fw-light text-white"
            style={{
              fontSize: '1.2rem',
              marginBottom: '20px',
            }}
          >
            a MEMECOIN do Brasil
          </p>

          {/* Botão Connect */}
          <ConnectButton />
        </div>
      </div>

      <style jsx>{`
        /* Responsividade para dispositivos móveis */
        @media (max-width: 768px) {
          #video-container {
            height: 100vh;
          }

          #video-header {
            height: 100%;
            width: 100%;
            object-fit: cover;
          }

          .dogelogo {
            max-width: 100px; /* Ajusta o tamanho do logo no mobile */
          }

          #title {
            font-size: 2.5rem; /* Reduz o tamanho da fonte no mobile */
          }

          .subtitle {
            font-size: 1rem; /* Ajusta o subtítulo para telas menores */
          }
        }
      `}</style>
    </div>
  );
}

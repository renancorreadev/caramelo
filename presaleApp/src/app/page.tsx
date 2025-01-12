/* eslint-disable @next/next/no-img-element */
'use client';

import { useEffect } from 'react';
import AOS from 'aos'; // Importando o AOS do pacote npm
import 'aos/dist/aos.css'; // Importando o CSS necessário para AOS
import { Container } from '@/components/Container';
import PresaleForm from '@/components/PresaleForm';
import { useAccount } from 'wagmi';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  const { isConnected } = useAccount();

  // Inicializando o AOS
  useEffect(() => {
    const initializeAOS = () => {
      AOS.init({
        duration: 1000,
        easing: 'ease-in-out',
        once: true,
      });
  
      // Garantir que o AOS esteja sincronizado com os elementos
      AOS.refresh();
    };
  
    initializeAOS();
  }, []);
  
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
          height: '100vh', // Garante que ocupe toda a altura da tela
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
            width: '100vw', 
            height: '100vh', 
            objectFit: 'cover', 
            position: 'absolute',
            top: 0,
            left: 0,
            zIndex: 1,
          }}
        >
          <source src="/media/carameloheader.mp4" type="video/mp4" />
        </video>

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
          <a
            href="#"
            target="_blank"
            className='lg:!relative lg:!top-20'
            onClick={() =>
              document
                .querySelector('#ShootingDoges')
                ?.setAttribute('style', 'display: flex;')
            }
          >
            <img
              className="dogelogo lg:max-w-[450px] mb-5"
              src="/images/caramelo.svg"
              alt="Caramelo Coin"
            />
          </a>
          <h1
            id="title"
            className="d_text_display d_span_opacity comic-neue font-bold lg:text-7xl lg:mb-3 xs:text-5xl" 
          >
            <span id="dynamic_c">C</span>ARAMELOCOIN
          </h1>
          <p
            className="subtitle poppins fw-light text-white"
            style={{
              fontSize: '1.2rem',
              marginBottom: '20px',
            }}
          >
            a MEMECOIN do Brasil
          </p>
          <ConnectButton />
        </div>
      </div>

      <main>
        <div id="o-que-e-a-caramelo-coin" className="pt-5">
          <div className="xs:!w-[90%]">
            <div className="row">
              <div className="col-md-6">
                <div className="kabosu-content">
                  <h2
                    className="title display-5 text-start text-dark comic-neue"
                    id="sobre"
                  >
                    O que é a Caramelo Coin?
                  </h2>
                  <p className="fs-3 lh-md comic-neue">
                    Uma moeda digital que transforma a vida dos cachorros de rua &nbsp;
                    <span className="fs-3 fw-bold text-warning comic-neue">
                     e&nbsp; resgata a essência dos caramelos, verdadeiros ícones do
                      Brasil.
                    </span>
                  </p>
                  <p className="lh-md comic-neue">
                    No coração da CarameloCoin, está um movimento criptográfico
                    dedicado a apoiar ONGs que lutam diariamente para dar
                    dignidade e um lar para os amados cachorros “caramelo”. Esta
                    criptomoeda de código aberto utiliza a tecnologia
                    blockchain, garantindo um sistema descentralizado e seguro
                    de armazenamento de informações, mantendo uma rede robusta e
                    solidária. Mais do que isso, porém, é o espírito do
                    CarameloCoin: um projeto que une comunidade, empatia e o
                    amor pelos cães vira-latas, ícones nacionais. Junte-se a
                    este movimento vibrante e seja parte da mudança!
                  </p>
                </div>
              </div>
              <div className="col-md-6 parent">
                <div>
                  <img
                    className="over"
                    src="/images/caramelos.webp"
                    alt="Caramelos"
                    data-aos="fade-left"
                  />
                </div>
                <br />
                <br />
              </div>
            </div>
            <div className="row">
              <div className="col-md-12">
                <div className="kabosu-content" style={{ minWidth: '100%' }}>
                  <h2
                    className="title display-5 text-start text-dark comic-neue"
                    style={{ marginBottom: '20px' }}
                  >
                    Como começar!
                  </h2>
                  <br />
                  <br />
                  <div className="row">
                    <div
                      className="col-sm-4 parent-numbers"
                      data-aos="fade-left"
                      data-aos-offset="100"
                      data-aos-delay="10"
                      data-aos-duration="1000"
                    >
                      <h3>
                        <span className="badge bg-secondary">01</span> Escolha
                        sua carteira
                        <br />
                        &nbsp;
                      </h3>
                      <p>
                        Uma carteira Metamask ou Trust Wallet é necessária para
                        pessoas que desejam usar, negociar ou manter
                        CarameloCoin. Você pode escolher uma carteira e começar!
                      </p>
                      <br />
                    </div>
                    <div
                      className="col-sm-4 parent-numbers"
                      data-aos="fade-right"
                      data-aos-offset="100"
                      data-aos-delay="10"
                      data-aos-duration="1000"
                    >
                      <h3>
                        <span className="badge bg-secondary">02</span> Compre
                        BNB
                      </h3>
                      <p>
                        Compre BNB através de uma corretora centralizada como a
                        Binance ou descentralizada como a PancakeSwap e envie os
                        BNB para sua carteira.
                      </p>
                    </div>
                    <br />
                    <div
                      className="col-sm-4 parent-numbers"
                      data-aos="fade-left"
                      data-aos-offset="100"
                      data-aos-delay="10"
                      data-aos-duration="1000"
                    >
                      <h3>
                        <span className="badge bg-secondary">03</span> Conectar
                        Carteira
                        <br />
                        &nbsp;
                      </h3>
                      <p>
                        Conecte sua carteira clicando no botão &quot;Conectar
                        Carteira&quot; e faça a troca dos seus BNB para
                        Caramelo.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

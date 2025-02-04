import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useIsMobile } from '../../../hooks/useMobile';

/* eslint-disable @next/next/no-img-element */
export const Hero = () => {
  const isMobile = useIsMobile();


  return (
    <div
      id="video-container"
      style={{
        position: 'relative',
        width: '100vw',
        height: '100vh',
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
          className="lg:!relative lg:!top-20"
          onClick={() =>
            document
              .querySelector('#ShootingDoges')
              ?.setAttribute('style', 'display: flex;')
          }
        >
          <img
            style={{
              marginTop: '0rem !important',
              width: isMobile ? '308px' : '100%',
            }}
            className="dogelogo lg:max-w-[450px]"
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

        <div className="sm:flex sm:gap-6 xs:flex-col xs:gap-6 xs:space-y-4 sm:items-center">
          <div className="xs:w-full xs:text-center">
            <ConnectButton />
          </div>

          <div className="xs:w-full xs:text-center xs:pb-4">
            <a
              href="https://www.youtube.com/watch?v=KOr2ttjv1jU"
              id="how-to-buy"
              className="hover:!bg-slate-100 hover:!text-gray-900 transition-all duration-300 xs:w-full xs:text-center"
            >
              Como comprar?
            </a>
          </div>
        </div>
      </div>
    </div>
  );
};

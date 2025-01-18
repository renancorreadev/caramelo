import { useEffect } from 'react';
import AOS from 'aos';
import 'aos/dist/aos.css';
import { useIsMobile } from '../../../hooks/useMobile';

/* eslint-disable @next/next/no-img-element */
export const PageContent = () => {
  const isMobile = useIsMobile();

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

  return (
    <main id="home-page">
      <div id="o-que-e-a-caramelo-coin" className="pt-5">
        <div className="container p-5 xs:!flex-col xs:!pb-0">
          <div className="row">
            <div className="col-md-6 xs:!pt-0">
              <div className="kabosu-content xs:!pt-0">
                <h2
                  className="xs:!text-center title display-5 sm:text-start text-dark comic-neue xs:!my-12 sm:!mt-0"
                  id="sobre"
                >
                  O que é a Caramelo Coin?
                </h2>
                <p className="fs-3 lh-md comic-neue sm:!my-4">
                  Uma moeda digital que transforma a vida dos cachorros de rua{' '}
                  <span className="fs-3 fw-bold text-warning comic-neue">
                    e resgata a essência dos caramelos, verdadeiros ícones do
                    Brasil.
                  </span>
                </p>
                <p className="lh-md comic-neue">
                  No coração da CarameloCoin, está um movimento criptográfico
                  dedicado a apoiar ONGs que lutam diariamente para dar
                  dignidade e um lar para os amados cachorros “caramelo”. Esta
                  criptomoeda de código aberto utiliza a tecnologia blockchain,
                  garantindo um sistema descentralizado e seguro de
                  armazenamento de informações, mantendo uma rede robusta e
                  solidária. Mais do que isso, porém, é o espírito do
                  CarameloCoin: um projeto que une comunidade, empatia e o amor
                  pelos cães vira-latas, ícones nacionais. Junte-se a este
                  movimento vibrante e seja parte da mudança!
                </p>
              </div>
            </div>
            <div className={`col-md-6 ${isMobile ? '' : 'parent'}`}>
              <div>
                <img
                  className="over"
                  src="/images/caramelos.webp"
                  alt="Caramelos"
                />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-12">
              <div className="kabosu-content" style={{ minWidth: '100%' }}>
                <h2
                  id="text"
                  className="title display-5 sm:text-start xs:text-center text-dark comic-neue title-h2 xs:!mt-12"
                  style={{ marginBottom: '20px' }}
                >
                  Como começar!
                </h2>
                <br />
                <br />
                <div className="row xs:gap-y-[0px]  sm:gap-y-4 xs:!flex-col xs:!flex-nowrap">
                  <div
                    className="col-sm-4 parent-numbers xs:!h-48"
                    data-aos="fade-left"
                    data-aos-offset="100"
                    data-aos-delay="10"
                    data-aos-duration="1000"
                  >
                    <h3>
                      <span className="badge bg-secondary">01</span> Escolha sua
                      carteira
                      <br />
                      &nbsp;
                    </h3>
                    <p>
                      Uma carteira Metamask ou Trust Wallet é necessária para
                      pessoas que desejam usar, negociar ou manter CarameloCoin.
                      Você pode escolher uma carteira e começar!
                    </p>
                  </div>
                  <div
                    className="col-sm-4 parent-numbers xs:!h-48"
                    data-aos="fade-right"
                    data-aos-offset="100"
                    data-aos-delay="10"
                    data-aos-duration="1000"
                  >
                    <h3>
                      <span className="badge bg-secondary">02</span> Compre BNB
                    </h3>
                    <p>
                      Compre BNB através de uma corretora centralizada como a
                      Binance ou descentralizada como a PancakeSwap e envie os
                      BNB para sua carteira.
                    </p>
                  </div>
                  <div
                    className="col-sm-4 parent-numbers xs:!h-48"
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
                      Carteira&quot; e faça a troca dos seus BNB para Caramelo.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div id="community" className="community">
        <div className="container">
          <div className="grid grid-cols-2 gap-4 pb-5 doge-graphics xs:grid-cols-1 sm:grid-cols-2 sm:!p-[3rem]">
            {['c1.jpg', 'c2.jpg', 'c5.jpg', 'c4.jpg'].map((image, index) => (
              <div
                className="col-span-1 flex justify-center items-center"
                data-aos="fade-up"
                data-aos-offset="100"
                data-aos-delay="10"
                data-aos-duration="1000"
                key={index}
              >
                <div className="doge_letter_image">
                  <img
                    src={`/images/${image}`}
                    alt={`d letter img ${index + 1}`}
                    className="doge-graphics-letter"
                  />
                </div>
              </div>
            ))}
          </div>

          <div className="">
            <div
              className={`row pb-5 ${isMobile ? 'kabosu-content' : ''}`}
              data-aos="fade-down"
              data-aos-offset="100"
              data-aos-delay="10"
              data-aos-duration="1000"
            >
              <h2
                style={{ marginTop: '0 !important' }}
                id="text"
                className={`
                    xs:text-center sm:text-start text-xl font-bold text-dark comic-neue text-left pt-3 title-h2
                    xs:text-2xl xs:!mt-0  sm:!px-[3rem]
                    sm:text-3xl sm:pt-6 
                    text-dark 
                `}
              >
                Por Que Investir na Caramelo Coin?
              </h2>
            </div>
            <div className="row pb-5">
              <div className="col-lg-6 xs:kabosu-content ">
                <ul className="mt-4 space-y-6 text-left text-gray-700 text-base xs:text-sm lg:text-xl">
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
                        font-bold text-yellow-500 text-base 
                        xs:text-[1rem]
                        lg:text-xl    
                    `}
                    >
                      Impacto Social Real:
                    </h3>
                    <p id="text" className="text-gray-700">
                      Cada transação apoia ONGs que resgatam e cuidam de cães
                      abandonados.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
                            font-bold text-yellow-500 text-base 
                            xs:text-[1rem]
                            lg:text-xl    
                        `}
                    >
                      Modelo Deflacionário:
                    </h3>
                    <p id="text" className="text-gray-700">
                      O valor dos tokens aumenta ao longo do tempo com um
                      mecanismo de queima automático.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
                        font-bold text-yellow-500 text-base 
                        xs:text-[1rem]
                        lg:text-xl    
                    `}
                    >
                      Segurança e Transparência:
                    </h3>
                    <p id="text" className="text-gray-700">
                      Baseada na Binance Smart Chain, garantindo transações
                      rápidas e seguras.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
                        font-bold text-yellow-500 text-base 
                        xs:text-[1rem]
                        lg:text-xl    
                    `}
                    >
                      Comunidade Engajada:
                    </h3>
                    <p id="text" className="text-gray-700">
                      Junte-se a um movimento que une tecnologia e amor pelos
                      animais.
                    </p>
                  </li>
                </ul>
              </div>

              <div className="col-lg-6 items-center flex">
                <img
                  src="/images/caramelocoin.png"
                  alt="Caramelo Coin"
                  style={{ maxWidth: '100%', height: 'auto', display: 'block' }}
                />
              </div>
            </div>
          </div>

          <div id="info-token-section" className="sm:pb-5 xs:pb-4 sm:!px-[3rem]">
            <div id="info-text" className={`info-section ${isMobile ? 'kabosu-content' : ''}`}>
              <h2
                style={{ marginTop: 0 }}
                className={`
                  sm:text-start xs:text-center title-h2 sm:text-4xl font-bold text-gray-800 comic-neue mb-10  sm:!pt-8
                  xs:text-2xl  xs:!pt-8
                `}
              >
                Informações de Token
              </h2>
            </div>

            <div id="info-section" className="info-section pt-4">
              <div className="container mx-auto px-4 lg:px-8 xs:!flex-col">
                <div className="w-full flex flex-wrap xs:flex-col lg:flex-nowrap sm:pb-6 ">
                  <div className="w-full lg:w-1/2 flex flex-col sm:px-2">
                    <div className="flex-1 bg-white shadow-lg rounded-lg p-6 md:p-10">
                      <h3
                        style={{ marginTop: 0 }}
                        id="text"
                        className={`
                          text-3xl font-bold text-gray-800 comic-neue mb-6 text-center
                          xs:text-4xl sm:text-5xl
                        `}
                      >
                        Token
                      </h3>
                      <ul className="gap-2 text-gray-800 text-lg xs:text-sm lg:text-xl flex flex-col items-start text-start">
                        <li className="flex xs:flex-col items-start gap-4">
                          <svg
                            className="w-8 h-8 text-yellow-600 flex-shrink-0 xs:hidden"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          <span className="comic-neue text-lg">
                            <strong>Nome:</strong> Caramelo Coin
                          </span>
                        </li>
                        <li className="flex xs:flex-col items-start gap-4">
                          <svg
                            className="w-8 h-8 text-yellow-600 flex-shrink-0 xs:hidden"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          <span className="comic-neue text-lg">
                            <strong>Símbolo:</strong> CARAMELO
                          </span>
                        </li>
                        <li className="flex xs:flex-col items-start gap-4">
                          <svg
                            className="w-8 h-8 text-yellow-600 flex-shrink-0 xs:hidden"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          <span className="comic-neue text-lg">
                            <strong>Supply Total:</strong>{' '}
                            420,000,000,000,000,000
                          </span>
                        </li>
                        <li className="flex xs:flex-col items-start gap-4">
                          <svg
                            className="w-8 h-8 text-yellow-600 flex-shrink-0 xs:hidden"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          <span className="comic-neue text-lg">
                            <strong>Contrato:</strong>
                            <a
                              href="https://bscscan.com/token/0xe600B09584619274984CB58a2C2ac9A954D6e349"
                              target="_blank"
                              rel="noopener noreferrer"
                            >
                              0xe6...e349
                            </a>
                          </span>
                        </li>
                      </ul>
                    </div>
                  </div>
                  <div className="w-full lg:w-1/2 xs:py-4 flex flex-col sm:px-2">
                    <div className="flex-1 bg-white shadow-lg rounded-lg p-6 md:p-10">
                      <h3
                        style={{ marginTop: 0 }}
                        id="text"
                        className={`
              text-3xl font-bold text-gray-800 comic-neue mb-6 text-center
              xs:text-4xl sm:text-5xl
            `}
                      >
                        Pré-venda
                      </h3>
                      <div className="overflow-x-auto">
                        <table className="table-auto w-full text-left border-collapse">
                          <thead>
                            <tr>
                              <th className="border-b-2 py-2 px-4 text-lg text-gray-800 comic-neue">
                                1 BNB
                              </th>
                              <th className="border-b-2 py-2 px-4 text-lg text-gray-800 comic-neue">
                                Tokens
                              </th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue">
                                Fase 1
                              </td>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue">
                                5,250,000,000.000000000
                              </td>
                            </tr>
                            <tr>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue">
                                Fase 2
                              </td>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue">
                                4,000,000,000.000000000
                              </td>
                            </tr>
                            <tr>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue  ">
                                Fase 3
                              </td>
                              <td className="border-b py-2 px-4 text-gray-700 comic-neue">
                                3,000,000,000.000000000
                              </td>
                            </tr>
                            <tr>
                              <td className="py-2 px-4 text-gray-700 comic-neue">
                                Tokens
                              </td>
                              <td className="py-2 px-4 text-gray-700 comic-neue">
                                42,000,000,000.000000000
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/** Whitepaper */}
          <div id="whitepaper" className="sm:!px-[3rem]">
            <div
              className={`row pb-5 ${isMobile ? 'kabosu-content' : ''}`}
              style={{ paddingTop: '0 !important' }}
            >
              <div className="col-lg-6">
                <h2
                  id="text"
                  className={`
                    sm:text-start xs:text-center text-xl font-bold text-dark comic-neue text-left pt-3 title-h2
                    xs:text-2xl xs:!mt-0 xs:!mb-12
                    sm:text-3xl sm:pt-6 sm:!mt-0
                `}
                >
                  Distribuição de tokens
                </h2>

                <ul className="mt-4 space-y-6 text-left text-gray-700 text-base xs:text-sm lg:text-xl">
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
        font-bold text-yellow-500 text-base 
        xs:text-[1rem]
        lg:text-xl    
      `}
                    >
                      50% - Comunidade
                    </h3>
                    <p className="text-gray-700">
                      Distribuição para a comunidade através de campanhas de
                      adoção e incentivos ao uso do token.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
        font-bold text-yellow-500 text-base 
        xs:text-[1rem]
        lg:text-xl    
      `}
                    >
                      15% - ONGs
                    </h3>
                    <p className="text-gray-700">
                      Direcionado diretamente para apoiar ONGs parceiras e
                      iniciativas sociais.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
        font-bold text-yellow-500 text-base 
        xs:text-[1rem]
        lg:text-xl    
      `}
                    >
                      10% - Marketing
                    </h3>
                    <p className="text-gray-700">
                      Recursos alocados para promover o token e atrair novos
                      usuários.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
                      font-bold text-yellow-500 text-base 
                      xs:text-[1rem]
                      lg:text-xl    
                    `}
                    >
                      20% - Equipes
                    </h3>
                    <p className="text-gray-700">
                      Recompensa e motivação para as equipes fundadoras, com 10%
                      alocados para cada uma das duas equipes principais.
                    </p>
                  </li>
                  <li className="flex flex-col gap-1 xs:gap-2">
                    <h3
                      className={`
        font-bold text-yellow-500 text-base 
        xs:text-[1rem]
        lg:text-xl    
      `}
                    >
                      5% - Desenvolvedores
                    </h3>
                    <p className="text-gray-700">
                      Garantia de suporte técnico e manutenção do projeto.
                    </p>
                  </li>
                </ul>
              </div>
              <div className="col-lg-6 items-center flex">
                <img
                  src="/images/Tokenomics.png"
                  alt="Tokenomics Caramelo Coin"
                  style={{ maxWidth: '100%', height: 'auto', display: 'block' }}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
};

import { useEffect } from 'react';
import AOS from 'aos';
import 'aos/dist/aos.css';

/* eslint-disable @next/next/no-img-element */
export const PageContent = () => {
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
    <main>
      <div id="o-que-e-a-caramelo-coin" className="pt-5">
        <div className="container p-5">
          <div className="row">
            <div className="col-md-6 xs:!pt-0">
              <div className="kabosu-content xs:!pt-0">
                <h2
                  className="title display-5 text-start text-dark comic-neue xs:!mt-0"
                  id="sobre"
                >
                  O que é a Caramelo Coin?
                </h2>
                <p className="fs-3 lh-md comic-neue">
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
            <div className="col-md-6 parent">
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
                  className="title display-5 text-start text-dark comic-neue"
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
          <div className="grid grid-cols-2 gap-4 pb-5 doge-graphics xs:grid-cols-1 sm:grid-cols-2">
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

          <div>
            <div
              className="row pb-5"
              data-aos="fade-down"
              data-aos-offset="100"
              data-aos-delay="10"
              data-aos-duration="1000"
            ></div>
            <div className="row pb-5">
              <div className="col-lg-6">
                <img
                  src="/images/caramelocoin.png"
                  alt="Caramelo Coin"
                  style={{ maxWidth: '100%', height: 'auto', display: 'block' }}
                />
              </div>
              <div className="col-lg-6">
                <h2
                  id="text"
                  className={`
                    text-xl font-bold text-dark comic-neue text-left pt-3
                    xs:text-2xl xs:pt-5 xs:text-center
                    sm:text-3xl sm:pt-6 sm:text-center
                    text-dark 
                `}
                >
                  Por Que Investir na Caramelo Coin?
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
                    <p id="text"className="text-gray-700">
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
            </div>
          </div>

          {/** Whitepaper */}
          <div id="whitepaper">
            <div className="row pb-5">
              <div className="col-lg-6">
                <h2
                  id="text"
                  className={`
                    text-xl font-bold text-dark comic-neue text-left pt-3 
                    xs:text-2xl xs:pt-5 xs:text-start
                    sm:text-3xl sm:pt-6 sm:text-start sm:!mt-0
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

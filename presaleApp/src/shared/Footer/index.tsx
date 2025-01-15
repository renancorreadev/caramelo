/* eslint-disable @next/next/no-html-link-for-pages */
/* eslint-disable @next/next/no-img-element */
import React from 'react';

export const Footer = () => {
  return (
    <footer>
      <div className="footer-container">
        <img
          className="footer-image"
          src="images/footer-map.png"
          alt="Footer Map"
        />
        <div className="footer-row">
          <div className="footer-column1" style={{ paddingTop: '10px' }}>
            <div className="logo">
              <img
                src="images/caramelologoicone.png"
                alt="Caramelo Coin logo"
              />
              <div className="logo-labels">
                <div id="footer-text" className="comic-neue flex justify-center items-center text-center text-black ">
                  CARAMELOCOIN
                </div>
              </div>
            </div>
            <p id="footer-pg" style={{ paddingTop: '10px' }}   className="comic-neue flex justify-center items-center text-center xs:flex ">
              O cachorro caramelo é um símbolo icônico no Brasil, representando
              os cães vira-latas encontrados em todo o país e conhecidos por
              sua lealdade e resiliência. A CarameloCoin foi criada com o
              propósito de ajudar esses cães em situação de rua, promovendo
              adoções e apoiando ONGs dedicadas à causa animal. A ideia da
              CarameloCoin se inspira no amor e respeito pelos famosos
              “caramelos”, que são um patrimônio dos brasileiros.
            </p>
          </div>
          <div className="footer-column">
            <ul>
              <li>
                <a href="/">Home</a>
              </li>
              <li>
                <a href="https://www.caramelocoin.com/#o-que-e-a-caramelo-coin">
                  O que é a Caramelo Coin?
                </a>
              </li>
              <li>
                <a href="https://www.caramelocoin.com/como-comprar">Como comprar a Caramelo Coin?</a>
              </li>
              <li>
                <a
                  href="https://mont.ink/caramelocoin"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Loja
                </a>
              </li>
              <li>
                <a href="https://www.caramelocoin.com/#community">Comunidade</a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/docs/Caramelo-Coin-Roadmap.pdf"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Roadmap
                </a>
              </li>
              <li>
                <a href="https://www.caramelocoin.com/marca-registrada">Marca Registrada</a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/o-que-e-uma-memecoin"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  O que é uma Meme Coin?
                </a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/docs/Caramelo-Coin-Roadmap.pdf"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Whitepaper
                </a>
              </li>
            </ul>
          </div>
          <div className="footer-column">{/* Placeholder */}</div>
          <div className="footer-column">{/* Placeholder */}</div>
        </div>
      </div>
      <div className="footer">
        <div className="footer__inner">
          <div
            className="footer__content"
            style={{ display: 'block', textAlign: 'center' }}
          >
            <div className="row">
              <p style={{ textAlign: 'center' }} className="comic-neue">
                A Caramelo Coin® não é uma recomendação de investimento. Uso
                exclusivamente para causas sociais.
              </p>
              <br />
              <p style={{ textAlign: 'center' }} className="comic-neue">
                © 2024 | CarameloCoin | Todos os direitos reservados
              </p>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;

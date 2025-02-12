/* eslint-disable @next/next/no-img-element */
/* eslint-disable @next/next/no-html-link-for-pages */
'use client';
import React, { useState } from 'react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { trackEvent } from '@/utils/bpixel';

export const Header: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  // Função para alternar o estado do menu
  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <header id="header" className="header">
      <span className="header__inner">
        <a href="/" style={{ textDecoration: 'none' }}>
          <div className="logo navbar-brand">
            <img src="images/caramelo-coin-logo.png" alt="CarameloCoin logo" />
          </div>
        </a>
        <nav className="header__right">
          <style jsx>{`
            .dogecoinswag {
              display: none;
            }

            @media (max-width: 960px) {
              .menu {
                width: 100% !important;
                display: ${isMenuOpen ? 'block' : 'none'}; /* Controla a visibilidade */
              }

              .menu__inner a {
                font-size: 1.4rem !important;
              }

              .dogecoinswag {
                display: inherit;
              }

              .dogecoinswagicon {
                display: none;
              }
            }

            .fa-shirt {
              color: #ccc !important;
            }

            .fa-shirt:hover {
              color: #ffc107 !important;
            }

            .dogeathon {
              color: #333;
            }

            .dogeathon:hover {
              color: #333 !important;
            }
          `}</style>
          <nav className="menu">
            <ul className="menu__inner ">
              <li>
                <a href="https://www.caramelocoin.com" className="comic-neue tooltip-body-sub">
                  Home
                </a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/#o-que-e-a-caramelo-coin"
                  className="comic-neue tooltip-body-sub"
                >
                  A Caramelo Coin
                </a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/como-comprar"
                  className="comic-neue tooltip-body-sub"
                >
                  Como Comprar
                </a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/docs/Caramelo-Coin-Roadmap.pdf"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="comic-neue tooltip-body-sub"
                >
                  Roadmap
                </a>
              </li>
              <li>
                <a
                  href="https://www.caramelocoin.com/o-que-e-uma-memecoin"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="comic-neue tooltip-body-sub"
                >
                  O que são Memecoins?
                </a>
              </li>
              <li>
                <a
                  href="https://prevenda.caramelocoin.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="comic-neue tooltip-body-sub"
                >
                  Pré-Venda
                </a>
              </li>

              <li id="connect-button" className="tooltip" role="tooltip opacity1"  onClick={() => trackEvent("Connect Wallet")}> 
                <ConnectButton label="Conectar" />
              </li>
            </ul>
          </nav>
          <span className="menu-trigger" onClick={toggleMenu}>
            <svg
              width="24"
              height="24"
              xmlns="http://www.w3.org/2000/svg"
              fillRule="evenodd"
              clipRule="evenodd"
            >
              <path d="M24 18v1H0v-1h24zm0-6v1H0v-1h24zm0-6v1H0V6h24z" fill="#1040e2"></path>
              <path d="M24 19H0v-1h24v1zm0-6H0v-1h24v1zm0-6H0V6h24v1z"></path>
            </svg>
          </span>
          <span className="theme-toggle not-selectable">
            <svg
              className="theme-toggler"
              width="24"
              height="24"
              viewBox="0 0 48 48"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            ></svg>
          </span>
          <div
            className="locale"
            style={{ marginLeft: '0', marginRight: '10px' }}
          >
            <a href="/"></a>
            <div className="current-locale">
              <a href="/"></a>
            </div>
          </div>
        </nav>
      </span>
    </header>
  );
};

export default Header;

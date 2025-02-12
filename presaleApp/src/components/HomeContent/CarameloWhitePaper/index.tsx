'use client';

import React from 'react';
import { trackEvent } from "@/utils/bpixel";


const CarameloPresalePage = () => {
  const handleRedirect = () => {
    window.location.href = 'https://caramelocoin.com';
    trackEvent("Read", { method: "Read White Paper" }); 
 
  };

  return (
    <div className="w-full min-h-screen bg-gradient-to-b from-gray-900 via-gray-800 to-gray-900 text-white flex flex-col items-center ">
      <div className="w-full p-8 bg-gray-800 rounded-2xl shadow-xl">
        <h1 className="text-4xl font-extrabold text-yellow-400 mb-6 text-center">
          🚀 Caramelo Coin Pré-Venda 🚀
        </h1>
        <p className="text-lg text-center text-gray-300 mb-8">
          Seja parte da revolução que transforma vidas! Invista na Caramelo Coin
          e ajude os nossos queridos cães caramelo enquanto faz parte de uma
          inovação tecnológica no mundo das criptomoedas.
        </p>

        <section className="mb-8">
          <h2 className="text-2xl font-bold text-yellow-300 mb-4">
            Por Que Investir na Caramelo Coin?
          </h2>
          <ul className="list-disc list-inside space-y-4 text-gray-300">
            <li>
              <strong>Impacto Social Real:</strong> Cada transação apoia ONGs
              que resgatam e cuidam de cães abandonados.
            </li>
            <li>
              <strong>Modelo Deflacionário:</strong> O valor dos tokens aumenta
              ao longo do tempo com um mecanismo de queima automático.
            </li>
            <li>
              <strong>Segurança e Transparência:</strong> Baseada na Binance
              Smart Chain, garantindo transações rápidas e seguras.
            </li>
            <li>
              <strong>Comunidade Engajada:</strong> Junte-se a um movimento que
              une tecnologia e amor pelos animais.
            </li>
          </ul>
        </section>

        <section className="mb-8">
          <h2 className="text-2xl font-bold text-yellow-300 mb-4">
            Como Funciona?
          </h2>
          <div className="space-y-4">
            <p>
              Com a <strong>Caramelo Coin</strong>, cada compra, venda ou
              transferência destina uma porcentagem para ONGs parceiras. Isso
              garante alimentação, cuidados veterinários e adoção para cães
              caramelo.
            </p>
            <ul className="list-decimal list-inside space-y-2 text-gray-300">
              <li>
                <strong>Transações Beneficentes:</strong> Parte das taxas vai
                direto para projetos de proteção animal.
              </li>
              <li>
                <strong>Queima Automática:</strong> Tokens são queimados em cada
                transação, valorizando o supply restante.
              </li>
              <li>
                <strong>Blockchain Pública:</strong> Transparência total em
                todas as movimentações.
              </li>
            </ul>
          </div>
        </section>

        <section className="mb-8">
          <h2 className="text-2xl font-bold text-yellow-300 mb-4">
            Distribuição de Tokens
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-gray-300">
            <div>
              <h3 className="font-bold text-lg text-yellow-400 mb-2">
                50% - Comunidade
              </h3>
              <p>
                Distribuição através de campanhas de adoção e incentivos ao uso
                do token.
              </p>
            </div>
            <div>
              <h3 className="font-bold text-lg text-yellow-400 mb-2">
                20% - ONGs e Iniciativas
              </h3>
              <p>Direcionado diretamente para apoiar ONGs parceiras.</p>
            </div>
            <div>
              <h3 className="font-bold text-lg text-yellow-400 mb-2">
                20% - Equipe
              </h3>
              <p>
                Recompensa e motivação para a equipe fundadora e consultores.
              </p>
            </div>
            <div>
              <h3 className="font-bold text-lg text-yellow-400 mb-2">
                10% - Infraestrutura
              </h3>
              <p>Para garantir o funcionamento eficiente da rede.</p>
            </div>
          </div>
        </section>

        <section className="text-center">
          <h2 className="text-2xl font-bold text-yellow-300 mb-4">
            Junte-se ao Movimento!
          </h2>
          <p className="text-lg text-gray-300 mb-6">
            Não perca a chance de transformar vidas e fazer parte de uma nova
            era nas criptomoedas. Invista na Caramelo Coin agora mesmo!
          </p>
          <button
            id="leia-mais" 
            onClick={handleRedirect}
            className="bg-yellow-400 text-gray-900 font-bold py-3 px-6 rounded-lg shadow-md hover:bg-yellow-500 transition-all duration-300"
          >
            Leia mais!
          </button>
        </section>
      </div>
    </div>
  );
};

export default CarameloPresalePage;

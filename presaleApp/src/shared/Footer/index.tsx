import React from 'react';

export const Footer = () => {
  return (
    <footer className="bg-gray-800 text-white py-6">
      <div className="xs:mx-6 footer__content text-center pt-4">
        <div className="row pt-4" style={{paddingTop: "1.5rem", paddingBottom: "1.5rem"}}>
          <p className="comic-neue text-center text-sm md:text-base pb-4">
            A Caramelo Coin® não é uma recomendação de investimento. Uso exclusivamente para causas sociais.
          </p>
          <br />
          <br />
          <p className="comic-neue text-center text-sm md:text-base">
            © 2024 | CarameloCoin | Todos os direitos reservados
          </p>
        </div>
      </div>
    </footer>
  );
};



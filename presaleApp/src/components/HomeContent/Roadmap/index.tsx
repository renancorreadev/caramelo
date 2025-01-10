export const Roadmap = () => {
    const phases = [
      {
        title: "Fase 1: Lançamento e Parcerias (Q1 2024)",
        activities: [
          "Início da venda inicial da CarameloCoin, voltada para atrair investidores e apoiadores da causa.",
          "Estabelecimento de parcerias com ONGs de proteção animal, principalmente as que ajudam cachorros.",
          "Abertura da loja oficial com produtos como bonés, camisetas e outros itens, com parte do lucro destinada à causa.",
        ],
      },
      {
        title: "Fase 2: Lançamento e Parcerias (Q2 2024)",
        activities: [
          "Disponibilizar CarameloCoin para negociação na PancakeSwap.",
          "Registrar a CarameloCoin nas principais plataformas de rastreamento de criptomoedas, como CoinGecko e CoinMarketCap.",
        ],
      },
      {
        title: "Fase 3: CarameloSwap e Listagens em Corretoras (Q3 2025)",
        activities: [
          "Apresentação da exchange descentralizada, CarameloSwap, própria para negociações de CarameloCoin.",
          "Listagem da CarameloCoin em duas corretoras (nomes a serem definidos).",
        ],
      },
      {
        title: "Fase 4: Grande Corretora e Evento de Queima (Q4 2025)",
        activities: [
          "Listar a CarameloCoin em uma corretora de grande porte para aumentar a liquidez e visibilidade.",
          "Realização de um evento de queima para reduzir a oferta de CarameloCoin, valorizando a moeda.",
        ],
      },
    ];
  
    return (
      <div className="bg-gray-700 text-white p-8 rounded-2xl shadow-lg mx-auto">
        <h2 className="text-3xl font-extrabold text-carameloAccent mb-6 text-center">
          📈 Roadmap 📈
        </h2>
        {phases.map((phase, index) => (
          <div key={index} className="mb-6">
            <h3 className="text-xl font-bold mb-2 text-yellow-400">{phase.title}</h3>
            <ul className="list-disc list-inside text-gray-300">
              {phase.activities.map((activity, idx) => (
                <li key={idx} className="mb-2">
                  {activity}
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    );
  };
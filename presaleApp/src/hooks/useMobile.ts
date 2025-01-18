import { useState, useEffect } from "react";

/**
 * Hook personalizado para detectar se o dispositivo atual é mobile
 * com base em um breakpoint de largura de tela.
 * @param {number} breakpoint - Largura máxima para ser considerado mobile (padrão: 768px).
 * @returns {boolean} - Retorna true se estiver no mobile, false caso contrário.
 */
export function useIsMobile(breakpoint = 768) {
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    // Função para verificar a largura da tela
    const checkIsMobile = () => {
      setIsMobile(window.innerWidth <= breakpoint);
    };

    // Verificação inicial
    checkIsMobile();

    // Adiciona um listener para mudanças na largura da tela
    window.addEventListener("resize", checkIsMobile);

    // Limpa o listener quando o componente é desmontado
    return () => {
      window.removeEventListener("resize", checkIsMobile);
    };
  }, [breakpoint]);

  return isMobile;
}

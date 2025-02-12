

export const initFacebookPixel = async (pixelId: string) => {
    if (typeof window !== 'undefined') {
      const ReactPixel = (await import('react-facebook-pixel')).default; // 🚀 Importação dinâmica
      ReactPixel.init(pixelId);
      ReactPixel.pageView();
    }
  };
  
  export const trackEvent = async (eventName: string, data: object = {}) => {
    if (typeof window !== 'undefined') {
      const ReactPixel = (await import('react-facebook-pixel')).default;
      
      // Lista de eventos padrão do Facebook
      const standardEvents = [
        "PageView", "Lead", "Purchase", "AddToCart", "InitiateCheckout",
        "Search", "ViewContent", "CompleteRegistration"
      ];
  
      if (standardEvents.includes(eventName)) {
        ReactPixel.track(eventName, data); // 🚀 Evento padrão do Facebook
      } else {
        ReactPixel.trackCustom(eventName, data); // 🎯 Evento personalizado
      }
      
      console.log(`🔥 Evento "${eventName}" disparado para o Facebook Pixel!`, data);
    }
  };
  
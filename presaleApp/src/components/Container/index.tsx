"use client";

import React from "react";

interface ContainerProps {
  children: React.ReactNode;
  className?: string;
}

export const Container: React.FC<ContainerProps> = ({ children, className }) => {
  return (
    <div
      className={`relative w-full bg-gray-900 text-white flex flex-col items-center ${className}`}

    >
      {/* Contêiner do vídeo */}
      <div
        id="video-container"
        style={{
          position: "absolute",
          inset: 0,
          zIndex: 0, // Vídeo em segundo plano
          overflow: "hidden",
        }}
      >
        <video
          id="video-header"
          autoPlay
          playsInline
          loop
          muted
          style={{
            width: "100%",
            height: "100%",
            objectFit: "cover",
            opacity: 0.1,
          }}
        >
          <source src="/media/carameloheader.mp4" type="video/mp4" />
        </video>
      </div>

      {/* Contêiner para o conteúdo */}
      <div
        className="relative z-10 flex flex-col items-center w-full xs:py-[6rem] sm:py-[9rem]"
  
      >
        {children}
      </div>
    </div>
  );
};

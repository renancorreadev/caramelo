"use client";

import React from "react";

interface ContainerProps {
  children: React.ReactNode;
  className?: string;
}

export const Container: React.FC<ContainerProps> = ({ children, className }) => {
  return (
    <div
      className={`w-full min-h-screen bg-gray-900 text-white flex flex-col items-center justify-center relative overflow-hidden ${className}`}
    >
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-gray-900 to-gray-800"></div>

      {/* Contêiner do vídeo */}
      <div
        id="video-container"
        style={{
          position: 'relative',
          width: '100vw',
          height: '100vh', // Garante altura máxima para o vídeo
          overflow: 'hidden',
        }}
      >
        <video
          id="video-header"
          autoPlay
          playsInline
          loop
          muted
          style={{
            width: '100%',
            height: '100%',
            opacity: 0.1,
            objectFit: 'cover',
            position: 'absolute',
            top: 0,
            left: 0,
            zIndex: 0, // Coloca o vídeo atrás
          }}
        >
          <source src="/media/carameloheader.mp4" type="video/mp4" />
        </video>
      </div>

      {/* Contêiner para o conteúdo sobre o vídeo */}
      <div className="absolute  flex flex-col items-center justify-center z-10">
        {children}
      </div>
    </div>
  );
};

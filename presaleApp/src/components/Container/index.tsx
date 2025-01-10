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
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-gray-900 to-gray-900"></div>
      <div className="relative w-full h-full flex flex-col items-center justify-center">
        {children}
      </div>
    </div>
  );
};
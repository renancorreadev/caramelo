import React from "react";

interface ContainerProps {
  children: React.ReactNode;
  className?: string;
}

export const Container: React.FC<ContainerProps> = ({ children, className }) => {
  return (
    <div className={`w-full min-h-screen bg-gray-900 text-white flex flex-col items-center justify-center ${className}`}>
      {children}
    </div>
  );
};



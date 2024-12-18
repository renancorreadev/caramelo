"use client";
import React from "react";

interface ButtonProps {
  onClick: () => void;
  children: React.ReactNode;
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({ onClick, children, disabled }) => {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`w-full bg-carameloAccent text-white font-bold py-3 rounded-lg shadow-[0_4px_10px_rgba(255,215,0,0.5)] hover:bg-yellow-500 hover:text-gray-900 transition-all duration-300 ${
        disabled ? "opacity-50 cursor-not-allowed" : ""
      }`}
    >
      {children}
    </button>
  );
};

export default Button;
"use client";
import React from "react";

interface InputProps {
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  type?: string;
}

const Input: React.FC<InputProps> = ({ value, onChange, placeholder, type = "text" }) => {
  return (
    <input
      type={type}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      className="w-full p-3 rounded-lg bg-gray-700 border border-gray-600 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-carameloAccent"
    />
  );
};

export default Input;
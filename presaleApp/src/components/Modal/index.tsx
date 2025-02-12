import React from 'react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  children: React.ReactNode;
}

const Modal: React.FC<ModalProps> = ({ isOpen, onClose, children }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div className="bg-gray-800 text-white p-6 rounded-lg shadow-lg max-w-lg w-full">
        <button
          id="close-modal"
          onClick={onClose}
          className="text-gray-400 hover:text-gray-200 float-right"
        >
          &times;
        </button>
        {children}
      </div>
    </div>
  );
};

export default Modal;

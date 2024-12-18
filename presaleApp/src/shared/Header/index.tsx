import { ConnectButton } from '@rainbow-me/rainbowkit';
import React from 'react';
import Image from 'next/image';


export const Header = () => {
  return (
    <header className="bg-background text-foreground p-4 shadow-md">
      <div className="container mx-auto flex justify-between items-center">
        <div className="text-2xl font-bold">
         <Image src="/logo.png" alt="CarameloCoin" width={200} height={140} />
        </div>
        <nav className="space-x-4">
          <ConnectButton />
        </nav>
      </div>
    </header>
  );
};


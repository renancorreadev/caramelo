import { ConnectButton } from '@rainbow-me/rainbowkit';
import React from 'react';
import Image from 'next/image';
import Link from 'next/link';


export const Header = () => {
  return (
    <header className="bg-background text-foreground p-4 shadow-md">
      <div className="container mx-auto flex justify-between items-center">
        <div className="text-2xl font-bold">
          <Link href="https://caramelocoin.com" passHref>
            <Image
              src="/logo.png"
              alt="CarameloCoin"
              width={200}
              height={140}
              className="cursor-pointer"
            />
          </Link>
        </div>
        <nav className="space-x-4">
          <ConnectButton label="Conectar" />
        </nav>
      </div>
    </header>
  );
};

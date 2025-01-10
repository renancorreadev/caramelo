import { ConnectButton } from '@rainbow-me/rainbowkit';
import React from 'react';
import Image from 'next/image';
import Link from 'next/link';

// import { Magic } from 'magic-sdk';

// const customNodeOptions = {
//   rpcUrl: 'https://bsc-mainnet.infura.io/v3/60786ed4ffd74c75b4b0bb369cde55f7', // Custom RPC URL
//   chainId: 56, // Custom chain id
// }
// const magic = new Magic("pk_live_2359E91C3FFA732A", {
//   network: customNodeOptions
// });


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

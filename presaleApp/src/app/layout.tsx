import type { Metadata } from "next";
import { Header, Footer } from "../shared";
import { Comic_Neue } from 'next/font/google';
import "./globals.css";
import "../css/all.min.css";
import "../css/aos.css";
import "../css/bootstrap.min.css";
import "../css/flag-icon.min.css";
import "../css/main.css";

import '@rainbow-me/rainbowkit/styles.css';
import { Providers } from "./providers";

const comicNeue = Comic_Neue({
  subsets: ['latin'],
  weight: ['400', '700'], 
  display: 'swap',
  variable: '--font-comic-neue',
});

export const metadata: Metadata = {
  title: "Caramelo Pré venda",
  description: "Pre venda do token Caramelo",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR" className={comicNeue.variable}>
      <body className={`antialiased`}>
        <Providers>
          <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
            <Header />
            <main style={{ flexGrow: 1 }}>
              {children}
            </main>
            <Footer />
          </div>
        </Providers>
      </body>
    </html>
  );
}

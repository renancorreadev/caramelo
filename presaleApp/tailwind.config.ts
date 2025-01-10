import type { Config } from "tailwindcss";

export default {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
      },
      screens: {
        xs: { max: '640px' }, // Dispositivos até 400px
        sm: '640px',          // Tailwind padrão: até 640px
        md: '768px',          // Tailwind padrão: até 768px
        lg: {min: '1024px'},         // Tailwind padrão: até 1024px
        xl: '1280px',         // Tailwind padrão: até 1280px
        '2xl': '1536px',      // Tailwind padrão: até 1536px
      },
    },
  },
  plugins: [],
} satisfies Config;

import type { Metadata } from "next";
import "./globals.css";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

export const metadata: Metadata = {
  title: "TravelGPT — Descubra lugares incríveis perto de você",
  description:
    "Portal de turismo inteligente. Encontre restaurantes, hotéis, praias e atrações turísticas próximos à sua localização.",
  keywords: "turismo, viagem, restaurantes, hotéis, praias, atrações, perto de mim",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>
        <Navbar />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}

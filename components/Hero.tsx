import Link from 'next/link';

export default function Hero() {
  return (
    <section className="hero">
      <div className="hero-content">
        <div className="hero-badge">🌍 Descubra o Brasil</div>
        <h1>
          Explore lugares <br />
          <span className="gradient-text">incríveis perto de você</span>
        </h1>
        <p>
          Descubra restaurantes, praias, hotéis e atrações turísticas ao seu redor.
          O TravelGPT encontra as melhores experiências com base na sua localização.
        </p>
        <Link href="/explorar" className="hero-cta">
          📍 Explorar perto de mim
        </Link>
        <div className="hero-stats">
          <div>
            <div className="hero-stat-value">500+</div>
            <div className="hero-stat-label">Locais cadastrados</div>
          </div>
          <div>
            <div className="hero-stat-value">50+</div>
            <div className="hero-stat-label">Cidades</div>
          </div>
          <div>
            <div className="hero-stat-value">10+</div>
            <div className="hero-stat-label">Categorias</div>
          </div>
        </div>
      </div>
    </section>
  );
}

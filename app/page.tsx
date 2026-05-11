'use client';

import { useState, useEffect } from 'react';
import Hero from '../components/Hero';
import ListingCard from '../components/ListingCard';
import SkeletonCard from '../components/SkeletonCard';
import { useGeolocation } from '../hooks/useGeolocation';
import { useNearbyListings } from '../hooks/useNearbyListings';
import { supabase } from '../lib/supabase/client';
import Link from 'next/link';

interface Category {
  id: number;
  name: string;
  slug: string;
  icon: string | null;
  listing_count: number;
}

const categoryEmojis: Record<string, string> = {
  restaurante: '🍽️', hotel: '🏨', praia: '🏖️', museu: '🏛️',
  parque: '🌳', shopping: '🛍️', bar: '🍸', cafe: '☕',
  aventura: '🧗', cultural: '🎭', natureza: '🌿', noturno: '🌙',
};

export default function HomePage() {
  const geo = useGeolocation();
  const { listings, loading } = useNearbyListings({
    latitude: geo.latitude,
    longitude: geo.longitude,
    radiusMeters: 100000,
    limit: 6,
  });
  const [categories, setCategories] = useState<Category[]>([]);

  useEffect(() => {
    async function fetchCategories() {
      const { data } = await supabase.rpc('get_all_categories');
      if (data) setCategories(data);
    }
    fetchCategories();
  }, []);

  return (
    <>
      <Hero />

      {/* Categories */}
      {categories.length > 0 && (
        <section className="section">
          <div className="section-header">
            <div>
              <h2 className="section-title">Categorias</h2>
              <p className="section-subtitle">Explore por tipo de experiência</p>
            </div>
          </div>
          <div className="categories-scroll">
            {categories.map((cat) => (
              <Link key={cat.id} href={`/categorias/${cat.slug}`} className="category-pill">
                <span className="category-pill-icon">
                  {categoryEmojis[cat.slug] || '📍'}
                </span>
                {cat.name}
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Nearby */}
      <section className="section">
        <div className="section-header">
          <div>
            <h2 className="section-title">Perto de você</h2>
            <p className="section-subtitle">
              {geo.error ? 'Mostrando locais em São Paulo (localização padrão)' : 'Locais mais próximos à sua posição'}
            </p>
          </div>
          <Link href="/explorar" className="section-link">
            Ver todos →
          </Link>
        </div>

        {geo.permissionDenied && (
          <div className="location-prompt">
            <span>📍 Ative sua localização para resultados personalizados</span>
            <button onClick={geo.requestLocation}>Ativar</button>
          </div>
        )}

        <div className="listings-grid">
          {loading
            ? Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)
            : listings.length > 0
              ? listings.map((l) => <ListingCard key={l.id} listing={l} />)
              : (
                <div className="empty-state" style={{ gridColumn: '1 / -1' }}>
                  <div className="empty-state-icon">🗺️</div>
                  <h3>Nenhum local encontrado</h3>
                  <p>Ainda não há locais cadastrados nesta região. Volte em breve!</p>
                </div>
              )
          }
        </div>
      </section>
    </>
  );
}

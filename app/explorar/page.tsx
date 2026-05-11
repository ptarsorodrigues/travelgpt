'use client';

import { useState, useEffect } from 'react';
import ListingCard from '../../components/ListingCard';
import SkeletonCard from '../../components/SkeletonCard';
import { useGeolocation } from '../../hooks/useGeolocation';
import { useNearbyListings } from '../../hooks/useNearbyListings';
import { supabase } from '../../lib/supabase/client';


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

const radiusOptions = [
  { label: '5 km', value: 5000 },
  { label: '10 km', value: 10000 },
  { label: '25 km', value: 25000 },
  { label: '50 km', value: 50000 },
  { label: '100 km', value: 100000 },
];

export default function ExplorarPage() {
  const geo = useGeolocation();
  const [search, setSearch] = useState('');
  const [debouncedSearch, setDebouncedSearch] = useState('');
  const [radius, setRadius] = useState(50000);
  const [selectedCategory, setSelectedCategory] = useState<number | null>(null);
  const [categories, setCategories] = useState<Category[]>([]);

  const { listings, loading } = useNearbyListings({
    latitude: geo.latitude,
    longitude: geo.longitude,
    radiusMeters: radius,
    categoryId: selectedCategory,
    searchQuery: debouncedSearch,
    limit: 50,
  });

  useEffect(() => {
    const t = setTimeout(() => setDebouncedSearch(search), 400);
    return () => clearTimeout(t);
  }, [search]);

  useEffect(() => {
    async function fetchCategories() {
      const { data } = await supabase.rpc('get_all_categories');
      if (data) setCategories(data);
    }
    fetchCategories();
  }, []);

  return (
    <div style={{ paddingTop: '5rem' }}>
      <section className="section">
        <div className="section-header">
          <div>
            <h1 className="section-title">Explorar</h1>
            <p className="section-subtitle">
              Encontre locais próximos a você
            </p>
          </div>
        </div>

        {/* Filters */}
        <div className="filter-bar">
          <div className="search-bar-wrapper">
            <span className="search-icon">🔍</span>
            <input
              type="text"
              className="search-bar"
              placeholder="Buscar por nome..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
          <select
            className="radius-select"
            value={radius}
            onChange={(e) => setRadius(Number(e.target.value))}
          >
            {radiusOptions.map((o) => (
              <option key={o.value} value={o.value}>{o.label}</option>
            ))}
          </select>
        </div>

        {/* Category Pills */}
        <div className="categories-scroll" style={{ marginBottom: '2rem' }}>
          <button
            className={`category-pill ${selectedCategory === null ? 'active' : ''}`}
            onClick={() => setSelectedCategory(null)}
          >
            Todos
          </button>
          {categories.map((cat) => (
            <button
              key={cat.id}
              className={`category-pill ${selectedCategory === cat.id ? 'active' : ''}`}
              onClick={() => setSelectedCategory(selectedCategory === cat.id ? null : cat.id)}
            >
              <span className="category-pill-icon">
                {categoryEmojis[cat.slug] || '📍'}
              </span>
              {cat.name}
            </button>
          ))}
        </div>

        {/* Results */}
        <div className="listings-grid">
          {loading ? (
            Array.from({ length: 8 }).map((_, i) => <SkeletonCard key={i} />)
          ) : listings.length > 0 ? (
            listings.map((l) => <ListingCard key={l.id} listing={l} />)
          ) : (
            <div className="empty-state" style={{ gridColumn: '1 / -1' }}>
              <div className="empty-state-icon">🔍</div>
              <h3>Nenhum resultado encontrado</h3>
              <p>Tente aumentar o raio de busca ou alterar os filtros.</p>
            </div>
          )}
        </div>
      </section>
    </div>
  );
}

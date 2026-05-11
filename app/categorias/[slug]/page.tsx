'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import ListingCard from '../../../components/ListingCard';
import SkeletonCard from '../../../components/SkeletonCard';
import { useGeolocation } from '../../../hooks/useGeolocation';
import { useNearbyListings } from '../../../hooks/useNearbyListings';
import { supabase } from '../../../lib/supabase/client';
import Link from 'next/link';

const categoryEmojis: Record<string, string> = {
  restaurante: '🍽️', hotel: '🏨', praia: '🏖️', museu: '🏛️',
  parque: '🌳', shopping: '🛍️', bar: '🍸', cafe: '☕',
  aventura: '🧗', cultural: '🎭', natureza: '🌿', noturno: '🌙',
};

export default function CategoriaPage() {
  const params = useParams();
  const slug = params.slug as string;
  const geo = useGeolocation();
  const [category, setCategory] = useState<{ id: number; name: string; slug: string } | null>(null);

  useEffect(() => {
    async function fetchCategory() {
      const { data } = await supabase
        .from('categories')
        .select('id, name, slug')
        .eq('slug', slug)
        .single();
      if (data) setCategory(data);
    }
    fetchCategory();
  }, [slug]);

  const { listings, loading } = useNearbyListings({
    latitude: geo.latitude,
    longitude: geo.longitude,
    radiusMeters: 100000,
    categoryId: category?.id || null,
    limit: 50,
  });

  const emoji = categoryEmojis[slug] || '📍';

  return (
    <div style={{ paddingTop: '5rem' }}>
      <section className="section">
        <div className="section-header">
          <div>
            <Link href="/" className="detail-back">← Voltar</Link>
            <h1 className="section-title" style={{ marginTop: '0.5rem' }}>
              {emoji} {category?.name || slug}
            </h1>
            <p className="section-subtitle">Locais nesta categoria perto de você</p>
          </div>
        </div>

        <div className="listings-grid">
          {loading ? (
            Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)
          ) : listings.length > 0 ? (
            listings.map((l) => <ListingCard key={l.id} listing={l} />)
          ) : (
            <div className="empty-state" style={{ gridColumn: '1 / -1' }}>
              <div className="empty-state-icon">{emoji}</div>
              <h3>Nenhum local nesta categoria</h3>
              <p>Ainda não há locais cadastrados nesta categoria na sua região.</p>
            </div>
          )}
        </div>
      </section>
    </div>
  );
}

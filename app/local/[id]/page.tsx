'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { supabase } from '../../../lib/supabase/client';

interface ListingDetail {
  id: string;
  name: string;
  description: string | null;
  address: string;
  city: string;
  state: string;
  zip_code: string | null;
  latitude: number;
  longitude: number;
  phone: string | null;
  website: string | null;
  email: string | null;
  price_range: number | null;
  category_id: number | null;
  status: string;
}

interface Category {
  id: number;
  name: string;
  slug: string;
}

interface Photo {
  id: string;
  url: string;
  is_cover: boolean;
}

interface TagData {
  tag_id: number;
  tags: { name: string };
}

interface Hour {
  day_of_week: number;
  open_time: string;
  close_time: string;
}

const dayNames = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

export default function LocalPage() {
  const params = useParams();
  const id = params.id as string;
  const [listing, setListing] = useState<ListingDetail | null>(null);
  const [category, setCategory] = useState<Category | null>(null);
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [tags, setTags] = useState<string[]>([]);
  const [hours, setHours] = useState<Hour[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      setLoading(true);

      const { data: listingData } = await supabase
        .from('listings')
        .select('*')
        .eq('id', id)
        .single();

      if (listingData) {
        setListing(listingData);

        if (listingData.category_id) {
          const { data: catData } = await supabase
            .from('categories')
            .select('id, name, slug')
            .eq('id', listingData.category_id)
            .single();
          if (catData) setCategory(catData);
        }

        const { data: photoData } = await supabase
          .from('listing_photos')
          .select('id, url, is_cover')
          .eq('listing_id', id)
          .order('sort_order');
        if (photoData) setPhotos(photoData);

        const { data: tagData } = await supabase
          .from('listing_tags')
          .select('tag_id, tags(name)')
          .eq('listing_id', id);
        if (tagData) {
          setTags(tagData.map((t: TagData) => t.tags?.name).filter(Boolean));
        }

        const { data: hourData } = await supabase
          .from('listing_hours')
          .select('day_of_week, open_time, close_time')
          .eq('listing_id', id)
          .order('day_of_week');
        if (hourData) setHours(hourData);
      }

      setLoading(false);
    }

    if (id) fetchData();
  }, [id]);

  if (loading) {
    return (
      <div className="page-loading" style={{ paddingTop: '6rem' }}>
        <div className="spinner" />
      </div>
    );
  }

  if (!listing) {
    return (
      <div className="page-loading" style={{ paddingTop: '6rem' }}>
        <div className="empty-state">
          <div className="empty-state-icon">😕</div>
          <h3>Local não encontrado</h3>
          <p>Este local pode ter sido removido ou o link está incorreto.</p>
          <Link href="/explorar" className="detail-cta" style={{ marginTop: '1.5rem' }}>
            Voltar ao Explorar
          </Link>
        </div>
      </div>
    );
  }

  const coverPhoto = photos.find((p) => p.is_cover) || photos[0];
  const mapsUrl = `https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}`;

  return (
    <>
      {/* Hero Image */}
      <div className="detail-hero">
        {coverPhoto ? (
          <img src={coverPhoto.url} alt={listing.name} />
        ) : (
          <div className="detail-hero-placeholder">🏞️</div>
        )}
      </div>

      {/* Content */}
      <div className="detail-content">
        <Link href="/explorar" className="detail-back">← Voltar</Link>

        {category && <div className="detail-category">{category.name}</div>}

        <h1 className="detail-title">{listing.name}</h1>

        <div className="detail-location">
          📍 {listing.address}, {listing.city} - {listing.state}
        </div>

        {/* Description */}
        {listing.description && (
          <div className="detail-section">
            <h2>Sobre</h2>
            <p>{listing.description}</p>
          </div>
        )}

        {/* Info Grid */}
        <div className="detail-section">
          <h2>Informações</h2>
          <div className="detail-info-grid">
            {listing.phone && (
              <div className="detail-info-item">
                <span className="detail-info-icon">📞</span>
                <div>
                  <div className="detail-info-label">Telefone</div>
                  <div className="detail-info-value">{listing.phone}</div>
                </div>
              </div>
            )}
            {listing.website && (
              <div className="detail-info-item">
                <span className="detail-info-icon">🌐</span>
                <div>
                  <div className="detail-info-label">Website</div>
                  <div className="detail-info-value">
                    <a href={listing.website} target="_blank" rel="noopener noreferrer" style={{ color: 'var(--color-primary)' }}>
                      Visitar site
                    </a>
                  </div>
                </div>
              </div>
            )}
            {listing.email && (
              <div className="detail-info-item">
                <span className="detail-info-icon">✉️</span>
                <div>
                  <div className="detail-info-label">Email</div>
                  <div className="detail-info-value">{listing.email}</div>
                </div>
              </div>
            )}
            {listing.price_range && (
              <div className="detail-info-item">
                <span className="detail-info-icon">💰</span>
                <div>
                  <div className="detail-info-label">Faixa de preço</div>
                  <div className="detail-info-value" style={{ color: 'var(--color-secondary)' }}>
                    {'$'.repeat(listing.price_range)}
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Hours */}
        {hours.length > 0 && (
          <div className="detail-section">
            <h2>Horários</h2>
            <div className="detail-info-grid">
              {hours.map((h, i) => (
                <div key={i} className="detail-info-item">
                  <span className="detail-info-icon">🕐</span>
                  <div>
                    <div className="detail-info-label">{dayNames[h.day_of_week]}</div>
                    <div className="detail-info-value">
                      {h.open_time.slice(0, 5)} - {h.close_time.slice(0, 5)}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Tags */}
        {tags.length > 0 && (
          <div className="detail-section">
            <h2>Características</h2>
            <div className="detail-tags">
              {tags.map((tag, i) => (
                <span key={i} className="detail-tag">{tag}</span>
              ))}
            </div>
          </div>
        )}

        {/* Gallery */}
        {photos.length > 1 && (
          <div className="detail-section">
            <h2>Fotos</h2>
            <div className="gallery">
              {photos.map((photo) => (
                <div key={photo.id} className="gallery-item">
                  <img src={photo.url} alt={listing.name} loading="lazy" />
                </div>
              ))}
            </div>
          </div>
        )}

        {/* CTA */}
        <div className="detail-section" style={{ textAlign: 'center' }}>
          <a href={mapsUrl} target="_blank" rel="noopener noreferrer" className="detail-cta">
            🗺️ Como chegar
          </a>
        </div>
      </div>
    </>
  );
}

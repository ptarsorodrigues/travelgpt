import Link from 'next/link';
import { Listing } from '../hooks/useNearbyListings';

function PriceRange({ level }: { level: number | null }) {
  if (!level) return null;
  return (
    <span className="listing-card-price">
      {'$'.repeat(level)}
      <span style={{ opacity: 0.3 }}>{'$'.repeat(4 - level)}</span>
    </span>
  );
}

const categoryEmojis: Record<string, string> = {
  restaurante: '🍽️', hotel: '🏨', praia: '🏖️', museu: '🏛️',
  parque: '🌳', shopping: '🛍️', bar: '🍸', cafe: '☕',
  default: '📍',
};

export default function ListingCard({ listing }: { listing: Listing }) {
  const emoji = categoryEmojis[listing.category_slug || 'default'] || categoryEmojis.default;

  return (
    <Link href={`/local/${listing.id}`} className="listing-card">
      <div className="listing-card-image">
        {listing.cover_photo_url ? (
          <img src={listing.cover_photo_url} alt={listing.name} loading="lazy" />
        ) : (
          <div className="listing-card-placeholder">{emoji}</div>
        )}
        {listing.distance_km != null && (
          <div className="listing-card-distance">📍 {listing.distance_km} km</div>
        )}
        {listing.category_name && (
          <div className="listing-card-category-badge">{listing.category_name}</div>
        )}
      </div>
      <div className="listing-card-body">
        <div className="listing-card-name">{listing.name}</div>
        <div className="listing-card-address">
          {listing.address}, {listing.city}
        </div>
        <div className="listing-card-footer">
          <PriceRange level={listing.price_range} />
          <span className="listing-card-city">{listing.city}, {listing.state}</span>
        </div>
      </div>
    </Link>
  );
}

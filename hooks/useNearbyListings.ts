'use client';

import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase/client';

export interface Listing {
  id: string;
  name: string;
  description: string | null;
  address: string;
  city: string;
  state: string;
  latitude: number;
  longitude: number;
  phone: string | null;
  website: string | null;
  price_range: number | null;
  category_name: string | null;
  category_slug: string | null;
  category_icon: string | null;
  cover_photo_url: string | null;
  distance_km: number;
}

interface UseNearbyListingsParams {
  latitude: number | null;
  longitude: number | null;
  radiusMeters?: number;
  categoryId?: number | null;
  searchQuery?: string;
  limit?: number;
}

export function useNearbyListings({
  latitude,
  longitude,
  radiusMeters = 50000,
  categoryId = null,
  searchQuery = '',
  limit = 20,
}: UseNearbyListingsParams) {
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchListings = useCallback(async () => {
    if (!latitude || !longitude) return;

    setLoading(true);
    setError(null);

    try {
      const { data, error: rpcError } = await supabase.rpc('get_nearby_listings', {
        user_lat: latitude,
        user_lng: longitude,
        radius_m: radiusMeters,
        category_filter: categoryId,
        search_query: searchQuery || null,
        result_limit: limit,
      });

      if (rpcError) {
        console.error('RPC Error:', rpcError);
        setError('Erro ao buscar locais próximos');
        setListings([]);
      } else {
        setListings(data || []);
      }
    } catch (err) {
      console.error('Fetch error:', err);
      setError('Erro de conexão');
      setListings([]);
    } finally {
      setLoading(false);
    }
  }, [latitude, longitude, radiusMeters, categoryId, searchQuery, limit]);

  useEffect(() => {
    const timer = setTimeout(fetchListings, 0);
    return () => clearTimeout(timer);
  }, [fetchListings]);

  return { listings, loading, error, refetch: fetchListings };
}

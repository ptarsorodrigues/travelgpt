'use client';

import { useState, useEffect, useCallback } from 'react';

interface GeolocationState {
  latitude: number | null;
  longitude: number | null;
  loading: boolean;
  error: string | null;
  permissionDenied: boolean;
}

// Fallback: centro de São Paulo
const DEFAULT_LAT = -23.5505;
const DEFAULT_LNG = -46.6333;

export function useGeolocation() {
  const [state, setState] = useState<GeolocationState>({
    latitude: null,
    longitude: null,
    loading: true,
    error: null,
    permissionDenied: false,
  });

  const requestLocation = useCallback(() => {
    if (!navigator.geolocation) {
      setState({
        latitude: DEFAULT_LAT,
        longitude: DEFAULT_LNG,
        loading: false,
        error: 'Geolocalização não suportada pelo navegador',
        permissionDenied: false,
      });
      return;
    }

    setState(prev => ({ ...prev, loading: true, error: null }));

    navigator.geolocation.getCurrentPosition(
      (position) => {
        setState({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
          loading: false,
          error: null,
          permissionDenied: false,
        });
      },
      (err) => {
        const permissionDenied = err.code === err.PERMISSION_DENIED;
        setState({
          latitude: DEFAULT_LAT,
          longitude: DEFAULT_LNG,
          loading: false,
          error: permissionDenied
            ? 'Permissão de localização negada'
            : 'Não foi possível obter sua localização',
          permissionDenied,
        });
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 300000, // 5 min cache
      }
    );
  }, []);

  useEffect(() => {
    const timer = setTimeout(requestLocation, 0);
    return () => clearTimeout(timer);
  }, [requestLocation]);

  return { ...state, requestLocation };
}

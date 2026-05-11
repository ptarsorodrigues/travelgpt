-- =============================================
-- TravelGPT — Funções RPC para o Supabase
-- Execute este SQL inteiro no SQL Editor do Supabase
-- Dashboard > SQL Editor > New Query > Cole e clique RUN
-- =============================================

-- ─────────────────────────────────────────
-- 1. BUSCA DE LOCAIS POR PROXIMIDADE
-- ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_nearby_listings(
  user_lat FLOAT,
  user_lng FLOAT,
  radius_m INT DEFAULT 10000,
  category_filter INT DEFAULT NULL,
  search_query TEXT DEFAULT NULL,
  result_limit INT DEFAULT 20
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  description TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  latitude NUMERIC,
  longitude NUMERIC,
  phone TEXT,
  website TEXT,
  price_range SMALLINT,
  category_name TEXT,
  category_slug TEXT,
  category_icon TEXT,
  cover_photo_url TEXT,
  distance_km NUMERIC
) LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.id,
    l.name,
    l.description,
    l.address,
    l.city,
    l.state,
    l.latitude,
    l.longitude,
    l.phone,
    l.website,
    l.price_range,
    c.name AS category_name,
    c.slug AS category_slug,
    c.icon AS category_icon,
    (SELECT p.url FROM listing_photos p WHERE p.listing_id = l.id AND p.is_cover = TRUE LIMIT 1) AS cover_photo_url,
    ROUND(ST_Distance(l.location, ST_MakePoint(user_lng, user_lat)::geography)::numeric / 1000, 1) AS distance_km
  FROM listings l
  LEFT JOIN categories c ON c.id = l.category_id
  WHERE l.status = 'active'
    AND ST_DWithin(l.location, ST_MakePoint(user_lng, user_lat)::geography, radius_m)
    AND (category_filter IS NULL OR l.category_id = category_filter)
    AND (search_query IS NULL OR l.name ILIKE '%' || search_query || '%')
  ORDER BY ST_Distance(l.location, ST_MakePoint(user_lng, user_lat)::geography)
  LIMIT result_limit;
END;
$$;

-- ─────────────────────────────────────────
-- 2. LISTAR CATEGORIAS COM CONTAGEM
-- ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_all_categories()
RETURNS TABLE (
  id INT,
  name TEXT,
  slug TEXT,
  icon TEXT,
  listing_count BIGINT
) LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.name,
    c.slug,
    c.icon,
    COUNT(l.id) AS listing_count
  FROM categories c
  LEFT JOIN listings l ON l.category_id = c.id AND l.status = 'active'
  GROUP BY c.id, c.name, c.slug, c.icon
  ORDER BY c.name;
END;
$$;

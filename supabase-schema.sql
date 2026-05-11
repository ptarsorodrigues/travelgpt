-- =============================================
-- TravelGPT — Schema do Banco de Dados
-- Execute este SQL NO SQL Editor do Supabase
-- Dashboard > SQL Editor > New Query > Cole e clique RUN
-- =============================================

-- ─────────────────────────────────────────
-- 1. CATEGORIAS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  icon TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────
-- 2. TAGS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────
-- 3. LISTINGS (LOCAIS)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  latitude NUMERIC(10, 7),
  longitude NUMERIC(10, 7),
  location GEOGRAPHY(POINT, 4326),
  category_id INTEGER REFERENCES categories(id),
  phone TEXT,
  website TEXT,
  price_range SMALLINT CHECK (price_range BETWEEN 1 AND 4),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Trigger para atualizar location a partir de lat/lng
CREATE OR REPLACE FUNCTION update_listing_location()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
    NEW.location := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326)::geography;
  END IF;
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_listing_location
  BEFORE INSERT OR UPDATE ON listings
  FOR EACH ROW EXECUTE FUNCTION update_listing_location();

-- ─────────────────────────────────────────
-- 4. LISTING_PHOTOS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listing_photos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  listing_id UUID REFERENCES listings(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  is_cover BOOLEAN DEFAULT FALSE,
  caption TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────
-- 5. LISTING_TAGS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listing_tags (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  listing_id UUID REFERENCES listings(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(listing_id, tag_id)
);

-- ─────────────────────────────────────────
-- 6. LISTING_HOURS (Horários de funcionamento)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listing_hours (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  listing_id UUID REFERENCES listings(id) ON DELETE CASCADE,
  day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  open_time TEXT,
  close_time TEXT,
  is_closed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(listing_id, day_of_week)
);

-- ─────────────────────────────────────────
-- ÍNDICES PARA PERFORMANCE
-- ─────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_listings_category ON listings(category_id);
CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status);
CREATE INDEX IF NOT EXISTS idx_listings_city_state ON listings(city, state);
CREATE INDEX IF NOT EXISTS idx_listings_location ON listings USING gist(location);
CREATE INDEX IF NOT EXISTS idx_listing_photos_listing ON listing_photos(listing_id);
CREATE INDEX IF NOT EXISTS idx_listing_tags_listing ON listing_tags(listing_id);
CREATE INDEX IF NOT EXISTS idx_listing_tags_tag ON listing_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_listing_hours_listing ON listing_hours(listing_id);

-- ─────────────────────────────────────────
-- Mensagem de sucesso
-- ─────────────────────────────────────────
SELECT '✅ Tabelas criadas com sucesso!' AS message;
SELECT 'Tables: categories, tags, listings, listing_photos, listing_tags, listing_hours' AS created;
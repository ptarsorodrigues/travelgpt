-- =============================================
-- TravelGPT — Políticas de Acesso Público (RLS)
-- Execute no SQL Editor do Supabase
-- Isso permite que o app leia os dados sem autenticação
-- =============================================

-- Habilitar RLS (caso não esteja)
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE listing_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE listing_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE listing_hours ENABLE ROW LEVEL SECURITY;

-- Permitir leitura pública (SELECT) em todas as tabelas necessárias
CREATE POLICY "Leitura pública de listings" ON listings
  FOR SELECT USING (true);

CREATE POLICY "Leitura pública de categories" ON categories
  FOR SELECT USING (true);

CREATE POLICY "Leitura pública de listing_photos" ON listing_photos
  FOR SELECT USING (true);

CREATE POLICY "Leitura pública de listing_tags" ON listing_tags
  FOR SELECT USING (true);

CREATE POLICY "Leitura pública de tags" ON tags
  FOR SELECT USING (true);

CREATE POLICY "Leitura pública de listing_hours" ON listing_hours
  FOR SELECT USING (true);

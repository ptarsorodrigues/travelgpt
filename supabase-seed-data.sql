-- =============================================
-- TravelGPT — Dados de Teste (Seed)
-- Execute no SQL Editor do Supabase APÓS o supabase-rpc-functions.sql
-- =============================================

-- ─────────────────────────────────────────
-- INSERIR CATEGORIAS (caso ainda não existam)
-- ─────────────────────────────────────────
INSERT INTO categories (name, slug, icon) VALUES
  ('Restaurante', 'restaurante', 'utensils'),
  ('Hotel', 'hotel', 'bed'),
  ('Praia', 'praia', 'umbrella-beach'),
  ('Museu', 'museu', 'landmark'),
  ('Parque', 'parque', 'trees'),
  ('Bar', 'bar', 'wine'),
  ('Café', 'cafe', 'coffee'),
  ('Shopping', 'shopping', 'shopping-bag'),
  ('Aventura', 'aventura', 'mountain'),
  ('Mirante', 'mirante', 'eye')
ON CONFLICT (slug) DO NOTHING;

-- ─────────────────────────────────────────
-- TAGS
-- ─────────────────────────────────────────
INSERT INTO tags (name) VALUES
  ('Pet Friendly'),
  ('Acessível'),
  ('Wi-Fi'),
  ('Estacionamento'),
  ('Ar Condicionado'),
  ('Vista para o mar'),
  ('Música ao vivo'),
  ('Delivery'),
  ('Reserva online'),
  ('Aceita cartão')
ON CONFLICT (name) DO NOTHING;

-- ─────────────────────────────────────────
-- LISTINGS — São Paulo
-- ─────────────────────────────────────────
INSERT INTO listings (name, description, address, city, state, latitude, longitude, category_id, phone, website, price_range, status) VALUES
(
  'A Casa do Porco',
  'Eleito um dos melhores restaurantes do mundo, especializado em pratos com carne suína preparados de formas criativas e surpreendentes. Ambiente descolado e menu degustação imperdível.',
  'Rua Araújo, 124 - República',
  'São Paulo', 'SP', -23.5435, -46.6447,
  (SELECT id FROM categories WHERE slug = 'restaurante'),
  '(11) 3258-2578', 'https://acasadoporco.com.br', 3, 'active'
),
(
  'Parque Ibirapuera',
  'O maior parque urbano de São Paulo, com lagos, museus, trilhas para caminhada e ciclismo, e amplas áreas verdes. Perfeito para passeios em família e atividades ao ar livre.',
  'Av. Pedro Álvares Cabral - Vila Mariana',
  'São Paulo', 'SP', -23.5874, -46.6576,
  (SELECT id FROM categories WHERE slug = 'parque'),
  NULL, 'https://parqueibirapuera.org', 1, 'active'
),
(
  'MASP - Museu de Arte de São Paulo',
  'Um dos museus mais importantes da América Latina, com acervo de mais de 11 mil obras, incluindo peças de Rembrandt, Van Gogh, Renoir e artistas brasileiros.',
  'Av. Paulista, 1578 - Bela Vista',
  'São Paulo', 'SP', -23.5614, -46.6558,
  (SELECT id FROM categories WHERE slug = 'museu'),
  '(11) 3149-5959', 'https://masp.org.br', 2, 'active'
),
(
  'Hotel Fasano São Paulo',
  'Hotel de luxo na Rua Vittorio Fasano, com design sofisticado, spa, piscina na cobertura com vista para a cidade e o renomado restaurante Fasano.',
  'Rua Vittorio Fasano, 88 - Jardim Paulista',
  'São Paulo', 'SP', -23.5672, -46.6716,
  (SELECT id FROM categories WHERE slug = 'hotel'),
  '(11) 3896-4000', 'https://fasano.com.br', 4, 'active'
),
(
  'Bar do Justo',
  'Bar clássico paulistano com petiscos tradicionais, cervejas artesanais e drinks autorais. Ambiente acolhedor com música ao vivo nos fins de semana.',
  'Rua Oscar Freire, 163 - Jardins',
  'São Paulo', 'SP', -23.5631, -46.6692,
  (SELECT id FROM categories WHERE slug = 'bar'),
  '(11) 3083-3903', NULL, 2, 'active'
),
(
  'Café Octavio',
  'Cafeteria premium com grãos selecionados de fazendas brasileiras. Métodos especiais de preparo, bolos artesanais e ambiente instagramável.',
  'Rua Oscar Freire, 523 - Jardins',
  'São Paulo', 'SP', -23.5628, -46.6731,
  (SELECT id FROM categories WHERE slug = 'cafe'),
  '(11) 3064-0089', NULL, 2, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Rio de Janeiro
-- ─────────────────────────────────────────
(
  'Praia de Copacabana',
  'A praia mais famosa do Brasil, com 4 km de extensão, calçadão icônico de pedras portuguesas, quiosques e vista para o Pão de Açúcar. Ponto turístico imperdível.',
  'Av. Atlântica - Copacabana',
  'Rio de Janeiro', 'RJ', -22.9711, -43.1823,
  (SELECT id FROM categories WHERE slug = 'praia'),
  NULL, NULL, 1, 'active'
),
(
  'Cristo Redentor',
  'Uma das Sete Maravilhas do Mundo Moderno, no topo do Morro do Corcovado a 710m de altitude. Vista panorâmica de 360° da cidade maravilhosa.',
  'Parque Nacional da Tijuca - Alto da Boa Vista',
  'Rio de Janeiro', 'RJ', -22.9519, -43.2105,
  (SELECT id FROM categories WHERE slug = 'mirante'),
  '(21) 2558-1329', 'https://cristoredentor.com.br', 2, 'active'
),
(
  'Confeitaria Colombo',
  'Fundada em 1894, é um dos cafés mais bonitos do mundo. Arquitetura art nouveau, espelhos belgas, vitrais e doces tradicionais portugueses.',
  'Rua Gonçalves Dias, 32 - Centro',
  'Rio de Janeiro', 'RJ', -22.9044, -43.1761,
  (SELECT id FROM categories WHERE slug = 'cafe'),
  '(21) 2505-1500', 'https://confeitariacolombo.com.br', 2, 'active'
),
(
  'Aprazível',
  'Restaurante em Santa Teresa com terraço em meio à Mata Atlântica. Culinária brasileira contemporânea com ingredientes orgânicos e vista deslumbrante da cidade.',
  'Rua Aprazível, 62 - Santa Teresa',
  'Rio de Janeiro', 'RJ', -22.9214, -43.1895,
  (SELECT id FROM categories WHERE slug = 'restaurante'),
  '(21) 2508-9174', 'https://aprazivel.com.br', 3, 'active'
),
(
  'Praia de Ipanema',
  'Praia mundialmente famosa, imortalizada pela bossa nova. Pôr do sol espetacular, ambiente jovem e vibrante. Posto 9 é ponto de encontro cultural.',
  'Av. Vieira Souto - Ipanema',
  'Rio de Janeiro', 'RJ', -22.9838, -43.2048,
  (SELECT id FROM categories WHERE slug = 'praia'),
  NULL, NULL, 1, 'active'
),
(
  'Belmond Copacabana Palace',
  'O hotel mais icônico do Brasil, inaugurado em 1923. Arquitetura art déco, piscina lendária, spa de classe mundial e localização privilegiada em Copacabana.',
  'Av. Atlântica, 1702 - Copacabana',
  'Rio de Janeiro', 'RJ', -22.9665, -43.1780,
  (SELECT id FROM categories WHERE slug = 'hotel'),
  '(21) 2548-7070', 'https://belmond.com', 4, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Florianópolis
-- ─────────────────────────────────────────
(
  'Praia da Joaquina',
  'Famosa pelas dunas e ondas perfeitas para surf. Paisagem deslumbrante com areias brancas e mar cristalino. Palco de campeonatos internacionais de surf.',
  'Praia da Joaquina - Lagoa da Conceição',
  'Florianópolis', 'SC', -27.6308, -48.4466,
  (SELECT id FROM categories WHERE slug = 'praia'),
  NULL, NULL, 1, 'active'
),
(
  'Ostradamus',
  'Restaurante especializado em ostras frescas cultivadas na região, frutos do mar e peixes grelhados. Ambiente rústico-chique à beira da lagoa.',
  'Rod. Baldicero Filomeno, 7640 - Ribeirão da Ilha',
  'Florianópolis', 'SC', -27.7115, -48.5678,
  (SELECT id FROM categories WHERE slug = 'restaurante'),
  '(48) 3337-5711', NULL, 3, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Salvador
-- ─────────────────────────────────────────
(
  'Pelourinho',
  'Centro histórico de Salvador, Patrimônio Mundial da UNESCO. Casarões coloniais coloridos, igrejas barrocas, música e cultura afro-brasileira por toda parte.',
  'Largo do Pelourinho - Centro Histórico',
  'Salvador', 'BA', -12.9731, -38.5108,
  (SELECT id FROM categories WHERE slug = 'museu'),
  NULL, 'https://salvador.ba.gov.br', 1, 'active'
),
(
  'Restaurante Paraíso Tropical',
  'Culinária baiana autêntica com moqueca, acarajé e vatapá. Ambiente tropical com vista para a Baía de Todos os Santos. Experiência gastronômica inesquecível.',
  'Rua Edgar Loureiro, 98 - Cabula',
  'Salvador', 'BA', -12.9627, -38.4623,
  (SELECT id FROM categories WHERE slug = 'restaurante'),
  '(71) 3334-5678', NULL, 2, 'active'
),
(
  'Praia do Farol da Barra',
  'Uma das praias mais bonitas de Salvador, ao lado do histórico Farol da Barra. Águas calmas, pôr do sol espetacular e quiosques à beira-mar.',
  'Av. Oceânica - Barra',
  'Salvador', 'BA', -13.0097, -38.5329,
  (SELECT id FROM categories WHERE slug = 'praia'),
  NULL, NULL, 1, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Gramado / Serra Gaúcha
-- ─────────────────────────────────────────
(
  'Lago Negro',
  'Lago artificial cercado por hortênsias e araucárias, com pedalinhos para alugar. Um dos cartões-postais mais bonitos de Gramado, especialmente no outono.',
  'Rua A.J. Renner - Planalto',
  'Gramado', 'RS', -29.3919, -50.8755,
  (SELECT id FROM categories WHERE slug = 'parque'),
  NULL, NULL, 1, 'active'
),
(
  'Colosseo Restaurante',
  'Fondue artesanal em ambiente alpino aconchegante. Especialidade em fondue de queijo, carne e chocolate. Reserva recomendada no inverno.',
  'Av. das Hortênsias, 1542 - Centro',
  'Gramado', 'RS', -29.3761, -50.8728,
  (SELECT id FROM categories WHERE slug = 'restaurante'),
  '(54) 3286-1672', NULL, 3, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Foz do Iguaçu
-- ─────────────────────────────────────────
(
  'Cataratas do Iguaçu',
  'Uma das Sete Maravilhas Naturais do Mundo. Conjunto de 275 quedas d''água com até 82m de altura. Experiência avassaladora em meio à Mata Atlântica.',
  'Rodovia das Cataratas, Km 18 - Parque Nacional',
  'Foz do Iguaçu', 'PR', -25.6953, -54.4367,
  (SELECT id FROM categories WHERE slug = 'aventura'),
  '(45) 3521-4400', 'https://cataratasdoiguacu.com.br', 2, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Recife / Porto de Galinhas
-- ─────────────────────────────────────────
(
  'Praia de Porto de Galinhas',
  'Eleita várias vezes a melhor praia do Brasil. Piscinas naturais com águas cristalinas, recifes de corais e jangadas tradicionais. Paraíso tropical.',
  'Porto de Galinhas - Ipojuca',
  'Ipojuca', 'PE', -8.5058, -35.0050,
  (SELECT id FROM categories WHERE slug = 'praia'),
  NULL, NULL, 1, 'active'
),
(
  'Instituto Ricardo Brennand',
  'Complexo cultural com castelo medieval, jardins, acervo de armas e obras de arte holandesas do período colonial. Um dos museus mais surpreendentes do Brasil.',
  'Alameda Antônio Brennand - Várzea',
  'Recife', 'PE', -8.0654, -34.9728,
  (SELECT id FROM categories WHERE slug = 'museu'),
  '(81) 2121-0352', 'https://institutoricardobrennand.org.br', 2, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Bonito / MS
-- ─────────────────────────────────────────
(
  'Rio Sucuri - Flutuação',
  'Flutuação em águas cristalinas com visibilidade de até 50 metros. Nade entre peixes coloridos em um dos rios mais transparentes do planeta.',
  'Rodovia Bonito-Bodoquena, Km 18',
  'Bonito', 'MS', -21.1567, -56.5033,
  (SELECT id FROM categories WHERE slug = 'aventura'),
  '(67) 3255-1234', NULL, 2, 'active'
),

-- ─────────────────────────────────────────
-- LISTINGS — Chapada dos Veadeiros
-- ─────────────────────────────────────────
(
  'Cachoeira Santa Bárbara',
  'Uma das cachoeiras mais bonitas do Brasil, com águas turquesa em meio ao cerrado. Trilha de dificuldade moderada com guia obrigatório.',
  'Comunidade Kalunga - Cavalcante',
  'Cavalcante', 'GO', -13.5900, -47.4580,
  (SELECT id FROM categories WHERE slug = 'aventura'),
  NULL, NULL, 1, 'active'
);

-- ─────────────────────────────────────────
-- ASSOCIAR TAGS AOS LISTINGS
-- ─────────────────────────────────────────
-- Pet Friendly para parques e praias
INSERT INTO listing_tags (listing_id, tag_id)
SELECT l.id, t.id
FROM listings l, tags t
WHERE l.name IN ('Parque Ibirapuera', 'Praia de Copacabana', 'Praia de Ipanema', 'Lago Negro')
  AND t.name = 'Pet Friendly'
ON CONFLICT DO NOTHING;

-- Wi-Fi para hotéis e cafés
INSERT INTO listing_tags (listing_id, tag_id)
SELECT l.id, t.id
FROM listings l, tags t
WHERE l.name IN ('Hotel Fasano São Paulo', 'Belmond Copacabana Palace', 'Café Octavio', 'Confeitaria Colombo')
  AND t.name = 'Wi-Fi'
ON CONFLICT DO NOTHING;

-- Acessível
INSERT INTO listing_tags (listing_id, tag_id)
SELECT l.id, t.id
FROM listings l, tags t
WHERE l.name IN ('MASP - Museu de Arte de São Paulo', 'Parque Ibirapuera', 'Hotel Fasano São Paulo')
  AND t.name = 'Acessível'
ON CONFLICT DO NOTHING;

-- Vista para o mar
INSERT INTO listing_tags (listing_id, tag_id)
SELECT l.id, t.id
FROM listings l, tags t
WHERE l.name IN ('Praia de Copacabana', 'Praia de Ipanema', 'Belmond Copacabana Palace', 'Aprazível', 'Praia do Farol da Barra')
  AND t.name = 'Vista para o mar'
ON CONFLICT DO NOTHING;

-- Aceita cartão
INSERT INTO listing_tags (listing_id, tag_id)
SELECT l.id, t.id
FROM listings l, tags t
WHERE l.name IN ('A Casa do Porco', 'Hotel Fasano São Paulo', 'Bar do Justo', 'Café Octavio', 'Colosseo Restaurante', 'Ostradamus')
  AND t.name = 'Aceita cartão'
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────
-- HORÁRIOS DE FUNCIONAMENTO (alguns exemplos)
-- ─────────────────────────────────────────
-- A Casa do Porco (Ter-Sáb)
INSERT INTO listing_hours (listing_id, day_of_week, open_time, close_time)
SELECT l.id, d.day, '12:00', '15:00'
FROM listings l, (VALUES (2),(3),(4),(5),(6)) AS d(day)
WHERE l.name = 'A Casa do Porco';

INSERT INTO listing_hours (listing_id, day_of_week, open_time, close_time)
SELECT l.id, d.day, '19:00', '23:00'
FROM listings l, (VALUES (2),(3),(4),(5),(6)) AS d(day)
WHERE l.name = 'A Casa do Porco';

-- MASP (Ter-Dom)
INSERT INTO listing_hours (listing_id, day_of_week, open_time, close_time)
SELECT l.id, d.day, '10:00', '18:00'
FROM listings l, (VALUES (0),(2),(3),(4),(5)) AS d(day)
WHERE l.name = 'MASP - Museu de Arte de São Paulo';

INSERT INTO listing_hours (listing_id, day_of_week, open_time, close_time)
SELECT l.id, 6, '10:00', '20:00'
FROM listings l
WHERE l.name = 'MASP - Museu de Arte de São Paulo';

-- Café Octavio (Seg-Sáb)
INSERT INTO listing_hours (listing_id, day_of_week, open_time, close_time)
SELECT l.id, d.day, '08:00', '19:00'
FROM listings l, (VALUES (1),(2),(3),(4),(5),(6)) AS d(day)
WHERE l.name = 'Café Octavio';

-- ─────────────────────────────────────────
-- VERIFICAÇÃO — conferir o que foi inserido
-- ─────────────────────────────────────────
SELECT
  l.name,
  l.city,
  l.state,
  c.name AS categoria,
  l.status,
  l.latitude,
  l.longitude
FROM listings l
LEFT JOIN categories c ON c.id = l.category_id
ORDER BY l.state, l.city, l.name;

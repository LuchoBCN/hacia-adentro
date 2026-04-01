-- ============================================================
--  Hacia Adentro — Esquema Supabase
--  Ejecuta este archivo en el SQL Editor de tu proyecto Supabase
-- ============================================================

-- Tabla principal de contenidos
CREATE TABLE content (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at    TIMESTAMPTZ DEFAULT now(),
  updated_at    TIMESTAMPTZ DEFAULT now(),

  -- Metadatos del contenido
  title         TEXT NOT NULL,
  description   TEXT,
  duration      TEXT,                          -- ej. "12 min"
  tag           TEXT,                          -- ej. "Principiante · Relajante"

  -- Fuente
  source        TEXT NOT NULL CHECK (source IN ('youtube', 'spotify', 'drive')),
  url           TEXT NOT NULL,                 -- URL original
  embed_url     TEXT,                          -- URL transformada para iframe

  -- Destino en la app
  section       TEXT NOT NULL CHECK (section IN (
                  'interior', 'crisis', 'sonar', 'sadhana', 'radio'
                )),

  -- Subsecciones (opcionales según sección)
  radio_theme   TEXT,    -- Para sección 'radio': tema libre (ansiedad, silencio...)
  sadhana_cat   TEXT CHECK (sadhana_cat IN (
                  'naturaleza', 'sentidos', 'movimiento', 'silencio', NULL
                )),
  file_type     TEXT CHECK (file_type IN (
                  'audio', 'video', 'pdf', 'imagen', NULL
                )),

  -- Control de publicación
  published     BOOLEAN DEFAULT true,
  sort_order    INTEGER DEFAULT 0             -- Para ordenar manualmente
);

-- Índices útiles
CREATE INDEX idx_content_section   ON content(section) WHERE published = true;
CREATE INDEX idx_content_source    ON content(source);
CREATE INDEX idx_content_published ON content(published);

-- Actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_content_updated_at
  BEFORE UPDATE ON content
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
--  Row Level Security (RLS)
--  Lee desde la app (anon), escribe solo desde el admin
-- ============================================================
ALTER TABLE content ENABLE ROW LEVEL SECURITY;

-- Cualquiera puede leer contenido publicado (la app de tu madre)
CREATE POLICY "lectura_publica"
  ON content FOR SELECT
  USING (published = true);

-- Solo usuarios autenticados pueden insertar / actualizar / borrar (tú desde el panel)
CREATE POLICY "escritura_autenticada"
  ON content FOR ALL
  USING (auth.role() = 'authenticated');

-- ============================================================
--  Tabla de temas de Radio Interior (dinámica)
--  Se puebla automáticamente al publicar contenido nuevo
-- ============================================================
CREATE TABLE radio_themes (
  id         SERIAL PRIMARY KEY,
  name       TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE radio_themes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lectura_temas"   ON radio_themes FOR SELECT USING (true);
CREATE POLICY "escritura_temas" ON radio_themes FOR ALL   USING (auth.role() = 'authenticated');

-- Seed de temas iniciales
INSERT INTO radio_themes (name) VALUES
  ('Ansiedad y calma'),
  ('Amor y relaciones'),
  ('Silencio y presencia'),
  ('Muerte y aceptación'),
  ('Propósito y sentido'),
  ('Cuerpo y energía');

-- ============================================================
--  Vista útil: contenido con embed listo por sección
-- ============================================================
CREATE VIEW content_by_section AS
  SELECT
    section,
    radio_theme,
    sadhana_cat,
    id, title, description, duration, tag, source, url, embed_url, file_type, sort_order
  FROM content
  WHERE published = true
  ORDER BY section, sort_order, created_at DESC;

GRANT SELECT ON content_by_section TO anon;

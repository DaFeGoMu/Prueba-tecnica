-- ============================================================
-- Punto 5 – Modelo de Datos: Visitas a Puntos de Gestión
-- ============================================================
-- Objetivo:
--   Registrar visitas realizadas a diferentes puntos de gestión
--   y construir un modelo analítico que permita:
--     1. Medir la distancia entre puntos (con coordenadas geográficas)
--     2. Identificar los puntos con mayor cantidad de visitas
--     3. Identificar los puntos donde más tiempo demoran las visitas
-- ============================================================


-- ------------------------------------------------------------
-- TABLAS MAESTRAS (dimensiones)
-- ------------------------------------------------------------

-- Tabla de gestores / agentes que realizan las visitas
CREATE TABLE gestores (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    nombre       VARCHAR(120)        NOT NULL,
    email        VARCHAR(120) UNIQUE NOT NULL,
    activo       TINYINT(1)          NOT NULL DEFAULT 1,
    created_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de puntos de gestión (cada lugar físico que se visita)
CREATE TABLE puntos_gestion (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    nombre       VARCHAR(150)        NOT NULL,
    direccion    VARCHAR(255),
    ciudad       VARCHAR(100),
    -- Coordenadas geográficas para cálculo de distancias
    latitud      DECIMAL(10, 8)      NOT NULL,
    longitud     DECIMAL(11, 8)      NOT NULL,
    activo       TINYINT(1)          NOT NULL DEFAULT 1,
    created_at   DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de motivos/tipos de visita (catálogo)
CREATE TABLE tipos_visita (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    nombre       VARCHAR(100)        NOT NULL,
    descripcion  TEXT
);


-- ------------------------------------------------------------
-- TABLA DE HECHOS (visitas)
-- ------------------------------------------------------------

CREATE TABLE visitas (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    punto_id        INT         NOT NULL,
    gestor_id       INT         NOT NULL,
    tipo_visita_id  INT,

    -- Marca de tiempo de inicio y fin de la visita
    inicio          DATETIME    NOT NULL,
    fin             DATETIME,                         -- NULL si aún no ha terminado

    -- Duración en minutos (calculada al cerrar la visita, para facilitar consultas)
    duracion_minutos INT GENERATED ALWAYS AS (
        TIMESTAMPDIFF(MINUTE, inicio, fin)
    ) STORED,

    observaciones   TEXT,
    created_at      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_visita_punto   FOREIGN KEY (punto_id)       REFERENCES puntos_gestion(id),
    CONSTRAINT fk_visita_gestor  FOREIGN KEY (gestor_id)      REFERENCES gestores(id),
    CONSTRAINT fk_visita_tipo    FOREIGN KEY (tipo_visita_id) REFERENCES tipos_visita(id)
);

-- Índices para acelerar las consultas analíticas más frecuentes
CREATE INDEX idx_visitas_punto   ON visitas (punto_id);
CREATE INDEX idx_visitas_gestor  ON visitas (gestor_id);
CREATE INDEX idx_visitas_inicio  ON visitas (inicio);


-- ============================================================
-- MODELO ANALÍTICO – Consultas de negocio
-- ============================================================


-- ------------------------------------------------------------
-- A) Distancia entre dos puntos usando la fórmula Haversine
--    (distancia en kilómetros sobre la superficie terrestre)
-- ------------------------------------------------------------
-- Se usa como función reutilizable en consultas de proximidad.
DELIMITER $$

CREATE FUNCTION distancia_km(
    lat1 DECIMAL(10,8), lon1 DECIMAL(11,8),
    lat2 DECIMAL(10,8), lon2 DECIMAL(11,8)
)
RETURNS DECIMAL(10,3)
DETERMINISTIC
BEGIN
    DECLARE R      DECIMAL(10,4) DEFAULT 6371;  -- Radio terrestre en km
    DECLARE dLat   DECIMAL(20,10);
    DECLARE dLon   DECIMAL(20,10);
    DECLARE a      DECIMAL(20,10);
    DECLARE c      DECIMAL(20,10);

    SET dLat = RADIANS(lat2 - lat1);
    SET dLon = RADIANS(lon2 - lon1);

    SET a = SIN(dLat / 2) * SIN(dLat / 2)
          + COS(RADIANS(lat1)) * COS(RADIANS(lat2))
          * SIN(dLon / 2) * SIN(dLon / 2);

    SET c = 2 * ATAN2(SQRT(a), SQRT(1 - a));

    RETURN R * c;
END$$

DELIMITER ;

-- Ejemplo: distancia entre el punto 1 y todos los demás puntos
SELECT
    p1.nombre                                      AS punto_origen,
    p2.nombre                                      AS punto_destino,
    ROUND(
        distancia_km(p1.latitud, p1.longitud, p2.latitud, p2.longitud),
    2)                                             AS distancia_km
FROM puntos_gestion p1
JOIN puntos_gestion p2 ON p1.id <> p2.id
WHERE p1.id = 1
ORDER BY distancia_km ASC;


-- ------------------------------------------------------------
-- B) Ranking de puntos con mayor cantidad de visitas
-- ------------------------------------------------------------
SELECT
    pg.id,
    pg.nombre                  AS punto,
    pg.ciudad,
    COUNT(v.id)                AS total_visitas,
    COUNT(DISTINCT v.gestor_id) AS gestores_distintos
FROM puntos_gestion pg
LEFT JOIN visitas v ON v.punto_id = pg.id
GROUP BY pg.id, pg.nombre, pg.ciudad
ORDER BY total_visitas DESC;


-- ------------------------------------------------------------
-- C) Puntos donde las visitas demoran más (promedio y máximo)
-- ------------------------------------------------------------
SELECT
    pg.id,
    pg.nombre                                       AS punto,
    COUNT(v.id)                                     AS total_visitas,
    ROUND(AVG(v.duracion_minutos), 1)               AS promedio_minutos,
    MAX(v.duracion_minutos)                         AS max_minutos,
    MIN(v.duracion_minutos)                         AS min_minutos
FROM puntos_gestion pg
JOIN visitas v ON v.punto_id = pg.id
WHERE v.fin IS NOT NULL   -- solo visitas completadas
GROUP BY pg.id, pg.nombre
ORDER BY promedio_minutos DESC;


-- ------------------------------------------------------------
-- D) Vista resumen combinada (para dashboard analítico)
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW vw_analitica_puntos AS
SELECT
    pg.id                                           AS punto_id,
    pg.nombre                                       AS punto_nombre,
    pg.ciudad,
    pg.latitud,
    pg.longitud,
    COUNT(v.id)                                     AS total_visitas,
    COUNT(DISTINCT v.gestor_id)                     AS gestores_distintos,
    ROUND(AVG(v.duracion_minutos), 1)               AS promedio_duracion_min,
    MAX(v.duracion_minutos)                         AS max_duracion_min,
    MAX(v.inicio)                                   AS ultima_visita
FROM puntos_gestion pg
LEFT JOIN visitas v ON v.punto_id = pg.id
GROUP BY pg.id, pg.nombre, pg.ciudad, pg.latitud, pg.longitud;

-- Uso de la vista
SELECT * FROM vw_analitica_puntos ORDER BY total_visitas DESC;

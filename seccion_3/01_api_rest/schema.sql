-- Tabla requerida por el endpoint GET /usuarios/recientes
CREATE TABLE IF NOT EXISTS usuarios (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    fecha_registro DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY idx_usuarios_fecha_registro (fecha_registro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

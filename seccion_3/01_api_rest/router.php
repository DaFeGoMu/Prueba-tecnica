<?php
/**
 * Router para el servidor embebido de PHP: redirige todo a index.php
 * para que la ruta /usuarios/recientes funcione sin Apache.
 *
 * Uso: php -S localhost:8080 router.php
 */

declare(strict_types=1);

$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/';

if ($uri !== '/' && file_exists(__DIR__ . $uri)) {
    return false;
}

require __DIR__ . '/index.php';

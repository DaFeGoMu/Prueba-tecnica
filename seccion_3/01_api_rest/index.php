<?php
/**
 * API REST – GET /usuarios/recientes 
 *
 * Devuelve en JSON los usuarios registrados en los últimos 30 días.
 * Tabla: usuarios (id, nombre, email, fecha_registro)
 *
 * Ejecución local: desde esta carpeta → php -S localhost:8080 router.php
 * Prueba: curl http://localhost:8080/usuarios/recientes
 */

declare(strict_types=1);

$config = require __DIR__ . '/config.php';

header('Content-Type: application/json; charset=utf-8');
header('X-Content-Type-Options: nosniff');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$uri    = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/';
$uri    = rtrim($uri, '/') ?: '/';

/**
 * Respuesta JSON unificada (compatible con documentación del ejercicio).
 *
 * @param array<string, mixed> $cuerpo
 */
function responderJson(array $cuerpo, int $statusCode = 200): void
{
    http_response_code($statusCode);
    echo json_encode($cuerpo, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR);
    exit;
}

// Solo el recurso indicado en la prueba
if ($uri !== '/usuarios/recientes') {
    responderJson([
        'success' => false,
        'error'   => 'Recurso no encontrado.',
    ], 404);
}

if ($method !== 'GET') {
    responderJson([
        'success' => false,
        'error'   => 'Método no permitido. Use GET.',
    ], 405);
}

try {
    $pdo = new PDO(
        $config['dsn'],
        $config['user'],
        $config['password'],
        $config['options']
    );

    $sql = "
        SELECT id, nombre, email, fecha_registro
        FROM usuarios
        WHERE fecha_registro >= NOW() - INTERVAL 30 DAY
        ORDER BY fecha_registro DESC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    $usuarios = $stmt->fetchAll();

    foreach ($usuarios as &$usuario) {
        if (isset($usuario['fecha_registro']) && $usuario['fecha_registro'] !== null) {
            $usuario['fecha_registro'] = date('Y-m-d H:i:s', strtotime((string) $usuario['fecha_registro']));
        }
    }
    unset($usuario);

    responderJson([
        'success' => true,
        'total'   => count($usuarios),
        'data'    => $usuarios,
    ], 200);
} catch (PDOException $e) {
    error_log('[API /usuarios/recientes] ' . $e->getMessage());
    responderJson([
        'success' => false,
        'error'   => 'Error interno del servidor. Intente más tarde.',
    ], 500);
} catch (JsonException $e) {
    error_log('[API JSON] ' . $e->getMessage());
    responderJson([
        'success' => false,
        'error'   => 'Error al generar la respuesta.',
    ], 500);
}

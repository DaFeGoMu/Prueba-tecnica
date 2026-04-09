<?php
/**
 * Configuración de base de datos (ajustar credenciales según entorno).
 * En producción, usar variables de entorno y no versionar secretos.
 */

declare(strict_types=1);

return [
    'dsn'      => 'mysql:host=127.0.0.1;dbname=prueba_tecnica;charset=utf8mb4',
    'user'     => 'root',
    'password' => '',
    'options'  => [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ],
];

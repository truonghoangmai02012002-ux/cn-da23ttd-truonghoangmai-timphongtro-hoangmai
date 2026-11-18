<?php

if (!defined('APP_ENV')) {
    require_once __DIR__ . '/config.php';
}

if (APP_ENV === 'local') {
    return [
        'host' => 'localhost',
        'dbname' => 'timphongtro',
        'user' => 'root',
        'pass' => '',
        'charset' => 'utf8mb4',
    ];
}

return [
    'host' => 'sqlXXX.infinityfree.com',
    'dbname' => 'if0_XXXX_timphongtro',
    'user' => 'if0_XXXX',
    'pass' => 'CHANGE_ME',
    'charset' => 'utf8mb4',
];
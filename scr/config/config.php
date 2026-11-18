<?php

$httpHost = strtolower((string) ($_SERVER['HTTP_HOST'] ?? 'localhost'));
$hostWithoutPort = preg_replace('/:\d+$/', '', $httpHost);
$isLocal = in_array($hostWithoutPort, ['localhost', '127.0.0.1'], true);

define('APP_ENV', $isLocal ? 'local' : 'production');
define('APP_NAME', 'Tìm Phòng Trọ Trà Vinh');

$scriptDirectory = str_replace('\\', '/', dirname((string) ($_SERVER['SCRIPT_NAME'] ?? '/index.php')));
$scriptDirectory = $scriptDirectory === '/' || $scriptDirectory === '.' ? '' : rtrim($scriptDirectory, '/');
$scheme = (
    (!empty($_SERVER['HTTPS']) && strtolower((string) $_SERVER['HTTPS']) !== 'off')
    || (int) ($_SERVER['SERVER_PORT'] ?? 0) === 443
) ? 'https' : 'http';
$baseUrl = $scheme . '://' . $httpHost . $scriptDirectory;
define('BASE_URL', rtrim($baseUrl, '/'));

define('ROOT_PATH', dirname(__DIR__));
define('APP_PATH', ROOT_PATH . DIRECTORY_SEPARATOR . 'app');
define('UPLOAD_PATH', ROOT_PATH . DIRECTORY_SEPARATOR . 'assets' . DIRECTORY_SEPARATOR . 'uploads');
define('UPLOAD_URL', BASE_URL . '/assets/uploads');
define('SCHOOL_LAT', 9.9215);
define('SCHOOL_LNG', 106.3425);
define('ITEMS_PER_PAGE', 9);
define('APP_DEBUG', $isLocal);

error_reporting(E_ALL);
ini_set('display_errors', APP_DEBUG ? '1' : '0');
date_default_timezone_set('Asia/Ho_Chi_Minh');

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
<?php

require_once __DIR__ . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'config.php';

require_once APP_PATH . DIRECTORY_SEPARATOR . 'core' . DIRECTORY_SEPARATOR . 'Database.php';
require_once APP_PATH . DIRECTORY_SEPARATOR . 'core' . DIRECTORY_SEPARATOR . 'Model.php';
require_once APP_PATH . DIRECTORY_SEPARATOR . 'core' . DIRECTORY_SEPARATOR . 'Controller.php';
require_once APP_PATH . DIRECTORY_SEPARATOR . 'core' . DIRECTORY_SEPARATOR . 'Router.php';

foreach (glob(APP_PATH . DIRECTORY_SEPARATOR . 'helpers' . DIRECTORY_SEPARATOR . '*.php') ?: [] as $helperFile) {
    require_once $helperFile;
}

$router = new Router();
$router->run();
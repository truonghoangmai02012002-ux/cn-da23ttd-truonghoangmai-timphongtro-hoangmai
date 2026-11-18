<?php

class Router
{
    public function run(): void
    {
        $url = $_GET['url'] ?? '';
        if (!is_string($url)) {
            $this->notFound();
            return;
        }

        $segments = array_values(array_filter(
            explode('/', trim($url, '/')),
            static fn ($segment) => $segment !== ''
        ));
        $controllerSegment = $segments[0] ?? 'home';
        $method = $segments[1] ?? 'index';

        if (!preg_match('/^[A-Za-z][A-Za-z0-9_]*$/D', $controllerSegment)
            || !preg_match('/^[A-Za-z][A-Za-z0-9_]*$/D', $method)
            || $method[0] === '_'
        ) {
            $this->notFound();
            return;
        }

        $controllerName = ucfirst($controllerSegment) . 'Controller';
        $controllerFile = APP_PATH . DIRECTORY_SEPARATOR . 'controllers'
            . DIRECTORY_SEPARATOR . $controllerName . '.php';
        if (!is_file($controllerFile)) {
            $this->notFound();
            return;
        }

        require_once $controllerFile;
        if (!class_exists($controllerName)) {
            $this->notFound();
            return;
        }

        $controller = new $controllerName();
        if (!is_callable([$controller, $method])) {
            $this->notFound();
            return;
        }

        $reflection = new ReflectionMethod($controller, $method);
        if (!$reflection->isPublic() || $reflection->isStatic()) {
            $this->notFound();
            return;
        }

        call_user_func_array([$controller, $method], array_map('rawurldecode', array_slice($segments, 2)));
    }

    private function notFound(): void
    {
        http_response_code(404);
        $notFoundFile = APP_PATH . DIRECTORY_SEPARATOR . 'views' . DIRECTORY_SEPARATOR
            . 'errors' . DIRECTORY_SEPARATOR . '404.php';

        if (is_file($notFoundFile)) {
            require $notFoundFile;
            return;
        }

        echo '404 - Not Found';
    }
}

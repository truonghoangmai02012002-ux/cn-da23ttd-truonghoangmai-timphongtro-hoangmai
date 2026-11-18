<?php

class Controller
{
    public function model(string $name)
    {
        $modelName = ucfirst($name);
        if (!preg_match('/^[A-Za-z][A-Za-z0-9_]*$/D', $modelName)) {
            throw new InvalidArgumentException('Invalid model name.');
        }

        $modelFile = APP_PATH . DIRECTORY_SEPARATOR . 'models' . DIRECTORY_SEPARATOR . $modelName . '.php';
        if (!is_file($modelFile)) {
            throw new RuntimeException('Model file not found: ' . $modelFile);
        }

        require_once $modelFile;
        if (!class_exists($modelName)) {
            throw new RuntimeException('Model class not found: ' . $modelName);
        }

        return new $modelName();
    }

    public function view(string $path, array $data = [], ?string $layout = 'main'): void
    {
        $viewPath = str_replace('\\', '/', trim($path, '/'));
        $segments = explode('/', $viewPath);
        if ($viewPath === '' || in_array('..', $segments, true) || in_array('.', $segments, true)) {
            throw new InvalidArgumentException('Invalid view path.');
        }

        $viewFile = APP_PATH . DIRECTORY_SEPARATOR . 'views' . DIRECTORY_SEPARATOR
            . implode(DIRECTORY_SEPARATOR, $segments) . '.php';
        if (!is_file($viewFile)) {
            throw new RuntimeException('View file not found: ' . $viewFile);
        }

        extract($data, EXTR_SKIP);
        ob_start();
        try {
            require $viewFile;
            $content = ob_get_clean();
        } catch (Throwable $exception) {
            ob_end_clean();
            throw $exception;
        }

        if ($layout === null || $layout === '') {
            echo $content;
            return;
        }

        if (!preg_match('/^[A-Za-z0-9_-]+$/D', $layout)) {
            throw new InvalidArgumentException('Invalid layout name.');
        }

        $layoutFile = APP_PATH . DIRECTORY_SEPARATOR . 'views' . DIRECTORY_SEPARATOR
            . 'layouts' . DIRECTORY_SEPARATOR . $layout . '.php';
        if (is_file($layoutFile)) {
            require $layoutFile;
            return;
        }

        echo $content;
    }

    public function redirect(string $path): void
    {
        header('Location: ' . url($path));
        exit;
    }

    public function json($data): void
    {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR);
    }

    public function isPost(): bool
    {
        return strtoupper((string) ($_SERVER['REQUEST_METHOD'] ?? 'GET')) === 'POST';
    }

    public function input(string $key, $default = null)
    {
        $value = $_POST[$key] ?? $default;

        return is_string($value) ? trim($value) : $value;
    }

    public function flash(string $key, $msg = null)
    {
        if ($msg !== null) {
            $_SESSION['_flash'][$key] = $msg;
            return null;
        }

        $message = $_SESSION['_flash'][$key] ?? null;
        unset($_SESSION['_flash'][$key]);

        return $message;
    }

    public function csrfToken(): string
    {
        if (empty($_SESSION['_csrf_token'])) {
            $_SESSION['_csrf_token'] = bin2hex(random_bytes(32));
        }

        return $_SESSION['_csrf_token'];
    }

    public function verifyCsrf(): bool
    {
        $submittedToken = $_POST['_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        $sessionToken = $_SESSION['_csrf_token'] ?? '';

        return is_string($submittedToken)
            && is_string($sessionToken)
            && $sessionToken !== ''
            && hash_equals($sessionToken, $submittedToken);
    }
}

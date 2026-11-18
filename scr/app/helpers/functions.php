<?php

function e($str): string
{
    return htmlspecialchars((string) $str, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function url(string $path = ''): string
{
    return BASE_URL . '/' . ltrim($path, '/');
}

function asset(string $path): string
{
    return url('assets/' . ltrim($path, '/'));
}

function formatPrice($n): string
{
    return number_format((float) $n, 0, ',', '.') . 'đ';
}

function isLoggedIn(): bool
{
    return currentUser() !== null;
}

function currentUser(): ?array
{
    $user = $_SESSION['user'] ?? null;

    return is_array($user) ? $user : null;
}

<?php

namespace Sandeepkumar\CredApp\Core;

class Router
{
    private array $routes = [];

    public function get(string $path, callable $handler): void
    {
        $this->routes['GET'][$path] = $handler;
    }

    public function post(string $path, callable $handler): void
    {
        $this->routes['POST'][$path] = $handler;
    }

    public function dispatch(string $uri, string $method): mixed
    {
        $uri = parse_url($uri, PHP_URL_PATH);

        $basePath = '/cred-app/public';

        if (str_starts_with($uri, $basePath)) {
            $uri = substr($uri, strlen($basePath));
        }

        $uri = '/' . trim($uri, '/');

        if ($uri === '//') {
            $uri = '/';
        }

        $handler = $this->routes[$method][$uri] ?? null;

        if ($handler === null) {
            http_response_code(404);
            return '404 - Page Not Found';
        }

        return call_user_func($handler);
    }
}

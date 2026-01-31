<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',          // ← Added: loads your api.php routes (with automatic /api prefix)
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // If you ever need to add/customize global middleware, do it here.
        // For CORS → no need to add anything extra here in Laravel 11+
        // The HandleCors middleware is already global by default.
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create();

<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProdukController;
use App\Http\Controllers\UmkmController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\BusinessController;
use App\Http\Controllers\WalikorongController;
use App\Http\Controllers\WalinagariController;
// Auth Routes (No need for Sanctum middleware here, registration and login don't need authentication)
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('profile', [AuthController::class, 'profile'])->middleware('auth:sanctum');
});



// Public Routes (No authentication required for listing and viewing products)
Route::get('produk', [ProdukController::class, 'index']);  // Show all products
Route::get('produk/{id}', [ProdukController::class, 'show']); // Show a specific product

// Produk Routes (Require Sanctum authentication for creating, updating, and deleting products)
Route::prefix('produk')->middleware('auth:sanctum')->group(function () {
    Route::post('/', [ProdukController::class, 'store']);    // Create a new product
    Route::put('{id}', [ProdukController::class, 'update']);  // Update a product
    Route::delete('{id}', [ProdukController::class, 'destroy']); // Delete a product
});

// Public Routes (No authentication required for listing and viewing UMKM)
Route::get('umkm', [BusinessController::class, 'index']);  // Show all UMKM
Route::get('umkm/{id}', [BusinessController::class, 'show']); // Show a specific UMKM

// UMKM Routes (Require Sanctum authentication for creating, updating, and deleting UMKM)
Route::prefix('umkm')->middleware('auth:sanctum')->group(function () {
    Route::post('/', [BusinessController::class, 'store']);    // Create a new UMKM
    Route::put('{id}', [BusinessController::class, 'update']);  // Update a specific UMKM
    Route::delete('{id}', [BusinessController::class, 'destroy']); // Delete a specific UMKM
});
// Admin Routes (Require Sanctum authentication and admin check)
Route::prefix('admin')->middleware(['auth:sanctum', 'is_admin'])->group(function () {
    Route::get('dashboard', [AdminController::class, 'dashboard']);
    Route::get('user', [AdminController::class, 'index']);
    Route::put('user/{id}', [AdminController::class, 'update']);
    Route::delete('user/{id}', [AdminController::class, 'destroy']);
});

// Walikorong Routes (Require Sanctum authentication)
Route::prefix('walikorong')->middleware('auth:sanctum')->group(function () {
    Route::get('/', [WalikorongController::class, 'index']);
    Route::post('/', [WalikorongController::class, 'store']);
    Route::put('{id}', [WalikorongController::class, 'update']);
    Route::delete('{id}', [WalikorongController::class, 'destroy']);
});
// Walinagari Routes (Require Sanctum authentication)
Route::prefix('walinagari')->middleware('auth:sanctum')->group(function () {
    Route::get('/', [WalinagariController::class, 'index']);
    Route::post('/', [WalinagariController::class, 'store']);
    Route::put('{id}', [WalinagariController::class, 'update']);
    Route::delete('{id}', [WalinagariController::class, 'destroy']);
});

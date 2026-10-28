<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\WishlistController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\NotificationController;

/*
|--------------------------------------------------------------------------
| API Routes for Online Book Store
|--------------------------------------------------------------------------
*/

// Public Authentication Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Public Book & Category Routes
Route::get('/books', [BookController::class, 'index']);
Route::get('/books/popular', [BookController::class, 'popular']);
Route::get('/books/latest', [BookController::class, 'latest']);
Route::get('/books/recommended', [BookController::class, 'recommended']);
Route::get('/books/{id}', [BookController::class, 'show']);
Route::get('/books/{id}/reviews', [ReviewController::class, 'index']);

Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/{id}', [CategoryController::class, 'show']);

// Protected Routes (Require Bearer Token / auth:sanctum)
Route::middleware('auth:sanctum')->group(function () {
    // Auth & Profile
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::post('/change-password', [AuthController::class, 'changePassword']);

    // Cart
    Route::get('/cart', [CartController::class, 'index']);
    Route::post('/cart', [CartController::class, 'store']);
    Route::put('/cart/{id}', [CartController::class, 'update']);
    Route::delete('/cart/{id}', [CartController::class, 'destroy']);
    Route::post('/cart/clear', [CartController::class, 'clear']);

    // Wishlist
    Route::get('/wishlist', [WishlistController::class, 'index']);
    Route::post('/wishlist', [WishlistController::class, 'store']);
    Route::delete('/wishlist/{id}', [WishlistController::class, 'destroy']);
    Route::get('/wishlist/check/{book_id}', [WishlistController::class, 'check']);

    // Orders
    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders', [OrderController::class, 'store']);
    Route::get('/orders/{id}', [OrderController::class, 'show']);
    Route::post('/orders/{id}/cancel', [OrderController::class, 'cancel']);

 // Notifications
Route::get('/notifications', [NotificationController::class, 'index']);
Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
Route::put('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);

    // Reviews
    Route::post('/reviews', [ReviewController::class, 'store']);
});

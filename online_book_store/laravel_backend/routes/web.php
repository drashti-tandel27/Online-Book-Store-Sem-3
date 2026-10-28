<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\BookController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\ReviewController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\NotificationController;
use App\Http\Controllers\Admin\SettingController;

use App\Models\Book;
use App\Models\Category;
use App\Models\Order;
use App\Models\User;

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes for Online Book Store Website
|--------------------------------------------------------------------------
*/


// =====================================================
// CUSTOMER WEBSITE
// =====================================================

Route::get('/', function () {

    $featuredBooks = Book::with('category')
        ->where('is_featured', true)
        ->take(6)
        ->get();

    $categories = Category::withCount('books')->get();

    return view(
        'welcome',
        compact('featuredBooks', 'categories')
    );

})->name('home');


Route::get('/books', function () {

    $books = Book::with('category')
        ->latest()
        ->paginate(12);

    $categories = Category::all();

    return view(
        'books.index',
        compact('books', 'categories')
    );

})->name('books.index');


Route::get('/books/{id}', function ($id) {

    $book = Book::with([
        'category',
        'reviews.user'
    ])->findOrFail($id);

    return view(
        'books.show',
        compact('book')
    );

})->name('books.show');


// =====================================================
// ADMIN AUTHENTICATION
// =====================================================

// Admin Login Page
Route::get('/admin/login', [AuthController::class, 'showLogin'])
    ->name('admin.login');

// Admin Login Submit
Route::post('/admin/login', [AuthController::class, 'login'])
    ->name('admin.login.submit');

// Admin Logout
Route::post('/admin/logout', [AuthController::class, 'logout'])
    ->name('admin.logout');


// =====================================================
// PROTECTED ADMIN PANEL
// =====================================================

Route::prefix('admin')
    ->name('admin.')
    ->middleware('admin')
    ->group(function () {


        // =================================================
        // DASHBOARD
        // =================================================

        Route::get('/', function () {

            $totalBooks = Book::count();
            $totalUsers = User::count();
            $totalOrders = Order::count();

            $totalRevenue = Order::where(
                'status',
                '!=',
                'Cancelled'
            )->sum('total_amount');

            $recentOrders = Order::with('user')
                ->latest()
                ->take(5)
                ->get();

            return view(
                'admin.dashboard',
                compact(
                    'totalBooks',
                    'totalUsers',
                    'totalOrders',
                    'totalRevenue',
                    'recentOrders'
                )
            );

        })->name('dashboard');


        // =================================================
        // BOOKS
        // =================================================

        Route::resource(
            'books',
            BookController::class
        );


        // =================================================
        // CATEGORIES
        // =================================================

        Route::resource(
            'categories',
            CategoryController::class
        );


        // =================================================
        // USERS
        // =================================================

        Route::get(
            'users',
            [UserController::class, 'index']
        )->name('users.index');

        Route::get(
            'users/{user}',
            [UserController::class, 'show']
        )->name('users.show');

        Route::delete(
            'users/{user}',
            [UserController::class, 'destroy']
        )->name('users.destroy');


        // =================================================
        // ORDERS
        // =================================================

        Route::resource(
            'orders',
            OrderController::class
        )->only([
            'index',
            'show',
            'update'
        ]);


        // =================================================
        // REVIEWS
        // =================================================

        Route::resource(
            'reviews',
            ReviewController::class
        )->only([
            'index',
            'show',
            'destroy'
        ]);


        // =================================================
        // REPORTS
        // =================================================

        Route::get(
            'reports',
            [ReportController::class, 'index']
        )->name('reports.index');


        // =================================================
        // NOTIFICATIONS
        // =================================================

        Route::resource(
            'notifications',
            NotificationController::class
        )->only([
            'index',
            'create',
            'store',
            'show',
            'destroy'
        ]);

        Route::put(
            'notifications/{notification}/read',
            [NotificationController::class, 'markAsRead']
        )->name('notifications.read');


        // =================================================
        // SETTINGS
        // =================================================

        Route::get(
            'settings',
            [SettingController::class, 'index']
        )->name('settings.index');

        Route::put(
            'settings',
            [SettingController::class, 'update']
        )->name('settings.update');

    });
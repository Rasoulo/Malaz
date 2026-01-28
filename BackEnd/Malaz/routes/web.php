<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\PropertyController;
use App\Http\Controllers\Admin\BookingController;
use Illuminate\Support\Facades\Route;
use Kreait\Laravel\Firebase\Facades\Firebase;

// Routes for guests (not logged in)
Route::middleware('guest:web')->group(function () {
    Route::get('/', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/', [AuthController::class, 'login'])->name('login.post');
});

// Routes for authenticated admin users
Route::middleware(['auth:web', 'role:ADMIN'])->name('admin.')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // User Management
    Route::prefix('users')->name('users.')->group(function () {
        Route::get('/registration-requests', [UserController::class, 'registrationRequests'])->name('registration-requests');
        Route::post('/{user}/approve', [UserController::class, 'approve'])->name('approve');
        Route::post('/{user}/reject', [UserController::class, 'reject'])->name('reject');
    });
    Route::resource('users', UserController::class)->except(['create', 'store']);

    // Property Management
    Route::prefix('properties')->name('properties.')->group(function () {
        Route::get('/', [PropertyController::class, 'index'])->name('index');
        Route::get('/{property}', [PropertyController::class, 'show'])->name('show');
        Route::delete('/{property}', [PropertyController::class, 'destroy'])->name('destroy');
        Route::patch('/{property}/approve', [PropertyController::class, 'approve'])->name('approve');
        Route::patch('/{property}/reject', [PropertyController::class, 'reject'])->name('reject');
    });

    // Booking Management
    Route::prefix('bookings')->name('bookings.')->group(function () {
        Route::get('/', [BookingController::class, 'index'])->name('index');
        Route::get('/{booking}', [BookingController::class, 'show'])->name('show');
    });
});

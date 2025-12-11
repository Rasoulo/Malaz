<?php

use App\Http\Controllers\Admin\UserController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\DashboardController;

// Public admin routes (login)
Route::prefix('admin')->name('admin.')->group(function () {
    Route::middleware('guest:web')->group(function () {
        Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
        Route::post('/login', [AuthController::class, 'login'])->name('login.post');
    });

    Route::middleware(['auth:web', 'role:ADMIN'])->group(function () {
        Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // User Management - Focus on registration requests
        Route::get('/registration-requests', [UserController::class, 'registrationRequests'])->name('users.registration-requests');
        Route::post('/users/{user}/approve', [UserController::class, 'approve'])->name('users.approve');
        Route::post('/users/{user}/reject', [UserController::class, 'reject'])->name('users.reject');
        Route::post('/users/{user}/make-owner', [UserController::class, 'makeOwner'])->name('users.make-owner');
        Route::post('/users/{user}/make-renter', [UserController::class, 'makeRenter'])->name('users.make-renter');

        // Regular user management (for existing users)
        Route::resource('users', UserController::class)
            ->except(['create', 'store']);
    });
});

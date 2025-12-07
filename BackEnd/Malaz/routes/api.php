<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\PropertyController;
use App\Http\Controllers\EditRequestController;
use App\Http\Controllers\ConversationController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');


Route::prefix('user')
    ->controller(UserController::class)
    ->group(function () {
        Route::post('/sendOtp', 'sendOtp');
        Route::post('/verifyOtp', 'verifyOtp');
        Route::post('/register', 'register');
        Route::post('/login', 'login');
        Route::middleware('auth:sanctum')
            ->group(function () {
                Route::post('/request_update', 'request_update');
                Route::post('/changepassword', 'changepassword');
                Route::get('/logout', 'logout');
                Route::get('/me', 'me');
            });

        Route::post('/update', [UserController::class, 'update'])
            ->middleware(['auth:sanctum', 'role:ADMIN']);
        Route::get('/index', [UserController::class, 'index'])
            ->middleware(['auth:sanctum', 'role:ADMIN']);
    });

Route::prefix('property')
    ->middleware(['auth:sanctum', 'role:ADMIN,OWNER,RENTER'])
    ->controller(PropertyController::class)
    ->group(function () {
        Route::get('/all_properties', 'all_properties');
        Route::get('/show/{property}', 'show');
        Route::middleware(['auth:sanctum', 'role:ADMIN,OWNER'])->group(function () {
            Route::get('/my_properties', 'my_properties');
            Route::post('/store', 'store');
            Route::patch('/update/{property}', 'update');
            Route::delete('/destroy/{property}', 'destroy');
        });
    });

Route::prefix('admin')
    ->middleware(['auth:sanctum', 'role:ADMIN'])
    ->controller(EditRequestController::class)
    ->group(function () {
        Route::get('/index', 'index');
        Route::get('/pendinglist', 'pendinglist');
        Route::patch('/update/{editRequest}', 'update');
    });

Route::prefix('conversation')
    ->middleware(['auth:sanctum', 'role:ADMIN,OWNER,RENTER'])
    ->controller(ConversationController::class)
    ->group(function () {
        Route::get('/index', 'index');
        Route::post('/store', 'store');
        Route::get('/show/{conversation}', 'show');
        Route::delete('/destroy/{conversation}', 'destroy');
    });

Route::prefix('message')
    ->middleware(['auth:sanctum', 'role:ADMIN,OWNER,RENTER'])
    ->controller(MessageController::class)
    ->group(function () {
        Route::get('/index/{conversation}', 'index');
        Route::post('/store/{conversation}', 'store');
        Route::get('/show/{message}', 'show');
        Route::delete('/destroy/{message}', 'destroy');
    });

Route::prefix('bookings')->middleware('auth:sanctum')->controller(BookingController::class)->group(function () {
    // User routes
    Route::get('/', 'index');
    Route::post('/store', 'store');
    Route::get('/show/{booking}', 'show');
    Route::delete('/cancel/{booking}', 'destroy');

    // Admin routes
    Route::middleware('role:ADMIN')->group(function () {
        Route::get('/all', 'all');
        Route::patch('/update/{booking}', 'update');
        Route::delete('/force-cancel/{booking}', 'forceCancel');
    });
});


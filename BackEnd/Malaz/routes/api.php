<?php

use App\Models\Property;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\PropertyController;
use App\Http\Controllers\EditRequestController;
use App\Http\Controllers\ConversationController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::prefix('users')->controller(UserController::class)->group(function () {
    Route::middleware(['auth:sanctum', 'role:ADMIN'])->group(function () {
        Route::get('/', 'index')->name('users.index');
        Route::put('{user}', 'update')->name('users.update');
        Route::get('/{user}/identity_card_image', 'showIdentityCardImage')->name('users.identity_card_image');
    });
    Route::middleware(['auth:sanctum', 'role:ADMIN,USER'])->group(function () {
        Route::post('/language', 'updateLanguage')->name('user.language.update');
        Route::get('/{user}/profile_image', 'showProfileImage')->name('users.profile_image');
        Route::post('request-update', 'request_update')->name('users.requestUpdate');
        Route::post('change-password', 'changepassword')->name('users.changePassword');
        Route::post('logout', 'logout')->name('users.logout');
        Route::get('me', 'me')->name('users.me');
        Route::post('favorites/{property}', 'addtofav')->name('users.addFavorite');
        Route::delete('favorites/{property}', 'erasefromfav')->name('users.removeFavorite');
        Route::get('favorites', 'getfav')->name('users.getFavorites');
        Route::post('send-otppassword', 'sendOtp_passwordone')->name('users.sendOtppassword');
        Route::get('showinfo/{user}', 'showinfo')->name('users.showinfo');
    });
    Route::post('register', 'register')->name('users.register');
    Route::post('login', 'login')->name('users.login');
    Route::post('send-otp', 'sendOtp')->name('users.sendOtp');
    Route::post('verify-otp', 'verifyOtp')->name('users.verifyOtp');
});

Route::prefix('reviews')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(ReviewController::class)->group(function () {
    Route::get('/properties/{propertyId}/reviews', 'propertyReviews');
    Route::get('/', 'index')->name('reviews.index');
    Route::post('/properties/{property}', 'store')->name('reviews.store');
    Route::get('{review}', 'show')->name('reviews.show');
    Route::put('{review}', 'update')->name('reviews.update');
    Route::patch('{review}', 'update');
    Route::delete('{review}', 'destroy')->name('reviews.destroy');
});

Route::prefix('properties')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(PropertyController::class)->group(function () {
    Route::get('all', 'all_properties')->name('properties.all');
    //all_booked_properties
    Route::get('all_booked/{property}', 'all_booked_properties')->name('properties.all_booked');
    Route::get('{property}', 'show')->name('properties.show');
    Route::get('{property}/favorites', 'favonwho')->name('properties.favonwho');
    Route::middleware('role:ADMIN,USER')->group(function () {
        Route::get('all/my', 'my_properties')->name('properties.my');
        Route::post('/', 'store')->name('properties.store');
        Route::post('{property}', 'update')->name('properties.update');
        Route::delete('{property}', 'destroy')->name('properties.destroy');
    });
});

Route::prefix('conversations')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(ConversationController::class)->group(function () {
    Route::get('/', 'index')->name('conversations.index');
    Route::post('/{user}', 'store')->name('conversations.store');
    Route::get('{conversation}', 'show')->name('conversations.show');
    Route::delete('{conversation}', 'destroy')->name('conversations.destroy');
    Route::get('{conversation}/messages', 'showmessage')->name('conversations.messages');
});

Route::prefix('conversations/{conversation}/messages')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(MessageController::class)->group(function () {
    Route::get('/', 'index')->name('messages.index');
    Route::post('/', 'store')->name('messages.store');
});

Route::prefix('messages')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(MessageController::class)->group(function () {
    Route::get('{message}', 'show')->name('messages.show');
    Route::put('{message}', 'update')->name('messages.update');
    Route::patch('{message}', 'update');
    Route::post('{message}/read', 'readnow')->name('messages.read');
    Route::delete('{message}', 'destroy')->name('messages.destroy');
});

Route::prefix('edit-requests')->middleware(['auth:sanctum', 'role:ADMIN'])->controller(EditRequestController::class)->group(function () {
    Route::get('/', 'index')->name('editrequests.index');
    Route::get('pending', 'pendinglist')->name('editrequests.pending');
    Route::put('{editRequest}', 'update')->name('editrequests.update');
    Route::patch('{editRequest}', 'update');
});

Route::prefix('bookings')->middleware(['auth:sanctum', 'role:ADMIN,USER'])->controller(BookingController::class)->group(function () {
    Route::get('/', 'index')->name('bookings.index');
    Route::post('store', 'store')->name('bookings.store');
    Route::get('show/{booking}', 'show')->name('bookings.show');
    Route::delete('cancel/{booking}', 'destroy')->name('bookings.cancel');
    Route::patch('update/{booking}', 'update')->name('bookings.update');
    Route::middleware('role:ADMIN')->group(function () {
        Route::get('all', 'all')->name('bookings.all');
        Route::delete('force-cancel/{booking}', 'forceCancel')->name('bookings.forceCancel');
    });
});

// Route::get('/users/{id}/profile-image', [UserController::class, 'profileImage'])
//     ->name('users.profile_image');

// Route::get('/users/{id}/identity-image', [UserController::class, 'identityImage'])
//     ->name('users.identity_image');

Route::get('/images/{id}', [ImageController::class, 'show'])->name('images.show');

Route::get('/main_pic/{property}', [PropertyController::class, 'showmainpic'])
    ->name('property.main_pic');

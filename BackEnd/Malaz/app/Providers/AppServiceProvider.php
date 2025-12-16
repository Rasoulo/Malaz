<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Http\Request;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot()
    {
        //
    }
}

// Request::macro('hasFile', function ($key) {
//     return $this->isMethod('PUT') || $this->isMethod('PATCH')
//         ? isset($_FILES[$key])
//         : $this->files->has($key);
// });
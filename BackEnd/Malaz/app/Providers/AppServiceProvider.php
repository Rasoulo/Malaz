<?php

namespace App\Providers;

use App\Models\Conversation;
use Illuminate\Http\Request;
use App\Policies\ConversationPolicy;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

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
        // Gate::policy(Conversation::class, ConversationPolicy::class);
        //
    }
}

// Request::macro('hasFile', function ($key) {
//     return $this->isMethod('PUT') || $this->isMethod('PATCH')
//         ? isset($_FILES[$key])
//         : $this->files->has($key);
// });
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;

class SetLocale
{
    public function handle($request, Closure $next)
    {
        if (Auth::check()) {
            App::setLocale(Auth::user()->language ?? config('app.locale'));
        } else {
            App::setLocale(session('locale', config('app.locale')));
        }
        return $next($request);
    }
}
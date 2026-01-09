<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;

class SetLocale
{
    public function handle($request, Closure $next)
    {
        $locale = $request->header('Accept-Language', $request->query('lang'));

        if ($locale && in_array($locale, ['en', 'ar', 'fr', 'ru', 'tr']) && Auth::check())
            Auth::user()->update(['language' => $locale]);

        if ((!$locale || !in_array($locale, ['en', 'ar', 'fr', 'ru', 'tr'])) && Auth::check()) {
            $locale = Auth::user()->language;
        }

        if (!in_array($locale, ['en', 'ar', 'fr', 'ru', 'tr'])) {
            $locale = config('app.locale');
        }


        App::setLocale($locale);

        return $next($request);
    }
}
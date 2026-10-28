<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminMiddleware
{
    public function handle(
        Request $request,
        Closure $next
    ): Response {
        if (!auth()->check()) {
            return redirect()
                ->route('admin.login')
                ->with('error', 'Please login as admin.');
        }

        if (!auth()->user()->isAdmin()) {
            auth()->logout();

            return redirect()
                ->route('admin.login')
                ->with('error', 'Access denied. Admin only.');
        }

        return $next($request);
    }
}
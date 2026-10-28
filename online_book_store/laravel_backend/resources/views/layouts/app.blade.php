<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Online Book Store')</title>
    <!-- Tailwind CSS CDN for modern responsive web store styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 flex flex-col min-h-screen">
    <!-- Navbar -->
    <header class="bg-white border-b border-slate-200 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <a href="{{ route('home') }}" class="flex items-center gap-2 font-extrabold text-xl text-blue-900">
                <svg class="w-8 h-8 text-blue-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
                <span>Online Book Store</span>
            </a>

            <nav class="hidden md:flex items-center gap-6 text-sm font-semibold text-slate-600">
                <a href="{{ route('home') }}" class="hover:text-blue-900 transition">Home</a>
                <a href="{{ route('books.index') }}" class="hover:text-blue-900 transition">Browse Books</a>
                <a href="{{ route('admin.dashboard') }}" class="hover:text-blue-900 text-amber-600 font-bold transition">Admin Panel</a>
            </nav>

            <div class="flex items-center gap-3">
                <a href="{{ route('admin.dashboard') }}" class="bg-blue-900 hover:bg-blue-800 text-white text-xs font-semibold px-4 py-2 rounded-lg transition">
                    Admin Portal
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow">
        @yield('content')
    </main>

    <!-- Footer -->
    <footer class="bg-slate-900 text-slate-400 py-12 mt-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-sm">
            <p class="font-bold text-white text-base mb-2">Online Book Store System</p>
            <p class="mb-4">Complete Integrated Platform for Web (Blade) and Android App (Flutter REST API).</p>
            <p class="text-xs text-slate-500">© 2026 Online Book Store. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>

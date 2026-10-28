<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>@yield('title', 'Admin Panel - Online Book Store')</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link
        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
        rel="stylesheet"
    >

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
    </style>
</head>

<body class="bg-slate-50 text-slate-800 min-h-screen">

    <!-- Admin Header -->
    <header class="bg-white border-b border-slate-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">

            <a
                href="{{ route('admin.dashboard') }}"
                class="flex items-center gap-2 font-extrabold text-xl text-blue-900"
            >
                <span class="text-2xl">📖</span>
                <span>Online Book Store</span>
            </a>

            <div class="flex items-center gap-4">

                <span class="text-sm font-semibold text-slate-600">
                    👤 Admin
                </span>

                <form method="POST" action="{{ route('admin.logout') }}">
                    @csrf

                    <button
                        type="submit"
                        class="text-sm font-semibold text-rose-600 hover:text-rose-700"
                    >
                        Logout
                    </button>
                </form>

            </div>

        </div>
    </header>


    <!-- Main Content -->
    <main class="min-h-screen">
        @yield('content')
    </main>


    <!-- Footer -->
    <footer class="bg-slate-900 text-slate-400 py-8 mt-16">

        <div class="max-w-7xl mx-auto px-4 text-center text-sm">

            <p class="font-bold text-white mb-1">
                Online Book Store Admin Panel
            </p>

            <p class="text-xs text-slate-500">
                © 2026 Online Book Store. All rights reserved.
            </p>

        </div>

    </footer>

</body>
</html>
<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Dashboard') | Malaz Admin</title>

    <!-- Modern & Professional Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Lexend:wght@400;500;600&display=swap" rel="stylesheet">

    {{-- It's best practice to install these via npm and bundle with Vite --}}
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <style>
        /* Using a style tag to define the font families from the new theme */
        body { font-family: 'Lexend', sans-serif; background-color: #F4F1E8; }
        h1, h2, h3, h4, h5, h6, .font-heading { font-family: 'DM Sans', sans-serif; }

        /* A subtle scrollbar that matches the new theme */
        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: #F4F1E8; }
        ::-webkit-scrollbar-thumb { background: #DDCAB3; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #C68E4D; }
    </style>

    {{-- This is where you would configure Tailwind if you don't edit the config file --}}
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'cream': '#F4F1E8',
                        'sandstone': '#DDCAB3',
                        'ochre': '#C68E4D',
                        'walnut': '#5A3D2B',
                        'forest': '#3D4B40',
                    },
                    fontFamily: {
                        'heading': ['DM Sans', 'sans-serif'],
                        'sans': ['Lexend', 'sans-serif'],
                    }
                }
            }
        }
    </script>
</head>
<body class="h-full antialiased">
    <div class="flex h-screen">
        <!-- ===== Sidebar ===== -->
        {{-- The sidebar now uses the rich 'walnut' color for a premium feel --}}
        <aside class="w-64 bg-walnut text-sandstone flex flex-col transition-all duration-300">
            <!-- Logo -->
            <div class="flex items-center justify-center h-20 border-b border-white/10">
                <h1 class="text-3xl font-bold text-ochre font-heading">Malaz</h1>
            </div>

            <!-- Navigation Links -->
            <nav class="flex-1 px-4 py-6 space-y-2">
                {{-- The active state is now a soft, glowing background effect which is more subtle --}}
                <a href="{{ route('admin.dashboard') }}" class="group flex items-center px-3 py-3 rounded-lg transition-all duration-200 {{ Request::routeIs('admin.dashboard') ? 'bg-ochre/80 text-white shadow-inner' : 'hover:bg-white/10' }}">
                    <svg class="h-6 w-6 mr-3 transition-colors {{ Request::routeIs('admin.dashboard') ? 'text-white' : 'text-sandstone/70 group-hover:text-sandstone' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                    <span class="font-semibold text-sm">Dashboard</span>
                </a>

                <a href="{{ route('admin.users.index') }}" class="group flex items-center px-3 py-3 rounded-lg transition-all duration-200 {{ Request::routeIs('admin.users.index') ? 'bg-ochre/80 text-white shadow-inner' : 'hover:bg-white/10' }}">
                    <svg class="h-6 w-6 mr-3 transition-colors {{ Request::routeIs('admin.users.index') ? 'text-white' : 'text-sandstone/70 group-hover:text-sandstone' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M15 21a6 6 0 00-9-5.197m0 0A4 4 0 019 9.171" /></svg>
                    <span class="font-semibold text-sm">Users</span>
                </a>

                <a href="{{ route('admin.properties.index') }}" class="group flex items-center px-3 py-3 rounded-lg transition-all duration-200 {{ Request::routeIs('admin.properties.*') ? 'bg-ochre/80 text-white shadow-inner' : 'hover:bg-white/10' }}">
                    <svg class="h-6 w-6 mr-3 transition-colors {{ Request::routeIs('admin.properties.*') ? 'text-white' : 'text-sandstone/70 group-hover:text-sandstone' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" /></svg>
                    <span class="font-semibold text-sm">Properties</span>
                </a>

                <a href="{{ route('admin.bookings.index') }}" class="group flex items-center px-3 py-3 rounded-lg transition-all duration-200 {{ Request::routeIs('admin.bookings.*') ? 'bg-ochre/80 text-white shadow-inner' : 'hover:bg-white/10' }}">
                    <svg class="h-6 w-6 mr-3 transition-colors {{ Request::routeIs('admin.bookings.*') ? 'text-white' : 'text-sandstone/70 group-hover:text-sandstone' }}" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                    <span class="font-semibold text-sm">Bookings</span>
                </a>
            </nav>

            <!-- User Profile & Logout with enhanced animations -->
            <div class="px-4 py-4 border-t border-white/10" x-data="{ open: false }">
                <div class="relative">
                    <div x-show="open" @click.away="open = false"
                         x-transition:enter="transition ease-out duration-200"
                         x-transition:enter-start="opacity-0 transform -translate-y-2"
                         x-transition:enter-end="opacity-100 transform translate-y-0"
                         x-transition:leave="transition ease-in duration-150"
                         x-transition:leave-start="opacity-100 transform translate-y-0"
                         x-transition:leave-end="opacity-0 transform -translate-y-2"
                         class="absolute bottom-full right-0 mb-2 w-48 bg-cream rounded-md shadow-lg ring-1 ring-black ring-opacity-5 z-20">
                        <form method="POST" action="{{ route('admin.logout') }}">
                            @csrf
                            <button type="submit" class="w-full text-left flex items-center px-4 py-3 text-sm text-red-600 hover:bg-red-500/10">
                                <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                                Sign Out
                            </button>
                        </form>
                    </div>

                    <button @click="open = !open" class="w-full flex items-center text-left p-2 rounded-lg hover:bg-white/10 transition-colors">
                        <div class="flex-shrink-0 h-10 w-10 rounded-full flex items-center justify-center bg-ochre font-bold text-white">
                            {{ substr(auth()->user()->first_name, 0, 1) }}{{ substr(auth()->user()->last_name, 0, 1) }}
                        </div>
                        <div class="ml-3 flex-1 min-w-0">
                            <p class="text-sm font-semibold text-sandstone truncate">{{ auth()->user()->first_name }} {{ auth()->user()->last_name }}</p>
                        </div>
                        <svg class="h-5 w-5 text-sandstone/70 transition-transform duration-200" :class="{ 'rotate-180': open }" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>
                    </button>
                </div>
            </div>
        </aside>

        <!-- ===== Main Content ===== -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Top Bar -->
            <header class="flex items-center justify-between h-20 px-8 bg-cream/80 backdrop-blur-sm border-b border-sandstone/40">
                <h2 class="text-2xl font-bold text-walnut font-heading">@yield('title')</h2>
                <div>
                    @yield('page-actions')
                </div>
            </header>

            <!-- Page Content -->
            <main class="flex-1 overflow-x-hidden overflow-y-auto p-8">
                @yield('content')
            </main>
        </div>
    </div>

    @stack('scripts')
</body>
</html>

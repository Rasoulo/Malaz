<!DOCTYPE html>
<html lang="en" class="h-full">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Admin Dashboard') - Malaz</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#B8860B',
                        'primary-light': '#DAA520',
                        'primary-dark': '#8B6914',
                        accent: '#A0522D',
                    }
                }
            }
        }
    </script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js for graphs -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Our official color palette */
        :root {
            --primary: #B8860B;
            --primary-light: #DAA520;
            --primary-dark: #8B6914;
            --accent: #A0522D;
            --text-dark: #1a202c;
            --text-light: #718096;
            --bg-light: #f8f9fa;
            --sidebar-bg: #1f2937;
            --sidebar-text: #d1d5db;
            --sidebar-hover: #374151;
        }

        /* Custom scrollbar */
        .custom-scrollbar::-webkit-scrollbar {
            width: 8px;
        }

        .custom-scrollbar::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 4px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background: #9ca3af;
        }

        /* Active link styles */
        .active-nav-item {
            background: rgba(184, 134, 11, 0.1);
            border-left: 3px solid var(--primary);
            color: var(--primary);
        }

        /* Badge styles */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 2px 8px;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-primary {
            background-color: rgba(184, 134, 11, 0.1);
            color: var(--primary);
        }

        .badge-success {
            background-color: rgba(34, 197, 94, 0.1);
            color: #16a34a;
        }

        .badge-warning {
            background-color: rgba(245, 158, 11, 0.1);
            color: #d97706;
        }

        .badge-danger {
            background-color: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }

        /* Table styles */
        .table-row-hover:hover {
            background-color: #f9fafb;
        }

        /* Fixed height for main container */
        .main-container {
            height: calc(100vh - 64px);
            /* Full height minus header */
        }
    </style>
</head>

<body class="h-full bg-gray-50">
    <div class="flex h-full">
        <!-- Sidebar - Always visible -->
        <aside class="flex-shrink-0 w-64 bg-gray-900 text-gray-300 flex flex-col justify-between">

            <!-- Brand Logo -->
            <div class="flex items-center justify-between px-4 py-5 border-b border-gray-800">
                <div class="flex items-center space-x-2">
                    <div class="w-8 h-8 rounded-md flex items-center justify-center"
                        style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                        <i class="fas fa-home text-white text-sm"></i>
                    </div>
                    <span class="text-xl font-bold text-white">Malaz<span style="color: var(--primary)">.</span></span>
                </div>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 px-4 py-6 overflow-y-auto custom-scrollbar">
                <ul class="space-y-2">
                    <!-- Dashboard -->
                    <li>
                        <a href="{{ route('admin.dashboard') }}"
                            class="flex items-center px-3 py-3 rounded-lg hover:bg-gray-800 {{ Request::routeIs('admin.dashboard') ? 'active-nav-item' : '' }}">
                            <i class="fas fa-tachometer-alt w-5 mr-3"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>

                    <!-- Users -->
                    <li>
                        <a href="{{ route('admin.users.index') }}"
                            class="flex items-center justify-between px-3 py-3 rounded-lg hover:bg-gray-800 {{ Request::routeIs('admin.users.index') ? 'active-nav-item' : '' }}">
                            <div class="flex items-center">
                                <i class="fas fa-users w-5 mr-3"></i>
                                <span>Users</span>
                            </div>
                            <span
                                class="badge badge-primary">{{ \App\Models\User::where('role', '!=', 'PENDING')->count() }}</span>
                        </a>
                    </li>

                    <!-- Registration Requests -->
                    <li>
                        <a href="{{ route('admin.users.registration-requests') }}"
                            class="flex items-center justify-between px-3 py-3 rounded-lg hover:bg-gray-800 {{ Request::routeIs('admin.users.registration-requests') ? 'active-nav-item' : '' }}">
                            <div class="flex items-center">
                                <i class="fas fa-user-plus w-5 mr-3"></i>
                                <span>Registration Requests</span>
                            </div>
                            @php
                                $pendingCount = \App\Models\User::where('role', 'PENDING')->count();
                            @endphp
                            @if ($pendingCount > 0)
                                <span class="badge badge-danger">{{ $pendingCount }}</span>
                            @else
                                <span class="text-xs text-gray-400">0</span>
                            @endif
                        </a>
                    </li>

                    <!-- Properties -->
                    <li>
                        <a href="{{ route('admin.properties.index') }}"
                            class="flex items-center justify-between px-3 py-3 rounded-lg hover:bg-gray-800 {{ Request::routeIs('admin.properties.*') ? 'active-nav-item' : '' }}">
                            <div class="flex items-center">
                                <i class="fas fa-home w-5 mr-3"></i>
                                <span>Properties</span>
                            </div>
                            @php
                                $pendingCount = \App\Models\Property::where('status', 'pending')->count();
                            @endphp
                            @if ($pendingCount > 0)
                                <span class="badge badge-danger">{{ $pendingCount }}</span>
                            @else
                                <span class="text-xs text-gray-400">0</span>
                            @endif
                        </a>
                    </li>

                    <!-- Bookings -->
                    <li>
                        <a href="#"
                            class="flex items-center justify-between px-3 py-3 rounded-lg hover:bg-gray-800">
                            <div class="flex items-center">
                                <i class="fas fa-calendar-check w-5 mr-3"></i>
                                <span>Bookings</span>
                            </div>
                            @php
                                $activeBookings = \App\Models\Booking::whereIn('status', [
                                    'confirmed',
                                    'ongoing',
                                ])->count();
                            @endphp
                            @if ($activeBookings > 0)
                                <span class="badge badge-success">{{ $activeBookings }}</span>
                            @else
                                <span class="text-xs text-gray-400">0</span>
                            @endif
                        </a>
                    </li>

                    <!-- Payments -->
                    <li>
                        <a href="#" class="flex items-center px-3 py-3 rounded-lg hover:bg-gray-800">
                            <i class="fas fa-credit-card w-5 mr-3"></i>
                            <span>Payments</span>
                        </a>
                    </li>

                    <!-- Divider -->
                    <li class="pt-4">
                        <div class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Analytics</div>
                    </li>

                    <!-- Reports -->
                    <li>
                        <a href="#" class="flex items-center px-3 py-3 rounded-lg hover:bg-gray-800">
                            <i class="fas fa-chart-bar w-5 mr-3"></i>
                            <span>Reports</span>
                        </a>
                    </li>

                    <!-- Settings -->
                    <li class="pt-4">
                        <div class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">System</div>
                    </li>

                    <!-- Settings -->
                    <li>
                        <a href="#" class="flex items-center px-3 py-3 rounded-lg hover:bg-gray-800">
                            <i class="fas fa-cog w-5 mr-3"></i>
                            <span>Settings</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- User Profile -->
            <div class="px-4 py-4 border-t border-gray-800">
                <div class="flex items-center">
                    <div class="flex-shrink-0">
                        <div class="w-8 h-8 rounded-full flex items-center justify-center"
                            style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                            <span
                                class="text-white text-xs font-bold">{{ substr(auth()->user()->first_name, 0, 1) }}</span>
                        </div>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium text-white">{{ auth()->user()->first_name }}
                            {{ auth()->user()->last_name }}</p>
                        <p class="text-xs text-gray-400">Administrator</p>
                    </div>
                    <div class="ml-auto">
                        <form method="POST" action="{{ route('admin.logout') }}">
                            @csrf
                            <button type="submit" class="text-gray-400 hover:text-white">
                                <i class="fas fa-sign-out-alt"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Top Header -->
            <header class="bg-white border-b border-gray-200">
                <div class="flex items-center justify-between px-6 py-4">
                    <!-- Left: Breadcrumb -->
                    <div class="flex items-center space-x-4">
                        <nav class="flex" aria-label="Breadcrumb">
                            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                                <li class="inline-flex items-center">
                                    <a href="{{ route('admin.dashboard') }}"
                                        class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-primary">
                                        <i class="fas fa-home mr-2"></i>
                                        Dashboard
                                    </a>
                                </li>
                                @yield('breadcrumb')
                            </ol>
                        </nav>
                    </div>

                    <!-- Right: Search and notifications -->
                    <div class="flex items-center space-x-4">
                        <!-- Search -->
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                            <input type="text"
                                class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent w-64"
                                placeholder="Search...">
                        </div>

                        <!-- Notifications -->
                        <button class="relative p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg">
                            <i class="fas fa-bell"></i>
                            <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
                        </button>

                        <!-- Quick Stats -->
                        <div class="flex items-center space-x-4 text-sm">
                            <div class="px-3 py-1 bg-gray-100 rounded-lg">
                                <span class="text-gray-600">Users:</span>
                                <span class="font-semibold ml-1" style="color: var(--primary)">
                                    {{ \App\Models\User::where('role', '!=', 'PENDING')->count() }}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Main Content Area -->
            <main class="flex-1 overflow-y-auto custom-scrollbar p-6 main-container">
                <!-- Page Header -->
                <div class="mb-6">
                    <h1 class="text-2xl font-bold text-gray-900">@yield('page-title')</h1>
                </div>

                <!-- Page Content -->
                <div class="space-y-6">
                    @yield('content')
                </div>
            </main>

            <!-- Footer -->
            <footer class="bg-white border-t border-gray-200 py-4 px-6">
                <div class="flex flex-col md:flex-row justify-between items-center text-sm text-gray-600">
                    <div>
                        © {{ date('Y') }} Malaz Property Rental. All rights reserved.
                    </div>
                    <div class="mt-2 md:mt-0">
                        <span class="mr-4">Admin Panel v1.0</span>
                        <span>Last login: {{ auth()->user()->updated_at->format('M d, Y H:i') }}</span>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- JavaScript (Simplified - No mobile toggles) -->
    <script>
        // Active navigation highlighting
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const navLinks = document.querySelectorAll('aside a');

            navLinks.forEach(link => {
                const href = link.getAttribute('href');
                if (href && currentPath.startsWith(href) && href !== '/') {
                    link.classList.add('active-nav-item');
                }
            });
        });
    </script>

    <!-- Page-specific scripts -->
    @stack('scripts')
</body>

</html>

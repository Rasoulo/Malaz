@extends('layouts.admin')

@section('title', 'User Management')

@section('page-title', 'User Management')

@section('breadcrumb')
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <span class="ml-1 text-sm font-medium text-gray-700 md:ml-2">Users</span>
        </div>
    </li>
@endsection

@section('content')
    <!-- Stats Bar -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(184, 134, 11, 0.1)">
                    <i class="fas fa-users text-lg" style="color: var(--primary)"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Total Approved</p>
                    <p class="text-xl font-bold text-gray-900">
                        {{ \App\Models\User::where('role', '!=', 'PENDING')->count() }}</p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(160, 82, 45, 0.1)">
                    <i class="fas fa-user text-lg" style="color: var(--accent)"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Regular Users</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\User::where('role', 'USER')->count() }}</p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(139, 105, 20, 0.1)">
                    <i class="fas fa-user-shield text-lg" style="color: var(--primary-dark)"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Admins</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\User::where('role', 'ADMIN')->count() }}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Registration Requests Alert -->
    <div class="mb-6 bg-yellow-50 border border-yellow-200 rounded-xl p-4 flex items-start">
        <div class="flex-shrink-0">
            <i class="fas fa-exclamation-triangle text-yellow-500 mt-1"></i>
        </div>
        <div class="ml-3 flex-1">
            <p class="text-sm text-yellow-800">
                <strong>New registration requests need your attention.</strong>
                <a href="{{ route('admin.users.registration-requests') }}" class="font-semibold underline"
                    style="color: var(--primary)">
                    Review {{ \App\Models\User::where('role', 'PENDING')->count() }} pending requests →
                </a>
            </p>
        </div>
    </div>

    <!-- Main Card -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <!-- Header with Search -->
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex flex-col md:flex-row md:items-center justify-between">
                <div class="mb-4 md:mb-0">
                    <h3 class="text-lg font-semibold text-gray-900">Approved Users</h3>
                </div>
                <div class="flex items-center space-x-3">
                    <!-- Search -->
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-search text-gray-400"></i>
                        </div>
                        <form method="GET" action="{{ route('admin.users.index') }}">
                            <input type="text" name="search" value="{{ request('search') }}"
                                class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent w-full md:w-64"
                                placeholder="Search users...">
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <div class="flex flex-wrap items-center gap-4">
                <span class="text-sm font-medium text-gray-700">Filter by role:</span>

                <!-- Role Filter -->
                <div class="flex items-center space-x-2">
                    <form method="GET" action="{{ route('admin.users.index') }}" class="flex items-center">
                        <select name="role" onchange="this.form.submit()"
                            class="border border-gray-300 rounded-lg px-3 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-primary-light">
                            <option value="">All Roles</option>
                            <option value="USER" {{ request('role') == 'USER' ? 'selected' : '' }}>User</option>
                            <option value="ADMIN" {{ request('role') == 'ADMIN' ? 'selected' : '' }}>Admin</option>
                        </select>
                        <!-- Keep search parameter -->
                        @if (request('search'))
                            <input type="hidden" name="search" value="{{ request('search') }}">
                        @endif
                    </form>
                </div>

                <!-- Clear Filters -->
                @if (request('search') || request('role'))
                    <a href="{{ route('admin.users.index') }}" class="text-sm text-primary hover:text-primary-dark">
                        Clear filters
                    </a>
                @endif
            </div>
        </div>

        <!-- Users Table -->
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col"
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                        <th scope="col"
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Phone
                        </th>
                        <th scope="col"
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Current
                            Role</th>
                        <th scope="col"
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Joined
                        </th>
                        <th scope="col"
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">More</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse($users as $user)
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-10 w-10 rounded-full flex items-center justify-center"
                                        style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                                        <span class="text-white font-bold">
                                            {{ substr($user->first_name, 0, 1) }}{{ substr($user->last_name, 0, 1) }}
                                        </span>
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900">
                                            {{ $user->first_name }} {{ $user->last_name }}
                                        </div>
                                        <div class="text-sm text-gray-500">
                                            ID: #{{ str_pad($user->id, 6, '0', STR_PAD_LEFT) }}
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm font-medium text-gray-900">{{ $user->phone }}</div>
                                <div class="text-sm text-gray-500">
                                    @if ($user->email)
                                        {{ $user->email }}
                                    @else
                                        <span class="text-gray-400">No email</span>
                                    @endif
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span
                                    class="px-3 py-1 text-xs font-medium rounded-full
                                {{ $user->role == 'ADMIN'
                                    ? 'bg-purple-100 text-purple-800'
                                    : ($user->role == 'OWNER'
                                        ? 'bg-blue-100 text-blue-800'
                                        : ($user->role == 'RENTER'
                                            ? 'bg-green-100 text-green-800'
                                            : 'bg-gray-100 text-gray-800')) }}">
                                    {{ $user->role }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ $user->created_at->format('M d, Y') }}
                                <div class="text-xs text-gray-400">
                                    {{ $user->created_at->diffForHumans() }}
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <div class="flex space-x-3">
                                    <a href="{{ route('admin.users.show', $user) }}"
                                        class="text-primary hover:text-primary-dark">
                                        View
                                    </a>
                                    <a href="{{ route('admin.users.edit', $user) }}"
                                        class="text-gray-600 hover:text-gray-900">
                                        Edit
                                    </a>
                                    @if ($user->id !== auth()->id())
                                        <form action="{{ route('admin.users.destroy', $user) }}" method="POST"
                                            class="inline-block">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="text-red-600 hover:text-red-900"
                                                onclick="return confirm('Are you sure you want to delete this user?')">
                                                Delete
                                            </button>
                                        </form>
                                    @endif
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                                No approved users found.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t border-gray-200">
            {{ $users->links() }}
        </div>
    </div>
@endsection

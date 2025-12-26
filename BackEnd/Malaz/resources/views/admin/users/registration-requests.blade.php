@extends('layouts.admin')

@section('title', 'Registration Requests')

@section('page-title', 'Registration Requests')

@section('breadcrumb')
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <a href="{{ route('admin.users.index') }}"
                class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Users</a>
        </div>
    </li>
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <span class="ml-1 text-sm font-medium text-gray-700 md:ml-2">Registration Requests</span>
        </div>
    </li>
@endsection

@section('content')
    <!-- Stats Bar -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(184, 134, 11, 0.1)">
                    <i class="fas fa-clock text-lg" style="color: var(--primary)"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Pending Requests</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\User::where('role', 'PENDING')->count() }}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Card -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <!-- Header with Search -->
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex flex-col md:flex-row md:items-center justify-between">
                <div class="mb-4 md:mb-0">
                    <h3 class="text-lg font-semibold text-gray-900">Pending Registration Requests</h3>
                </div>
                <div class="flex items-center space-x-3">
                    <!-- Search -->
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-search text-gray-400"></i>
                        </div>
                        <form method="GET" action="{{ route('admin.users.registration-requests') }}">
                            <input type="text" name="search" value="{{ request('search') }}"
                                class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent w-full md:w-64"
                                placeholder="Search by name or phone...">
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Requests Table -->
        <div class="overflow-x-auto">
            @if ($pendingUsers->count() > 0)
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Applicant</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Phone
                                & Date of Birth</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Registration Date</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Status</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @foreach ($pendingUsers as $user)
                            <tr class="hover:bg-gray-50 transition-colors">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div
                                            class="flex-shrink-0 h-10 w-10 rounded-full flex items-center justify-center bg-gray-200">
                                            <span class="text-gray-600 font-bold">
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
                                    <div class="text-sm font-medium text-gray-900">
                                        <i class="fas fa-phone mr-1 text-gray-400"></i>
                                        {{ $user->phone }}
                                    </div>
                                    <div class="text-sm text-gray-500 mt-1">
                                        <i class="fas fa-birthday-cake mr-1 text-gray-400"></i>
                                        {{ $user->date_of_birth->format('M d, Y') }}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    {{ $user->created_at->format('M d, Y H:i') }}
                                    <div class="text-xs text-gray-400">
                                        {{ $user->created_at->diffForHumans() }}
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-800">
                                        <i class="fas fa-clock mr-1"></i> Pending Approval
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <div
                                        class="flex flex-col md:flex-row md:items-center md:space-x-3 space-y-2 md:space-y-0">
                                        <!-- Approve as User -->
                                        <form action="{{ route('admin.users.approve', $user) }}" method="POST">
                                            @csrf
                                            <input type="hidden" name="role" value="USER">
                                            <button type="submit"
                                                class="px-3 py-1 bg-green-600 text-white rounded-lg hover:bg-green-700 transition text-xs">
                                                <i class="fas fa-check mr-1"></i> Approve User
                                            </button>
                                        </form>

                                        <!-- Reject -->
                                        <form action="{{ route('admin.users.reject', $user) }}" method="POST">
                                            @csrf
                                            <button type="submit"
                                                class="px-3 py-1 bg-red-600 text-white rounded-lg hover:bg-red-700 transition text-xs"
                                                onclick="return confirm('Are you sure you want to reject this registration?')">
                                                <i class="fas fa-times mr-1"></i> Reject
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            @else
                <!-- Empty State -->
                <div class="text-center py-12">
                    <div class="mx-auto w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-users text-gray-400 text-3xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No pending registration requests</h3>
                </div>
            @endif
        </div>

        <!-- Pagination -->
        @if ($pendingUsers->hasPages())
            <div class="px-6 py-4 border-t border-gray-200">
                {{ $pendingUsers->links() }}
            </div>
        @endif
    </div>
@endsection

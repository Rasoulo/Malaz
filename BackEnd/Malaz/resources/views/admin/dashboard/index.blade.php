@extends('layouts.admin')

@section('title', 'Dashboard')

@section('page-title', 'Dashboard')

@section('breadcrumb')
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <span class="ml-1 text-sm font-medium text-gray-700 md:ml-2">Overview</span>
        </div>
    </li>
@endsection

@section('content')
    <!-- Stats Grid - 3 Cards Now -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <!-- Total Users -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Total Users</p>
                    <p class="text-2xl font-bold text-gray-900 mt-1">{{ number_format($stats['total_users']) }}</p>
                    <div class="flex items-center mt-2">
                        <span class="text-xs font-medium px-2 py-1 rounded-full {{ $stats['new_users_today'] > 0 ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800' }}">
                            +{{ $stats['new_users_today'] }} today
                        </span>
                    </div>
                </div>
                <div class="p-3 rounded-lg" style="background: rgba(184, 134, 11, 0.1)">
                    <i class="fas fa-users text-lg" style="color: var(--primary)"></i>
                </div>
            </div>
        </div>

        <!-- Total Properties -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Total Properties</p>
                    <p class="text-2xl font-bold text-gray-900 mt-1">{{ number_format($stats['total_properties']) }}</p>
                    <div class="flex items-center mt-2">
                        <span class="text-xs font-medium px-2 py-1 rounded-full {{ $stats['pending_properties'] > 0 ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800' }}">
                            {{ $stats['pending_properties'] }} pending
                        </span>
                    </div>
                </div>
                <div class="p-3 rounded-lg" style="background: rgba(218, 165, 32, 0.1)">
                    <i class="fas fa-home text-lg" style="color: var(--primary-light)"></i>
                </div>
            </div>
        </div>

        <!-- Active Bookings -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Active Bookings</p>
                    <p class="text-2xl font-bold text-gray-900 mt-1">{{ number_format($stats['active_bookings']) }}</p>
                    <div class="flex items-center mt-2">
                        <span class="text-xs font-medium px-2 py-1 rounded-full bg-blue-100 text-blue-800">
                            {{ $stats['total_bookings'] }} total
                        </span>
                    </div>
                </div>
                <div class="p-3 rounded-lg" style="background: rgba(160, 82, 45, 0.1)">
                    <i class="fas fa-calendar-check text-lg" style="color: var(--accent)"></i>
                </div>
            </div>
        </div>

        <!-- Removed Revenue Card -->
    </div>

    <!-- Charts and Tables Row -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <!-- Property Status Chart -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">Property Status</h3>
                <select class="text-sm border border-gray-300 rounded-lg px-3 py-1 focus:outline-none focus:ring-2 focus:ring-primary-light">
                    <option>All Time</option>
                    <option>Last 7 days</option>
                    <option>Last 30 days</option>
                </select>
            </div>
            <div class="h-64">
                <canvas id="propertyChart"></canvas>
            </div>
        </div>

        <!-- Recent Users -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">Recent Users</h3>
                <a href="#" class="text-sm font-medium" style="color: var(--primary)">View all</a>
            </div>
            <div class="space-y-4">
                @foreach($recentUsers as $user)
                    <div class="flex items-center justify-between p-3 hover:bg-gray-50 rounded-lg transition-all">
                        <div class="flex items-center">
                            <div class="w-10 h-10 rounded-full flex items-center justify-center" style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                                <span class="text-white text-sm font-bold">{{ substr($user->first_name, 0, 1) }}</span>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-gray-900">{{ $user->first_name }} {{ $user->last_name }}</p>
                                <p class="text-xs text-gray-500">{{ $user->email ?? $user->phone }}</p>
                            </div>
                        </div>
                        <div>
                        <span class="text-xs font-medium px-2 py-1 rounded-full
                            {{ $user->role == 'ADMIN' ? 'bg-purple-100 text-purple-800' :
                              ($user->role == 'OWNER' ? 'bg-blue-100 text-blue-800' :
                              ($user->role == 'RENTER' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800')) }}">
                            {{ $user->role }}
                        </span>
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    </div>

    <!-- Recent Bookings Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
                <h3 class="text-lg font-semibold text-gray-900">Recent Bookings</h3>
                <a href="#" class="text-sm font-medium" style="color: var(--primary)">View all bookings</a>
            </div>
        </div>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Property</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dates</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                @foreach($recentBookings as $booking)
                    <tr class="table-row-hover">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="text-sm font-medium text-gray-900">#{{ str_pad($booking->id, 6, '0', STR_PAD_LEFT) }}</span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-8 w-8 rounded-full flex items-center justify-center" style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                                    <span class="text-white text-xs">{{ substr($booking->user->first_name, 0, 1) }}</span>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm font-medium text-gray-900">{{ $booking->user->first_name }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <p class="text-sm text-gray-900 truncate max-w-xs">{{ $booking->property->title ?? 'N/A' }}</p>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            @if($booking->check_in && $booking->check_out)
                                <p class="text-sm text-gray-900">{{ $booking->check_in->format('M d') }} - {{ $booking->check_out->format('M d') }}</p>
                            @else
                                <p class="text-sm text-gray-500">N/A</p>
                            @endif
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            @php
                                $statusColors = [
                                    'pending' => 'bg-yellow-100 text-yellow-800',
                                    'confirmed' => 'bg-green-100 text-green-800',
                                    'ongoing' => 'bg-blue-100 text-blue-800',
                                    'completed' => 'bg-gray-100 text-gray-800',
                                    'cancelled' => 'bg-red-100 text-red-800',
                                ];
                            @endphp
                            <span class="text-xs font-medium px-2 py-1 rounded-full {{ $statusColors[$booking->status] ?? 'bg-gray-100 text-gray-800' }}">
                                {{ ucfirst($booking->status) }}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <a href="#" class="mr-3" style="color: var(--primary)">View</a>
                            <a href="#" class="text-gray-600 hover:text-gray-900">Edit</a>
                        </td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
    </div>
@endsection

@push('scripts')
    <script>
        // Property Status Chart
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('propertyChart').getContext('2d');
            const propertyChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Approved', 'Pending', 'Rejected', 'Suspended'],
                    datasets: [{
                        data: [
                            {{ $propertyStatuses['approved'] }},
                            {{ $propertyStatuses['pending'] }},
                            {{ $propertyStatuses['rejected'] }},
                            {{ $propertyStatuses['suspended'] }}
                        ],
                        backgroundColor: [
                            '#10b981', // Green for approved
                            '#f59e0b', // Yellow for pending
                            '#ef4444', // Red for rejected
                            '#6b7280'  // Gray for suspended
                        ],
                        borderWidth: 1,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                            }
                        }
                    },
                    cutout: '70%'
                }
            });
        });
    </script>
@endpush

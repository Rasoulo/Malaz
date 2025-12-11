@extends('layouts.admin')

@section('title', 'User Details')

@section('page-title', 'User Details')

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
            <span class="ml-1 text-sm font-medium text-gray-700 md:ml-2">{{ $user->first_name }}
                {{ $user->last_name }}</span>
        </div>
    </li>
@endsection

@section('content')
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column: User Info -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Basic Info Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Basic Information</h3>
                </div>
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                            <p class="text-gray-900">{{ $user->first_name }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                            <p class="text-gray-900">{{ $user->last_name }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                            <p class="text-gray-900">{{ $user->email }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                            <p class="text-gray-900">{{ $user->phone }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Date of Birth</label>
                            <p class="text-gray-900">
                                {{ $user->date_of_birth ? $user->date_of_birth->format('M d, Y') : 'N/A' }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Account Created</label>
                            <p class="text-gray-900">{{ $user->created_at->format('M d, Y H:i') }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Verified</label>
                            <p class="text-gray-900">
                                @if ($user->phone_verified_at)
                                    <span class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                                        Verified on {{ $user->phone_verified_at->format('M d, Y') }}
                                    </span>
                                @else
                                    <span class="px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-800">
                                        Not Verified
                                    </span>
                                @endif
                            </p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email Verified</label>
                            <p class="text-gray-900">
                                @if ($user->email_verified_at)
                                    <span class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-800">
                                        Verified on {{ $user->email_verified_at->format('M d, Y') }}
                                    </span>
                                @else
                                    <span class="px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-800">
                                        Not Verified
                                    </span>
                                @endif
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Account Status Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Account Status</h3>
                </div>
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
                            <span
                                class="px-3 py-1 text-sm font-medium rounded-full
                                {{ $user->role == 'ADMIN'
                                    ? 'bg-purple-100 text-purple-800'
                                    : ($user->role == 'OWNER'
                                        ? 'bg-blue-100 text-blue-800'
                                        : ($user->role == 'RENTER'
                                            ? 'bg-green-100 text-green-800'
                                            : 'bg-gray-100 text-gray-800')) }}">
                                {{ $user->role }}
                            </span>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                            <span class="px-3 py-1 text-sm font-medium rounded-full bg-green-100 text-green-800">
                                Active
                            </span>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex items-center justify-between mt-6">
                        <div class="flex space-x-3">
                            <a href="{{ route('admin.users.edit', $user) }}"
                                class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                <i class="fas fa-edit mr-2"></i>Edit User
                            </a>

                            @if ($user->id !== auth()->id())
                                <form action="{{ route('admin.users.destroy', $user) }}" method="POST" class="inline">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit"
                                        class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition"
                                        onclick="return confirm('Are you sure you want to delete this user? This action cannot be undone.')">
                                        <i class="fas fa-trash mr-2"></i>Delete User
                                    </button>
                                </form>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Stats & Quick Actions -->
        <div class="space-y-6">
            <!-- User Stats -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">User Statistics</h3>
                </div>
                <div class="p-6 space-y-4">
                    <div>
                        <p class="text-sm text-gray-600">Properties Listed</p>
                        <p class="text-2xl font-bold text-gray-900">
                            {{ $user->properties ? $user->properties->count() : 0 }}</p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">Total Bookings</p>
                        <p class="text-2xl font-bold text-gray-900">{{ $user->bookings ? $user->bookings->count() : 0 }}
                        </p>
                    </div>
                    <div>
                        <p class="text-sm text-gray-600">Member Since</p>
                        <p class="text-lg font-medium text-gray-900">{{ $user->created_at->diffForHumans() }}</p>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Recent Activity</h3>
                </div>
                <div class="p-6">
                    <p class="text-sm text-gray-500">No recent activity recorded.</p>
                    <!-- You can add user activity logs here later -->
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Quick Actions</h3>
                </div>
                <div class="p-6 space-y-3">
                    <a href="#" class="flex items-center text-gray-700 hover:text-primary transition">
                        <i class="fas fa-home mr-3"></i>
                        <span>View User's Properties</span>
                    </a>
                    <a href="#" class="flex items-center text-gray-700 hover:text-primary transition">
                        <i class="fas fa-calendar-alt mr-3"></i>
                        <span>View User's Bookings</span>
                    </a>
                    <a href="#" class="flex items-center text-gray-700 hover:text-primary transition">
                        <i class="fas fa-envelope mr-3"></i>
                        <span>Send Email to User</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
@endsection

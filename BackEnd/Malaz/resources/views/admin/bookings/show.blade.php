@extends('layouts.admin')

@section('title', 'Booking Details #' . $booking->id)

@section('breadcrumb')
    <li class="inline-flex items-center">
        <span class="text-gray-400">/</span>
        <a href="{{ route('admin.bookings.index') }}" class="inline-flex items-center ml-2 text-sm font-medium text-gray-700 hover:text-primary">
            Bookings
        </a>
    </li>
    <li class="inline-flex items-center">
        <span class="text-gray-400 mx-2">/</span>
        <span class="text-sm font-medium text-primary">Booking #{{ $booking->id }}</span>
    </li>
@endsection

@section('page-title', 'Booking Details')

@section('content')
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column: Booking Overview -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Booking Overview Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-lg font-bold text-gray-900">Booking Overview</h3>
                            <p class="text-sm text-gray-500">Booking ID: #{{ $booking->id }}</p>
                        </div>
                        <div>
                            @php
                                $statusConfig = [
                                    'pending' => ['color' => 'bg-yellow-100 text-yellow-800', 'icon' => 'clock'],
                                    'confirmed' => ['color' => 'bg-green-100 text-green-800', 'icon' => 'check-circle'],
                                    'ongoing' => ['color' => 'bg-blue-100 text-blue-800', 'icon' => 'play-circle'],
                                    'completed' => ['color' => 'bg-gray-100 text-gray-800', 'icon' => 'check-double'],
                                    'cancelled' => ['color' => 'bg-red-100 text-red-800', 'icon' => 'times-circle'],
                                ];
                                $config = $statusConfig[$booking->status] ?? ['color' => 'bg-gray-100 text-gray-800', 'icon' => 'circle'];
                            @endphp
                            <span class="px-4 py-2 inline-flex items-center text-sm font-semibold rounded-full {{ $config['color'] }}">
                                <i class="fas fa-{{ $config['icon'] }} mr-2"></i>
                                {{ ucfirst($booking->status) }}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-3">BOOKING INFORMATION</h4>
                            <div class="space-y-3">
                                <div class="flex items-center">
                                    <i class="fas fa-hashtag text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Booking ID</p>
                                        <p class="font-medium">#{{ $booking->id }}</p>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <i class="far fa-calendar text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Booking Date</p>
                                        <p class="font-medium">{{ $booking->created_at->format('M d, Y H:i') }}</p>
                                    </div>
                                </div>
                                @if($booking->cancelled_at)
                                <div class="flex items-center">
                                    <i class="fas fa-times text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Cancelled On</p>
                                        <p class="font-medium">{{ $booking->cancelled_at->format('M d, Y H:i') }}</p>
                                    </div>
                                </div>
                                @endif
                            </div>
                        </div>

                        <div>
                            <h4 class="text-sm font-medium text-gray-500 mb-3">DATES</h4>
                            <div class="space-y-3">
                                <div class="flex items-center">
                                    <i class="fas fa-sign-in-alt text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Check-in</p>
                                        <p class="font-medium">{{ \Carbon\Carbon::parse($booking->check_in)->format('M d, Y') }}</p>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <i class="fas fa-sign-out-alt text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Check-out</p>
                                        <p class="font-medium">{{ \Carbon\Carbon::parse($booking->check_out)->format('M d, Y') }}</p>
                                    </div>
                                </div>
                                <div class="flex items-center">
                                    <i class="far fa-moon text-gray-400 w-5"></i>
                                    <div class="ml-3">
                                        <p class="text-xs text-gray-500">Nights</p>
                                        <p class="font-medium">{{ $booking->nights }} nights</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    @if($booking->special_requests)
                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <h4 class="text-sm font-medium text-gray-500 mb-2">SPECIAL REQUESTS</h4>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <p class="text-sm text-gray-700">{{ $booking->special_requests }}</p>
                        </div>
                    </div>
                    @endif
                </div>
            </div>

            <!-- Guest Information Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-bold text-gray-900">Guest Information</h3>
                </div>

                <div class="p-6">
                    <div class="flex items-start">
                        <div class="flex-shrink-0">
                            <div class="w-12 h-12 rounded-full flex items-center justify-center" style="background: linear-gradient(135deg, var(--primary), var(--accent))">
                                <span class="text-white font-bold">{{ substr($booking->user->first_name, 0, 1) }}{{ substr($booking->user->last_name, 0, 1) }}</span>
                            </div>
                        </div>
                        <div class="ml-4 flex-1">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <p class="text-sm text-gray-500">Full Name</p>
                                    <p class="font-medium">{{ $booking->user->full_name }}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">Email</p>
                                    <p class="font-medium">{{ $booking->user->email }}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">Phone</p>
                                    <p class="font-medium">{{ $booking->user->phone ?? 'N/A' }}</p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">Role</p>
                                    <p class="font-medium capitalize">{{ strtolower($booking->user->role) }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Property & Payment -->
        <div class="space-y-6">
            <!-- Property Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-bold text-gray-900">Property Information</h3>
                </div>

                <div class="p-6">
                    @if($booking->property->images->first())
                    <div class="mb-4">
                        <img class="w-full h-48 rounded-lg object-cover" src="{{ Storage::url($booking->property->images->first()->image_path) }}" alt="{{ $booking->property->title }}">
                    </div>
                    @endif

                    <h4 class="font-bold text-gray-900 mb-2">{{ $booking->property->title }}</h4>

                    <div class="space-y-3">
                        <div class="flex items-center text-sm">
                            <i class="fas fa-map-marker-alt text-gray-400 w-5"></i>
                            <span class="ml-2 text-gray-600">{{ $booking->property->address }}</span>
                        </div>

                        <div class="flex items-center space-x-4 text-sm">
                            <div class="flex items-center">
                                <i class="fas fa-home text-gray-400 w-5"></i>
                                <span class="ml-2 text-gray-600 capitalize">{{ $booking->property->type }}</span>
                            </div>
                            <div class="flex items-center">
                                <i class="fas fa-bed text-gray-400 w-5"></i>
                                <span class="ml-2 text-gray-600">{{ $booking->property->bedrooms }} beds</span>
                            </div>
                            <div class="flex items-center">
                                <i class="fas fa-bath text-gray-400 w-5"></i>
                                <span class="ml-2 text-gray-600">{{ $booking->property->bathrooms }} baths</span>
                            </div>
                        </div>

                        <div class="pt-4 border-t border-gray-200">
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-500">Nightly Rate</span>
                                <span class="font-bold">${{ number_format($booking->property->price_per_night, 2) }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Property Owner Info -->
                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <h4 class="text-sm font-medium text-gray-500 mb-3">PROPERTY OWNER</h4>
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-10 h-10 rounded-full flex items-center justify-center" style="background: rgba(184, 134, 11, 0.1)">
                                    <span class="text-primary font-bold">
                                        {{ substr($booking->property->user->first_name, 0, 1) }}{{ substr($booking->property->user->last_name, 0, 1) }}
                                    </span>
                                </div>
                            </div>
                            <div class="ml-3">
                                <p class="font-medium">{{ $booking->property->user->full_name }}</p>
                                <p class="text-sm text-gray-500">{{ $booking->property->user->email }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Summary Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6 border-b border-gray-200">
                    <h3 class="text-lg font-bold text-gray-900">Payment Summary</h3>
                </div>

                <div class="p-6">
                    <div class="space-y-3">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Nightly Rate</span>
                            <span>${{ number_format($booking->property->price_per_night, 2) }}</span>
                        </div>

                        <div class="flex justify-between">
                            <span class="text-gray-600">{{ $booking->nights }} nights</span>
                            <span>${{ number_format($booking->property->price_per_night * $booking->nights, 2) }}</span>
                        </div>

                        @if($booking->service_fee > 0)
                        <div class="flex justify-between">
                            <span class="text-gray-600">Service Fee</span>
                            <span>${{ number_format($booking->service_fee, 2) }}</span>
                        </div>
                        @endif

                        @if($booking->cleaning_fee > 0)
                        <div class="flex justify-between">
                            <span class="text-gray-600">Cleaning Fee</span>
                            <span>${{ number_format($booking->cleaning_fee, 2) }}</span>
                        </div>
                        @endif

                        <div class="pt-3 border-t border-gray-200">
                            <div class="flex justify-between text-lg font-bold">
                                <span>Total Amount</span>
                                <span style="color: var(--primary)">${{ number_format($booking->total_amount, 2) }}</span>
                            </div>
                        </div>
                    </div>

                    <div class="mt-6 pt-6 border-t border-gray-200">
                        <div class="flex items-center">
                            <i class="fas fa-users text-gray-400"></i>
                            <span class="ml-2 text-sm text-gray-600">{{ $booking->guests }} guests</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions Card -->
            <div class="bg-white rounded-lg shadow">
                <div class="p-6">
                    <h4 class="text-sm font-medium text-gray-500 mb-4">QUICK ACTIONS</h4>

                    <div class="space-y-3">
                        <a href="{{ route('admin.properties.show', $booking->property_id) }}"
                           class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 text-gray-700">
                            <i class="fas fa-external-link-alt mr-2"></i>
                            View Property
                        </a>

                        <a href="{{ route('admin.users.show', $booking->user_id) }}"
                           class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 text-gray-700">
                            <i class="fas fa-user mr-2"></i>
                            View Guest Profile
                        </a>

                        <a href="{{ route('admin.bookings.index') }}"
                           class="w-full flex items-center justify-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Back to Bookings
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

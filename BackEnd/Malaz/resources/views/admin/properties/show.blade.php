@extends('layouts.admin')

@section('title', 'Property Details')

@section('page-title', 'Property Details')

@section('breadcrumb')
    <li>
        <span class="text-sm font-medium text-gray-700">Properties</span>
    </li>
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400 text-xs mx-2"></i>
            <span class="text-sm font-medium text-gray-700">{{ $property->type }}
                #{{ str_pad($property->id, 6, '0', STR_PAD_LEFT) }}</span>
        </div>
    </li>
@endsection

@section('content')
    <div class="max-w-6xl mx-auto px-4 sm:px-6">

        <!-- Property Header -->
        <div class="bg-white rounded-2xl shadow-md border border-gray-200 mb-6 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200">
                <div class="flex flex-col md:flex-row md:items-center justify-between">
                    <div class="mb-4 md:mb-0">
                        <h3 class="text-lg font-semibold text-gray-900">{{ $property->type }}
                            #{{ str_pad($property->id, 6, '0', STR_PAD_LEFT) }}</h3>
                        <div class="flex items-center mt-2 space-x-4">
                            @php
                                $statusColors = [
                                    'pending' => 'bg-yellow-100 text-yellow-800',
                                    'approved' => 'bg-green-100 text-green-800',
                                    'rejected' => 'bg-red-100 text-red-800',
                                    'suspended' => 'bg-gray-100 text-gray-800',
                                ];
                                $statusIcons = [
                                    'pending' => 'fa-clock',
                                    'approved' => 'fa-check-circle',
                                    'rejected' => 'fa-times-circle',
                                    'suspended' => 'fa-pause-circle',
                                ];
                            @endphp
                            <span
                                class="px-3 py-1 text-sm font-medium rounded-full {{ $statusColors[$property->status] ?? 'bg-gray-100 text-gray-800' }}">
                                <i class="fas {{ $statusIcons[$property->status] ?? 'fa-question-circle' }} mr-1"></i>
                                {{ ucfirst($property->status) }}
                            </span>
                            <span class="text-sm text-gray-600">
                                <i class="fas fa-calendar-alt mr-1"></i>
                                Added: {{ $property->created_at->format('M d, Y') }}
                            </span>
                            <span class="text-sm text-gray-600">
                                <i class="fas fa-sync-alt mr-1"></i>
                                Last updated: {{ $property->updated_at->format('M d, Y') }}
                            </span>
                        </div>
                    </div>
                    <div class="flex space-x-3">
                        <a href="{{ route('admin.properties.edit', $property) }}"
                            class="px-4 py-2 bg-primary text-white rounded-lg hover:opacity-95 transition shadow-sm focus:outline-none focus:ring-2 focus:ring-primary">
                            <i class="fas fa-edit mr-2"></i>Edit Property
                        </a>
                        <div class="relative">
                            <button type="button" class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
                                onclick="toggleDropdown('property-status-actions')">
                                <i class="fas fa-cog mr-2"></i>Status Actions
                                <i class="fas fa-chevron-down ml-2 text-xs"></i>
                            </button>
                            <div id="property-status-actions"
                                class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg z-10 border border-gray-200">
                                <div class="py-1">
                                    @if ($property->status == 'pending')
                                        <form action="{{ route('admin.properties.approve', $property) }}" method="POST">
                                            @csrf
                                            <button type="submit"
                                                class="block w-full text-left px-4 py-2 text-sm text-green-700 hover:bg-green-50">
                                                <i class="fas fa-check mr-2"></i> Approve
                                            </button>
                                        </form>
                                        <form action="{{ route('admin.properties.reject', $property) }}" method="POST">
                                            @csrf
                                            <button type="submit"
                                                class="block w-full text-left px-4 py-2 text-sm text-red-700 hover:bg-red-50"
                                                onclick="return confirm('Are you sure you want to reject this property?')">
                                                <i class="fas fa-times mr-2"></i> Reject
                                            </button>
                                        </form>
                                    @endif

                                    @if ($property->status == 'approved')
                                        <form action="{{ route('admin.properties.suspend', $property) }}" method="POST">
                                            @csrf
                                            <button type="submit"
                                                class="block w-full text-left px-4 py-2 text-sm text-yellow-700 hover:bg-yellow-50">
                                                <i class="fas fa-pause mr-2"></i> Suspend
                                            </button>
                                        </form>
                                    @endif

                                    @if ($property->status == 'suspended')
                                        <form action="{{ route('admin.properties.approve', $property) }}" method="POST">
                                            @csrf
                                            <button type="submit"
                                                class="block w-full text-left px-4 py-2 text-sm text-green-700 hover:bg-green-50">
                                                <i class="fas fa-check mr-2"></i> Reactivate
                                            </button>
                                        </form>
                                    @endif

                                    <form action="{{ route('admin.properties.destroy', $property) }}" method="POST">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit"
                                            class="block w-full text-left px-4 py-2 text-sm text-red-700 hover:bg-red-50"
                                            onclick="return confirm('Are you sure you want to delete this property?')">
                                            <i class="fas fa-trash mr-2"></i> Delete Property
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Property Details Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 p-6">
                <!-- Left Column: Property Info -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Property Images -->
                    <div class="bg-gray-50 rounded-lg p-4">
                        <h4 class="text-sm font-semibold text-gray-900 mb-4">Property Images</h4>
                        @if ($property->images && count($property->images) > 0)
                            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                                @foreach ($property->images as $image)
                                    <div
                                        class="{{ $loop->first ? 'relative md:col-span-2 rounded-lg overflow-hidden bg-gray-200' : 'relative aspect-square rounded-lg overflow-hidden bg-gray-200' }}">
                                        <img src="{{ Storage::url($image->path) }}" alt="Property Image"
                                            class="w-full h-full object-cover hover:scale-105 transition-transform duration-200">
                                    </div>
                                @endforeach
                            </div>
                        @else
                            <div class="text-center py-8">
                                <i class="fas fa-image text-4xl text-gray-300 mb-2"></i>
                                <p class="text-gray-500">No images uploaded</p>
                            </div>
                        @endif
                    </div>

                    <!-- Basic Information -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-4">
                            <h4 class="text-sm font-semibold text-gray-900">Basic Information</h4>
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Property Type:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->type }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Area:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->area }} m²</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Rooms:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->number_of_rooms }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Bathrooms:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->number_of_baths }}</span>
                                </div>

                            </div>
                        </div>

                        <!-- Location Information -->
                        <div class="space-y-4">
                            <h4 class="text-sm font-semibold text-gray-900">Location Details</h4>
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Governorate:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->governorate }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">City:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->city }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Address:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $property->address }}</span>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="space-y-4">
                        <h4 class="text-sm font-semibold text-gray-900">Description</h4>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <p class="text-sm text-gray-700 whitespace-pre-line">
                                {{ $property->description ?: 'No description provided.' }}</p>
                        </div>
                    </div>

                    <!-- Amenities -->
                    @if ($property->amenities && count($property->amenities) > 0)
                        <div class="space-y-4">
                            <h4 class="text-sm font-semibold text-gray-900">Amenities</h4>
                            <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                                @foreach ($property->amenities as $amenity)
                                    <div class="flex items-center">
                                        <i class="fas fa-check-circle text-green-500 mr-2"></i>
                                        <span class="text-sm text-gray-700">{{ $amenity }}</span>
                                    </div>
                                @endforeach
                            </div>
                        </div>
                    @endif
                </div>

                <!-- Right Column: Owner & Pricing -->
                <div class="space-y-6 lg:sticky lg:top-24">
                    <!-- Owner Information -->
                    @if ($property->owner)
                        <div class="bg-gray-50 rounded-lg p-4">
                            <h4 class="text-sm font-semibold text-gray-900 mb-4">Property Owner</h4>
                            <div class="flex items-center mb-4">
                                <div class="w-12 h-12 rounded-full bg-primary-light flex items-center justify-center">
                                    <span class="text-white font-semibold">
                                        {{ substr($property->owner->first_name ?? '', 0, 1) }}{{ substr($property->owner->last_name ?? '', 0, 1) }}
                                    </span>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm font-medium text-gray-900">
                                        {{ ($property->owner->first_name ?? '') . ' ' . ($property->owner->last_name ?? '') }}
                                    </p>
                                    <p class="text-xs text-gray-500">{{ $property->owner->email ?? 'No email' }}</p>
                                    <p class="text-xs text-gray-500">{{ $property->owner->phone ?? 'No phone' }}</p>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <div class="flex justify-between text-sm">
                                    <span class="text-gray-600">Member since:</span>
                                    <span
                                        class="font-medium">{{ optional($property->owner->created_at)->format('M Y') ?? 'N/A' }}</span>
                                </div>
                                <div class="flex justify-between text-sm">
                                    <span class="text-gray-600">Properties listed:</span>
                                    <span class="font-medium">{{ $property->owner->properties->count() ?? 0 }}</span>
                                </div>
                            </div>
                            <div class="mt-4">
                                <a href="{{ route('admin.users.show', $property->owner) }}"
                                    class="text-sm text-primary hover:text-primary-dark">
                                    View Owner Profile →
                                </a>
                            </div>
                        </div>
                    @else
                        <div class="bg-gray-50 rounded-lg p-4">
                            <h4 class="text-sm font-semibold text-gray-900 mb-2">Property Owner</h4>
                            <p class="text-sm text-gray-500">Owner information not available.</p>
                        </div>
                    @endif

                    <!-- Pricing Information -->
                    <div class="bg-gray-50 rounded-lg p-4">
                        <h4 class="text-sm font-semibold text-gray-900 mb-4">Pricing</h4>
                        <div class="space-y-3">
                            <div class="flex justify-between items-center">
                                <span class="text-sm text-gray-600">Monthly Rent:</span>
                                <span
                                    class="text-xl font-bold text-gray-900">${{ number_format($property->price) }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Security Deposit:</span>
                                <span class="font-medium">${{ number_format($property->security_deposit ?? 0) }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Minimum Stay:</span>
                                <span class="font-medium">{{ $property->minimum_stay ?? '1' }} months</span>
                            </div>
                            @if ($property->utilities_included)
                                <div class="flex justify-between text-sm">
                                    <span class="text-gray-600">Utilities:</span>
                                    <span class="font-medium text-green-600">Included</span>
                                </div>
                            @endif
                        </div>
                    </div>

                    <!-- Property Statistics -->
                    <div class="bg-gray-50 rounded-lg p-4">
                        <h4 class="text-sm font-semibold text-gray-900 mb-4">Statistics</h4>
                        <div class="space-y-3">
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Views:</span>
                                <span class="font-medium">{{ $property->views ?? 0 }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Times Booked:</span>
                                <span class="font-medium">{{ $property->bookings->count() }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Reviews:</span>
                                <span class="font-medium">{{ optional($property->reviews)->count() ?? 0 }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Rating:</span>
                                <div class="flex items-center">
                                    @if ($property->average_rating)
                                        @for ($i = 1; $i <= 5; $i++)
                                            <i
                                                class="fas fa-star {{ $i <= $property->average_rating ? 'text-yellow-400' : 'text-gray-300' }} text-xs"></i>
                                        @endfor
                                        <span
                                            class="ml-2 font-medium">{{ number_format($property->average_rating, 1) }}</span>
                                    @else
                                        <span class="text-gray-500">No ratings yet</span>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Property Documents -->
                    @if ($property->documents && count($property->documents) > 0)
                        <div class="bg-gray-50 rounded-lg p-4">
                            <h4 class="text-sm font-semibold text-gray-900 mb-4">Documents</h4>
                            <div class="space-y-2">
                                @foreach ($property->documents as $document)
                                    <div class="flex items-center justify-between p-2 bg-white rounded border">
                                        <div class="flex items-center">
                                            <i class="fas fa-file-pdf text-red-500 mr-2"></i>
                                            <span class="text-sm text-gray-700">{{ $document->name }}</span>
                                        </div>
                                        <a href="{{ Storage::url($document->path) }}" target="_blank"
                                            class="text-sm text-primary hover:text-primary-dark">
                                            <i class="fas fa-download"></i>
                                        </a>
                                    </div>
                                @endforeach
                            </div>
                        </div>
                    @endif
                </div>
            </div>
        </div>

        <!-- Recent Bookings -->
        @if ($property->bookings->count() > 0)
            <div class="bg-white rounded-xl shadow-sm border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-900">Recent Bookings</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Booking ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tenant</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Dates</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Amount</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            @foreach ($property->bookings->take(5) as $booking)
                                <tr>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        #{{ str_pad($booking->id, 6, '0', STR_PAD_LEFT) }}</td>
                                    <td class="px-6 py-4">
                                        <div class="text-sm text-gray-900">{{ $booking->tenant->first_name }}
                                            {{ $booking->tenant->last_name }}</div>
                                        <div class="text-xs text-gray-500">{{ $booking->tenant->email }}</div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        {{ $booking->start_date->format('M d, Y') }} -
                                        {{ $booking->end_date->format('M d, Y') }}
                                    </td>
                                    <td class="px-6 py-4">
                                        @php
                                            $bookingStatusColors = [
                                                'pending' => 'bg-yellow-100 text-yellow-800',
                                                'confirmed' => 'bg-green-100 text-green-800',
                                                'cancelled' => 'bg-red-100 text-red-800',
                                                'completed' => 'bg-blue-100 text-blue-800',
                                            ];
                                        @endphp
                                        <span
                                            class="px-2 py-1 text-xs rounded-full {{ $bookingStatusColors[$booking->status] ?? 'bg-gray-100' }}">
                                            {{ ucfirst($booking->status) }}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-sm font-medium text-gray-900">
                                        ${{ number_format($booking->total_amount) }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
                @if ($property->bookings->count() > 5)
                    <div class="px-6 py-4 border-t border-gray-200 text-center">
                        <a href="{{ route('admin.bookings.index', ['property_id' => $property->id]) }}"
                            class="text-sm text-primary hover:text-primary-dark">
                            View all {{ $property->bookings->count() }} bookings →
                        </a>
                    </div>
                @endif
            </div>
        @endif
    @endsection

    @push('scripts')
        <script>
            function toggleDropdown(id) {
                const dropdown = document.getElementById(id);
                dropdown.classList.toggle('hidden');

                // Close other dropdowns
                document.querySelectorAll('.hidden.absolute.bg-white.rounded-md.shadow-lg').forEach(element => {
                    if (element.id !== id) {
                        element.classList.add('hidden');
                    }
                });
            }

            // Close dropdowns when clicking outside
            document.addEventListener('click', function(event) {
                if (!event.target.closest('.relative')) {
                    document.querySelectorAll('.hidden.absolute.bg-white.rounded-md.shadow-lg').forEach(element => {
                        element.classList.add('hidden');
                    });
                }
            });
        </script>
    @endpush

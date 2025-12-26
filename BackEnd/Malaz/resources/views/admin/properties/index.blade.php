@extends('layouts.admin')

@section('title', 'Property Management')

@section('page-title', 'Property Management')

@section('breadcrumb')
    <li>
        <span class="text-sm font-medium text-gray-700">Properties</span>
    </li>
@endsection

@section('content')
    <!-- Stats Bar -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <!-- Total Properties -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(184, 134, 11, 0.1)">
                    <i class="fas fa-home text-lg" style="color: var(--primary)"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Total Properties</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\Property::count() }}</p>
                </div>
            </div>
        </div>

        <!-- Pending Properties -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(245, 158, 11, 0.1)">
                    <i class="fas fa-clock text-lg" style="color: #f59e0b"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Pending Review</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\Property::where('status', 'pending')->count() }}</p>
                </div>
            </div>
        </div>

        <!-- Approved Properties -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(34, 197, 94, 0.1)">
                    <i class="fas fa-check-circle text-lg" style="color: #22c55e"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Approved</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\Property::where('status', 'approved')->count() }}</p>
                </div>
            </div>
        </div>

        <!-- Rejected Properties -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <div class="flex items-center">
                <div class="p-2 rounded-lg mr-3" style="background: rgba(239, 68, 68, 0.1)">
                    <i class="fas fa-times-circle text-lg" style="color: #ef4444"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Rejected</p>
                    <p class="text-xl font-bold text-gray-900">{{ \App\Models\Property::where('status', 'rejected')->count() }}</p>
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
                    <h3 class="text-lg font-semibold text-gray-900">All Properties</h3>
                </div>
                <div class="flex items-center space-x-3">
                    <!-- Search -->
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-search text-gray-400"></i>
                        </div>
                        <form method="GET" action="{{ route('admin.properties.index') }}">
                            <input type="text"
                                   name="search"
                                   value="{{ request('search') }}"
                                   class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent w-full md:w-64"
                                   placeholder="Search properties...">
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <div class="flex flex-wrap items-center gap-4">
                <span class="text-sm font-medium text-gray-700">Filter by status:</span>

                <!-- Status Filter -->
                <div class="flex items-center space-x-2">
                    <form method="GET" action="{{ route('admin.properties.index') }}" class="flex items-center">
                        <select name="status"
                                onchange="this.form.submit()"
                                class="border border-gray-300 rounded-lg px-3 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-primary-light">
                            <option value="">All Statuses</option>
                            <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                            <option value="approved" {{ request('status') == 'approved' ? 'selected' : '' }}>Approved</option>
                            <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>Rejected</option>
                            <option value="suspended" {{ request('status') == 'suspended' ? 'selected' : '' }}>Suspended</option>
                        </select>
                        <!-- Keep search parameter -->
                        @if(request('search'))
                            <input type="hidden" name="search" value="{{ request('search') }}">
                        @endif
                    </form>
                </div>

                <!-- Clear Filters -->
                @if(request('search') || request('status'))
                    <a href="{{ route('admin.properties.index') }}" class="text-sm text-primary hover:text-primary-dark">
                        Clear filters
                    </a>
                @endif
            </div>
        </div>

        <!-- Properties Table -->
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Property</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Location</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Details</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse($properties as $property)
                    <tr class="hover:bg-gray-50 transition-colors">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10 rounded-lg flex items-center justify-center bg-gray-100">
                                    <i class="fas fa-home text-gray-500"></i>
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900">
                                        {{ $property->type }} #{{ str_pad($property->id, 6, '0', STR_PAD_LEFT) }}
                                    </div>
                                    <div class="text-sm text-gray-500">
                                        Owner: {{ $property->owner->first_name ?? 'N/A' }}
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <div class="text-sm text-gray-900 font-medium">{{ $property->governorate }}</div>
                            <div class="text-sm text-gray-500">{{ $property->city }}</div>
                            <div class="text-xs text-gray-400 truncate max-w-xs">{{ $property->address }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">
                                <i class="fas fa-door-open mr-1 text-gray-400"></i> {{ $property->number_of_rooms }} rooms
                            </div>
                            <div class="text-sm text-gray-900">
                                <i class="fas fa-bath mr-1 text-gray-400"></i> {{ $property->number_of_baths }} baths
                            </div>
                            <div class="text-sm text-gray-900">
                                <i class="fas fa-ruler-combined mr-1 text-gray-400"></i> {{ $property->area }} m²
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-lg font-bold text-gray-900">
                                ${{ number_format($property->price) }}
                            </div>
                            <div class="text-xs text-gray-500">per month</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
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
                            <span class="px-3 py-1 text-xs font-medium rounded-full {{ $statusColors[$property->status] ?? 'bg-gray-100 text-gray-800' }}">
                                <i class="fas {{ $statusIcons[$property->status] ?? 'fa-question-circle' }} mr-1"></i>
                                {{ ucfirst($property->status) }}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <div class="flex space-x-2">
                                <!-- View -->
                                <a href="{{ route('admin.properties.show', $property) }}"
                                   class="text-primary hover:text-primary-dark">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <!-- Edit -->
                                <a href="{{ route('admin.properties.edit', $property) }}"
                                   class="text-gray-600 hover:text-gray-900">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <!-- Quick Actions Dropdown -->
                                <div class="relative inline-block">
                                    <button type="button"
                                            class="text-gray-600 hover:text-gray-900 focus:outline-none"
                                            onclick="toggleDropdown('property-actions-{{ $property->id }}')">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </button>
                                    <div id="property-actions-{{ $property->id }}"
                                         class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg z-10 border border-gray-200">
                                        <div class="py-1">
                                            @if($property->status == 'pending')
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

                                            @if($property->status == 'approved')
                                            <form action="{{ route('admin.properties.suspend', $property) }}" method="POST">
                                                @csrf
                                                <button type="submit"
                                                        class="block w-full text-left px-4 py-2 text-sm text-yellow-700 hover:bg-yellow-50">
                                                    <i class="fas fa-pause mr-2"></i> Suspend
                                                </button>
                                            </form>
                                            @endif

                                            <form action="{{ route('admin.properties.destroy', $property) }}" method="POST">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit"
                                                        class="block w-full text-left px-4 py-2 text-sm text-red-700 hover:bg-red-50"
                                                        onclick="return confirm('Are you sure you want to delete this property?')">
                                                    <i class="fas fa-trash mr-2"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                            No properties found.
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t border-gray-200">
            {{ $properties->links() }}
        </div>
    </div>
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
        if (!event.target.closest('.relative.inline-block')) {
            document.querySelectorAll('.hidden.absolute.bg-white.rounded-md.shadow-lg').forEach(element => {
                element.classList.add('hidden');
            });
        }
    });
</script>
@endpush

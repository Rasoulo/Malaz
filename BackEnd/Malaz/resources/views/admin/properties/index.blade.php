@extends('layouts.admin')

@section('title', 'Properties')
@section('page-title', 'Property Listings')

@section('content')
    <div x-data="{
        // User Modal state
        showUserModal: false,
        selectedUser: null,

        // Property Modal state
        showPropertyModal: false,
        selectedProperty: null,

        // Universal states
        isLoading: false,
        hasError: false,

        // Function for Property Modal
        openPropertyModal(propertyId) {
            this.showPropertyModal = true;
            this.isLoading = true;
            this.hasError = false;
            this.selectedProperty = null;

            fetch(`/properties/${propertyId}`)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok.');
                    return response.json();
                })
                .then(data => {
                    this.selectedProperty = data;
                    this.isLoading = false;
                })
                .catch(error => {
                    console.error('Could not fetch property details:', error);
                    this.isLoading = false;
                    this.hasError = true;
                });
        },

        // Function for User Modal
        openUserModal(userId) {
            this.showUserModal = true;
            this.isLoading = true;
            this.hasError = false;
            this.selectedUser = null;

            fetch(`/users/${userId}`)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok.');
                    return response.json();
                })
                .then(data => {
                    this.selectedUser = data;
                    this.isLoading = false;
                })
                .catch(error => {
                    console.error('Could not fetch user details:', error);
                    this.isLoading = false;
                    this.hasError = true;
                });
        }
    }">

        {{-- Header with Filters --}}
        <div class="mb-8">
            <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                <div class="flex items-center gap-2 p-1 bg-cream rounded-lg border border-sandstone/30">
                    <a href="{{ route('admin.properties.index', ['search' => request('search')]) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors {{ !request('status') ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">All</a>
                    <a href="{{ route('admin.properties.index', ['status' => 'pending', 'search' => request('search')]) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors {{ request('status') == 'pending' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Pending</a>
                    <a href="{{ route('admin.properties.index', ['status' => 'approved', 'search' => request('search')]) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors {{ request('status') == 'approved' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Approved</a>
                    <a href="{{ route('admin.properties.index', ['status' => 'rejected', 'search' => request('search')]) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors {{ request('status') == 'rejected' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Rejected</a>
                </div>
                <form method="GET" action="{{ route('admin.properties.index') }}" class="relative">
                    <input type="hidden" name="status" value="{{ request('status') }}">
                    <input type="text" name="search" value="{{ request('search') }}" placeholder="Search by title or city..." class="pl-10 pr-4 py-2 w-64 bg-white border border-sandstone/50 rounded-lg text-sm text-walnut placeholder-forest/50 focus:outline-none focus:ring-2 focus:ring-ochre/50 focus:border-ochre transition">
                    <div class="absolute left-3 top-1/2 -translate-y-1/2 text-forest/40">
                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                    </div>
                </form>
            </div>
        </div>

        {{-- Properties Grid --}}
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
            @forelse ($properties as $property)
                <div class="bg-white rounded-xl shadow-sm border border-sandstone/30 transition-all duration-300 hover:shadow-lg hover:border-sandstone/50 flex flex-col">
                    <div class="relative">
                        <img class="aspect-[16/10] w-full object-cover rounded-t-xl" src="{{ 'data:' . $property->mime_type . ';base64,' . $property->main_image }}" alt="{{ $property->title }}">
                        <div class="absolute top-3 right-3 px-3 py-1 text-xs font-bold rounded-full {{ ['pending' => 'bg-amber-500/80', 'approved' => 'bg-forest/80', 'rejected' => 'bg-red-500/80'][$property->status] ?? '' }} text-white backdrop-blur-sm">{{ ucfirst($property->status) }}</div>
                    </div>
                    <div class="p-5 flex flex-col flex-grow">
                        <p class="text-sm text-ochre font-semibold">{{ $property->type }} &middot; {{ $property->city }}</p>
                        <h3 class="font-bold font-heading text-lg text-walnut mt-1">{{ $property->title }}</h3>
                        <p class="text-xl font-semibold text-forest mt-2">${{ number_format($property->price) }} <span class="text-sm font-normal text-forest/70">/ night</span></p>
                        <div class="mt-auto pt-5">
                            <div class="flex items-center justify-around text-center border-t border-b border-sandstone/20 py-3">
                                <div><p class="font-bold text-walnut">{{ $property->number_of_bedrooms }}</p><p class="text-xs text-forest/60">Beds</p></div>
                                <div><p class="font-bold text-walnut">{{ $property->number_of_baths }}</p><p class="text-xs text-forest/60">Baths</p></div>
                                <div><p class="font-bold text-walnut">{{ $property->area }}</p><p class="text-xs text-forest/60">m²</p></div>
                            </div>
                        </div>
                    </div>

                    <div class="p-5 pt-0 mt-auto">
                        @if ($property->status == 'pending')
                            <div class="flex items-center gap-3">
                                <form action="{{ route('admin.properties.reject', $property) }}" method="POST" class="w-full">
                                    @csrf
                                    @method('PATCH')
                                    <button type="submit" class="w-full text-center px-4 py-2 text-sm font-semibold text-walnut bg-sandstone/50 rounded-lg hover:bg-sandstone/80 transition-colors">Reject</button>
                                </form>
                                <form action="{{ route('admin.properties.approve', $property) }}" method="POST" class="w-full">
                                    @csrf
                                    @method('PATCH')
                                    <button type="submit" class="w-full text-center px-4 py-2 text-sm font-semibold text-white bg-ochre rounded-lg hover:bg-ochre/90 transition-colors">Approve</button>
                                </form>
                            </div>
                        @else
                            <button @click="openPropertyModal({{ $property->id }})" class="w-full text-center px-4 py-2 text-sm font-semibold text-ochre bg-ochre/10 rounded-lg hover:bg-ochre/20 transition-colors">
                                View Details
                            </button>
                        @endif
                    </div>
                </div>
            @empty
                <div class="md:col-span-2 xl:col-span-3 text-center border-2 border-dashed border-sandstone/50 rounded-xl py-24">
                    <svg class="mx-auto h-12 w-12 text-sandstone" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" /></svg>
                    <h3 class="mt-2 text-lg font-semibold text-walnut font-heading">No Properties Found</h3>
                    <p class="mt-1 text-sm text-forest/70">Try adjusting your search or filters.</p>
                </div>
            @endforelse
        </div>

        <div class="mt-12">
            {{ $properties->appends(request()->query())->links('vendor.pagination.modern-theme') }}
        </div>

        @include('admin.users.partials.user-details-modal')
        @include('admin.properties.partials.property-details-modal')
    </div>
@endsection

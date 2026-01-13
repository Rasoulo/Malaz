@extends('layouts.admin')

@section('title', 'Bookings')
@section('page-title', 'Booking Records')

@section('content')
    <div
        x-data="{
            showUserModal: false,
            selectedUser: null,
            showPropertyModal: false,
            selectedProperty: null,
            showBookingModal: false,
            selectedBooking: null,
            isLoading: false,
            hasError: false,

            openBookingModal(bookingId) {
                this.showBookingModal = true;
                this.isLoading = true;
                this.hasError = false;
                this.selectedBooking = null;

                fetch(`/bookings/${bookingId}`)
                    .then(response => {
                        if (!response.ok) throw new Error('Network response was not ok.');
                        return response.json();
                    })
                    .then(data => {
                        this.selectedBooking = data;
                        this.isLoading = false;
                    })
                    .catch(error => {
                        console.error('Could not fetch booking details:', error);
                        this.isLoading = false;
                        this.hasError = true;
                    });
            },
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
        }"
        {{-- === THIS IS THE KEY CHANGE === --}}
        {{-- These listeners wait for events dispatched from the booking modal --}}
        @open-user-modal.window="openUserModal($event.detail.userId)"
        @open-property-modal.window="openPropertyModal($event.detail.propertyId)"
    >

        <div class="mb-8">
            <div class="flex items-center gap-2 p-1 bg-cream rounded-lg border border-sandstone/30 w-full overflow-x-auto">
                <a href="{{ route('admin.bookings.index') }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ !request('status') ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">All</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'pending']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'pending' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Pending</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'confirmed']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'confirmed' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Confirmed</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'ongoing']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'ongoing' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Ongoing</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'completed']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'completed' ? 'bg-walnut text-white shadow-sm' : 'text-forest/70 hover:text-walnut' }}">Completed</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'cancelled']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'cancelled' ? 'bg-slate-100 text-slate-800' : 'text-forest/70 hover:text-walnut' }}">Cancelled</a>
                <a href="{{ route('admin.bookings.index', ['status' => 'rejected']) }}" class="px-4 py-1.5 text-sm font-semibold rounded-md transition-colors flex-shrink-0 {{ request('status') == 'rejected' ? 'bg-red-100 text-red-800' : 'text-forest/70 hover:text-walnut' }}">Rejected</a>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 gap-6">
            @forelse ($bookings as $booking)
                <div class="bg-white rounded-xl shadow-sm border border-sandstone/30 flex flex-col">
                    <div class="p-5">
                        <div class="flex items-center justify-between">
                             <p class="text-xs text-forest/60">Booking #{{ $booking->id }}</p>
                             @php
                                $statusConfig = ['pending' => 'bg-amber-100 text-amber-800', 'confirmed' => 'bg-sky-100 text-sky-800', 'ongoing' => 'bg-blue-100 text-blue-800', 'completed' => 'bg-green-100 text-green-800', 'cancelled' => 'bg-slate-100 text-slate-800', 'rejected' => 'bg-red-100 text-red-800', 'conflicted' => 'bg-rose-100 text-rose-800'];
                            @endphp
                             <span class="px-2 py-0.5 text-xs font-semibold rounded-full {{ $statusConfig[$booking->status] ?? '' }}">{{ ucfirst($booking->status) }}</span>
                        </div>
                        <p class="font-bold font-heading text-lg text-walnut mt-3 truncate" title="{{ $booking->property->title }}">{{ $booking->property->title }}</p>
                        <p class="text-sm text-forest/80 truncate">{{ $booking->property->address }}, {{ $booking->property->city }}</p>

                        <div class="flex items-center gap-4 mt-4 text-sm border-t border-sandstone/20 pt-4">
                            <svg class="h-5 w-5 text-forest/50" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                            <span class="font-semibold text-walnut">{{ $booking->check_in->format('M d, Y') }}</span>
                            <span class="text-forest/60">&rarr;</span>
                             <span class="font-semibold text-walnut">{{ $booking->check_out->format('M d, Y') }}</span>
                        </div>
                         <div class="flex items-center gap-4 mt-2 text-sm">
                            <svg class="h-5 w-5 text-forest/50" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                             <span class="font-semibold text-walnut">{{ $booking->user->first_name }} {{ $booking->user->last_name }}</span>
                        </div>
                    </div>
                    <div class="p-5 pt-0 mt-auto border-t border-sandstone/20">
                         <button @click="openBookingModal({{ $booking->id }})" class="mt-4 w-full text-center px-4 py-2 text-sm font-semibold text-ochre bg-ochre/10 rounded-lg hover:bg-ochre/20 transition-colors">
                            View Details
                        </button>
                    </div>
                </div>
            @empty
                <div class="md:col-span-2 xl:col-span-3 2xl:col-span-4 text-center border-2 border-dashed border-sandstone/50 rounded-xl py-24">
                    <svg class="mx-auto h-12 w-12 text-sandstone" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                    <h3 class="mt-2 text-lg font-semibold text-walnut font-heading">No Bookings Found</h3>
                    <p class="mt-1 text-sm text-forest/70">There are no bookings matching the selected filter.</p>
                </div>
            @endforelse
        </div>

        <div class="mt-12">
            {{ $bookings->appends(request()->query())->links('vendor.pagination.modern-theme') }}
        </div>

        @include('admin.users.partials.user-details-modal')
        @include('admin.properties.partials.property-details-modal')
        @include('admin.bookings.partials.booking-details-modal')
    </div>
@endsection

@extends('layouts.admin')

@section('title', 'Dashboard')

@section('page-title', 'Welcome Back, Admin!')

@section('content')

    {{-- Main Section: Pending Registration Requests --}}
    <div class="mb-12">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-walnut font-heading">Pending Registration Requests</h2>
            @php
            $pending_users = \App\Models\User::where('role', 'PENDING')->orderBy('created_at', 'desc')->take(20)->get();
            @endphp
            @if(count($pending_users) > 0)
                <a href="{{ route('admin.users.registration-requests') }}" class="text-sm font-semibold text-ochre hover:text-walnut transition-colors">
                    View All &rarr;
                </a>
            @endif
        </div>

        {{-- The list of request cards --}}
        <div class="space-y-4">
            @forelse ($pending_users as $user)
                {{-- This is the new, simplified Action Card --}}
                <div class="bg-white rounded-xl shadow-sm border border-sandstone/30 p-5 transition-all duration-300 hover:shadow-md hover:border-sandstone">
                    <div class="flex flex-wrap items-center justify-between gap-4">

                        {{-- User Info --}}
                        <div class="flex items-center">
                            <div class="flex-shrink-0 h-11 w-11 flex items-center justify-center rounded-full bg-sandstone text-walnut font-bold font-heading">
                                {{-- A helper function in your User model to get initials is great for this --}}
                                {{ substr($user->first_name, 0, 1) }}{{ substr($user->last_name, 0, 1) }}
                            </div>
                            <div class="ml-4">
                                <div class="text-base font-semibold text-walnut">{{ $user->first_name }} {{ $user->last_name }}</div>
                                <div class="text-sm text-forest/80">{{ $user->phone }}</div>
                            </div>
                        </div>

                        <div class="flex items-center gap-6">
                             {{-- Request Date --}}
                            <div class="text-sm text-forest/60">
                                Requested {{ $user->created_at->diffForHumans() }}
                            </div>

                            {{-- Action Buttons --}}
                            <div class="flex items-center space-x-3">
                                <form action="{{ route('admin.users.reject', $user->id) }}" method="POST">
                                    @csrf
                                    <button type="submit" class="px-5 py-2 rounded-lg font-semibold text-sm bg-sandstone/50 text-walnut hover:bg-sandstone/80 transition-all duration-200">
                                        Reject
                                    </button>
                                </form>
                                <form action="{{ route('admin.users.approve', $user->id) }}" method="POST">
                                    @csrf
                                    <button type="submit" class="px-5 py-2 rounded-lg font-semibold text-sm bg-ochre text-white hover:bg-ochre/90 shadow-sm hover:shadow-md transition-all duration-200">
                                        Approve
                                    </button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            @empty
                {{-- A beautiful "empty state" when there are no requests --}}
                <div class="text-center border-2 border-dashed border-sandstone/50 rounded-xl py-16">
                    <svg class="mx-auto h-12 w-12 text-sandstone" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    <h3 class="mt-2 text-lg font-semibold text-walnut font-heading">All Caught Up!</h3>
                    <p class="mt-1 text-sm text-forest/70">There are no new registration requests.</p>
                </div>
            @endforelse
        </div>
    </div>


    {{-- Secondary Section: Quick Stats --}}
    <div>
        <h2 class="text-xl font-bold text-walnut font-heading mb-6">At a Glance</h2>
        {{-- Updated grid to have 3 columns on large screens --}}
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

            {{-- Simplified Stat Card: Total Users --}}
            <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-sandstone/30">
                <p class="text-sm font-medium text-forest/80">Total Users</p>
                <p class="text-3xl font-bold text-walnut mt-1">{{ number_format($stats['total_users']) }}</p>
            </div>

            {{-- Simplified Stat Card: Total Properties --}}
            <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-sandstone/30">
                <p class="text-sm font-medium text-forest/80">Listed Properties</p>
                <p class="text-3xl font-bold text-walnut mt-1">{{ number_format($stats['total_properties']) }}</p>
            </div>

            {{-- Simplified Stat Card: Active Bookings --}}
            <div class="bg-white/70 backdrop-blur-sm rounded-xl p-6 border border-sandstone/30">
                <p class="text-sm font-medium text-forest/80">Active Bookings</p>
                <p class="text-3xl font-bold text-walnut mt-1">{{ number_format($stats['active_bookings']) }}</p>
            </div>

        </div>
    </div>

@endsection

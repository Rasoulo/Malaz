@extends('layouts.admin')

@section('title', 'Users')
@section('page-title', 'User Management')

@section('content')
    <div x-data="{
        showUserModal: false,
        selectedUser: null,
        showConfirmModal: false,
        showCascadeModal: false,
        deleteFormAction: '',
        isLoading: false,
        hasError: false,

        openUserModal(userId) {
            this.showUserModal = true;
            this.isLoading = true;
            this.hasError = false;
            this.selectedUser = null;

            fetch(`/users/${userId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
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

        <div class="bg-white rounded-xl shadow-sm border border-sandstone/30">
            <div class="px-6 py-5 border-b border-sandstone/30">
                <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
                    <div>
                        <h3 class="text-lg font-bold text-walnut font-heading">Approved Users</h3>
                        <p class="text-sm text-forest/70 mt-1">Search, filter, and manage all user accounts.</p>
                    </div>
                    <form method="GET" action="{{ route('admin.users.index') }}" class="relative">
                        <input type="text" name="search" value="{{ request('search') }}" placeholder="Search by name or email..." class="pl-10 pr-4 py-2 w-64 bg-cream/60 border border-sandstone/50 rounded-lg text-sm text-walnut placeholder-forest/50 focus:outline-none focus:ring-2 focus:ring-ochre/50 focus:border-ochre transition">
                        <div class="absolute left-3 top-1/2 -translate-y-1/2 text-forest/40">
                            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                        </div>
                    </form>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-sandstone/30">
                    <thead class="bg-cream/50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-semibold text-forest/70 uppercase tracking-wider">User</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-semibold text-forest/70 uppercase tracking-wider">Role</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-semibold text-forest/70 uppercase tracking-wider">Joined Date</th>
                            <th scope="col" class="relative px-6 py-3"><span class="sr-only">Actions</span></th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-sandstone/20">
                        @forelse($users as $user)
                            <tr class="hover:bg-cream/50 transition-colors duration-150">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 flex items-center justify-center rounded-full bg-sandstone text-walnut font-bold font-heading text-sm">{{ substr($user->first_name, 0, 1) }}{{ substr($user->last_name, 0, 1) }}</div>
                                        <div class="ml-4">
                                            <div class="text-sm font-semibold text-walnut">{{ $user->first_name }} {{ $user->last_name }}</div>
                                            <div class="text-xs text-forest/60">{{ $user->email ?? $user->phone }}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    @php
                                        $roleConfig = ['ADMIN' => 'bg-forest text-cream', 'OWNER' => 'bg-ochre/20 text-walnut', 'RENTER' => 'bg-sandstone/40 text-walnut', 'USER' => 'bg-sandstone/40 text-walnut'];
                                        $config = $roleConfig[$user->role] ?? 'bg-sandstone/40 text-walnut';
                                    @endphp
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full {{ $config }}">{{ ucfirst(strtolower($user->role)) }}</span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-forest/80">{{ $user->created_at->format('M d, Y') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <div class="flex items-center justify-end space-x-3">
                                        <button @click="openUserModal({{ $user->id }})" class="p-2 rounded-full text-forest/50 hover:bg-ochre/10 hover:text-ochre transition-colors" title="View User Details">
                                            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                                        </button>
                                        @if($user->id !== auth()->id())
                                            <button @click.prevent="deleteFormAction = '{{ route('admin.users.destroy', $user) }}'; selectedUser = {{ Js::from($user) }}; if (selectedUser.properties_count > 0) { showCascadeModal = true; } else { showConfirmModal = true; }" type="button" class="p-2 rounded-full text-forest/50 hover:bg-red-500/10 hover:text-red-600 transition-colors" title="Delete User">
                                                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                            </button>
                                        @endif
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="text-center py-16">
                                    <svg class="mx-auto h-12 w-12 text-sandstone" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M15 21a6 6 0 00-9-5.197m0 0A4 4 0 019 9.171" /></svg>
                                    <h3 class="mt-2 text-lg font-semibold text-walnut font-heading">No Users Found</h3>
                                    <p class="mt-1 text-sm text-forest/70">Try adjusting your search.</p>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>

            @if($users->hasPages())
                <div class="px-6 py-4 border-t border-sandstone/30 bg-white/50">
                    {{ $users->links('vendor.pagination.modern-theme') }}
                </div>
            @endif
        </div>

        @include('admin.users.partials.user-details-modal')
        @include('partials.confirm-delete-modal')
        @include('partials.cascade-delete-modal')
    </div>
@endsection

{{-- resources/views/admin/users/partials/user-details-modal.blade.php --}}

<div
    x-show="showUserModal"
    x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0" x-transition:enter-end="opacity-100"
    x-transition:leave="transition ease-in duration-200" x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
    class="fixed inset-0 z-30 bg-forest/50 backdrop-blur-sm flex items-center justify-center p-4"
    style="display: none;"
>
    <div
        @click.away="showUserModal = false"
        x-show="showUserModal"
        x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-95" x-transition:enter-end="opacity-100 transform scale-100"
        x-transition:leave="transition ease-in duration-200" x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-95"
        class="bg-cream rounded-xl shadow-2xl w-full max-w-4xl min-h-[50vh] max-h-[90vh] flex flex-col"
    >
        {{-- Loading State --}}
        <div x-show="isLoading" class="flex items-center justify-center flex-grow">
            <svg class="animate-spin h-8 w-8 text-ochre" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
        </div>

        {{-- Content Area --}}
        <div x-show="!isLoading && selectedUser" class="flex flex-col flex-grow" style="display: none;">
            <div class="flex items-center justify-between p-4 border-b border-sandstone/30">
                <h3 class="text-lg font-bold text-walnut font-heading" x-text="selectedUser.first_name + ' ' + selectedUser.last_name"></h3>
                <button @click="showUserModal = false" class="p-2 rounded-full hover:bg-sandstone/50 transition-colors">
                    <svg class="h-5 w-5 text-walnut" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">

                    {{-- Left Column: Images --}}
                    <div class="p-6 space-y-6">
                        <div>
                            <h4 class="text-sm font-semibold text-walnut mb-2">Profile Image</h4>
                            <template x-if="selectedUser.profile_image">
                                <img class="w-full aspect-square object-cover rounded-lg border border-sandstone/30" :src="`data:${selectedUser.profile_image_mime};base64,${selectedUser.profile_image}`" alt="Profile Image">
                            </template>
                            <template x-if="!selectedUser.profile_image">
                                <div class="w-full aspect-square flex items-center justify-center bg-sandstone/20 rounded-lg border border-dashed border-sandstone/50">
                                    <p class="text-sm text-forest/60">Not Provided</p>
                                </div>
                            </template>
                        </div>
                        <div>
                            <h4 class="text-sm font-semibold text-walnut mb-2">Identity Card</h4>
                            <template x-if="selectedUser.identity_card_image">
                                <img class="w-full aspect-video object-contain rounded-lg border border-sandstone/30 bg-white" :src="`data:${selectedUser.identity_card_mime};base64,${selectedUser.identity_card_image}`" alt="Identity Card Image">
                            </template>
                            <template x-if="!selectedUser.identity_card_image">
                                <div class="w-full aspect-video flex items-center justify-center bg-sandstone/20 rounded-lg border border-dashed border-sandstone/50">
                                    <p class="text-sm text-forest/60">Not Provided</p>
                                </div>
                            </template>
                        </div>
                    </div>

                    {{-- Right Column: Details --}}
                    <div class="p-6">
                        <div class="flex items-center mb-8">
                            <div class="flex-shrink-0 h-16 w-16 flex items-center justify-center rounded-full bg-sandstone text-walnut font-bold font-heading text-2xl" x-text="selectedUser.first_name.charAt(0) + selectedUser.last_name.charAt(0)"></div>
                            <div class="ml-4">
                                <h4 class="text-xl font-bold text-walnut font-heading" x-text="selectedUser.first_name + ' ' + selectedUser.last_name"></h4>
                                <p class="text-sm text-forest/80" x-text="selectedUser.phone"></p>
                            </div>
                        </div>

                        <div class="space-y-4 text-sm">
                            <div class="grid grid-cols-3 gap-4">
                                <span class="font-semibold text-forest/60">Role</span>
                                <span class="col-span-2 text-walnut" x-text="selectedUser.role"></span>
                            </div>
                            <div class="grid grid-cols-3 gap-4">
                                <span class="font-semibold text-forest/60">Date of Birth</span>
                                <span class="col-span-2 text-walnut" x-text="new Date(selectedUser.date_of_birth).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })"></span>
                            </div>
                            <div class="grid grid-cols-3 gap-4">
                                <span class="font-semibold text-forest/60">Joined On</span>
                                <span class="col-span-2 text-walnut" x-text="new Date(selectedUser.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })"></span>
                            </div>
                             <div class="grid grid-cols-3 gap-4">
                                <span class="font-semibold text-forest/60">Phone Status</span>
                                <span class="col-span-2 text-walnut">
                                     <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full" :class="selectedUser.phone_verified_at ? 'bg-forest/10 text-forest' : 'bg-ochre/10 text-ochre'" x-text="selectedUser.phone_verified_at ? 'Verified' : 'Not Verified'"></span>
                                </span>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

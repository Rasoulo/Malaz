{{-- resources/views/admin/bookings/partials/booking-details-modal.blade.php --}}

<div
    x-show="showBookingModal"
    x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0" x-transition:enter-end="opacity-100"
    x-transition:leave="transition ease-in duration-200" x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
    class="fixed inset-0 z-40 bg-forest/50 backdrop-blur-sm flex items-center justify-center p-4"
    style="display: none;"
>
    <div
        @click.away="showBookingModal = false"
        x-show="showBookingModal"
        x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-95" x-transition:enter-end="opacity-100 transform scale-100"
        x-transition:leave="transition ease-in duration-200" x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-95"
        class="bg-cream rounded-xl shadow-2xl w-full max-w-4xl min-h-[50vh] max-h-[90vh] flex flex-col"
    >
        {{-- Loading and Error States --}}
        <div x-show="isLoading" class="flex items-center justify-center flex-grow">
            <svg class="animate-spin h-8 w-8 text-ochre" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
        </div>
        <div x-show="hasError" class="flex flex-col items-center justify-center flex-grow p-8 text-center" style="display: none;">
            <h3 class="mt-4 text-lg font-bold text-walnut font-heading">Failed to Load Booking</h3>
            <p class="mt-2 text-sm text-forest/70">The booking details could not be loaded.</p>
            <button @click="showBookingModal = false" class="mt-6 px-6 py-2.5 rounded-lg font-semibold text-sm bg-white border border-sandstone/50 text-walnut hover:bg-sandstone/30 transition">Close</button>
        </div>

        {{-- Content Area --}}
        <div x-show="!isLoading && selectedBooking && !hasError" class="flex flex-col flex-grow" style="display: none;">
            <div class="flex items-start justify-between p-5 border-b border-sandstone/30">
                <div>
                    <h3 class="text-lg font-bold text-walnut font-heading" x-text="`Booking #${selectedBooking.id}`"></h3>
                    <p class="text-sm text-forest/70" x-text="`Created on ${new Date(selectedBooking.created_at).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}`"></p>
                </div>
                <div class="flex items-center gap-4">
                     <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full" :class="{ 'bg-amber-100 text-amber-800': selectedBooking.status === 'pending', 'bg-sky-100 text-sky-800': selectedBooking.status === 'confirmed', 'bg-blue-100 text-blue-800': selectedBooking.status === 'ongoing', 'bg-green-100 text-green-800': selectedBooking.status === 'completed', 'bg-slate-100 text-slate-800': selectedBooking.status === 'cancelled', 'bg-red-100 text-red-800': ['rejected', 'conflicted'].includes(selectedBooking.status) }" x-text="selectedBooking.status.charAt(0).toUpperCase() + selectedBooking.status.slice(1)"></span>
                    <button @click="showBookingModal = false" class="p-2 rounded-full hover:bg-sandstone/50 transition-colors">
                        <svg class="h-5 w-5 text-walnut" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                    </button>
                </div>
            </div>

            <div class="flex-1 overflow-y-auto">
                <div class="grid grid-cols-1 lg:grid-cols-5 gap-6 p-6">

                    {{-- Left Column: Property & User Details --}}
                    <div class="lg:col-span-3 space-y-6">
                        {{-- Property Card --}}
                        <div class="bg-white/50 p-4 rounded-lg border border-sandstone/30">
                            <h4 class="text-sm font-semibold text-walnut mb-3">Property Details</h4>
                            <div class="flex items-start gap-4">
                                <img class="w-24 h-24 object-cover rounded-md flex-shrink-0" :src="`data:${selectedBooking.property.mime_type};base64,${selectedBooking.property.main_image}`" :alt="selectedBooking.property.title">
                                <div class="flex-grow">
                                    <p class="font-bold text-ochre text-lg" x-text="selectedBooking.property.title"></p>
                                    <p class="text-xs text-forest/70" x-text="`${selectedBooking.property.address}, ${selectedBooking.property.city}`"></p>
                                    <button @click="$dispatch('open-property-modal', { propertyId: selectedBooking.property.id }); showBookingModal = false" class="mt-3 w-full text-center px-4 py-2 text-xs font-semibold text-ochre bg-ochre/10 rounded-lg hover:bg-ochre/20 transition-colors">
                                        View Full Property Details
                                    </button>
                                </div>
                            </div>
                        </div>

                        {{-- User Card --}}
                        <div class="bg-white/50 p-4 rounded-lg border border-sandstone/30">
                            <h4 class="text-sm font-semibold text-walnut mb-3">Booked By</h4>
                             <div class="flex items-start gap-4">
                                <div class="flex-shrink-0 h-16 w-16 flex items-center justify-center rounded-full bg-sandstone text-walnut font-bold font-heading text-xl" x-text="selectedBooking.user.first_name.charAt(0) + selectedBooking.user.last_name.charAt(0)"></div>
                                <div class="flex-grow">
                                    <p class="font-bold text-ochre text-lg" x-text="selectedBooking.user.first_name + ' ' + selectedBooking.user.last_name"></p>
                                    <p class="text-xs text-forest/70" x-text="selectedBooking.user.phone"></p>
                                    <button @click="$dispatch('open-user-modal', { userId: selectedBooking.user.id }); showBookingModal = false" class="mt-3 w-full text-center px-4 py-2 text-xs font-semibold text-ochre bg-ochre/10 rounded-lg hover:bg-ochre/20 transition-colors">
                                        View Full User Details
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    {{-- Right Column: Booking & Payment --}}
                    <div class="lg:col-span-2 bg-white/50 p-4 rounded-lg border border-sandstone/30">
                         <h4 class="text-sm font-semibold text-walnut mb-4">Booking Summary</h4>
                         <div class="space-y-4">
                             <div class="flex items-center gap-4">
                                 <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center bg-ochre/10 rounded-lg text-ochre">
                                     <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                                 </div>
                                 <div>
                                     <p class="text-xs text-forest/60">Check-in</p>
                                     <p class="font-semibold text-walnut" x-text="new Date(selectedBooking.check_in).toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' })"></p>
                                 </div>
                             </div>
                             <div class="flex items-center gap-4">
                                  <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center bg-ochre/10 rounded-lg text-ochre">
                                     <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                                 </div>
                                 <div>
                                     <p class="text-xs text-forest/60">Check-out</p>
                                     <p class="font-semibold text-walnut" x-text="new Date(selectedBooking.check_out).toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' })"></p>
                                 </div>
                             </div>
                              <div class="flex items-center gap-4">
                                  <div class="w-10 h-10 flex-shrink-0 flex items-center justify-center bg-forest/10 rounded-lg text-forest">
                                     <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                 </div>
                                 <div>
                                     <p class="text-xs text-forest/60">Total Duration</p>
                                     <p class="font-semibold text-walnut" x-text="`${Math.round((new Date(selectedBooking.check_out) - new Date(selectedBooking.check_in)) / (1000 * 60 * 60 * 24))} nights`"></p>
                                 </div>
                             </div>
                             <div class="border-t border-sandstone/30 my-4"></div>
                             <div class="flex items-center justify-between">
                                <p class="font-semibold text-forest/80">Total Price:</p>
                                <p class="text-2xl font-bold text-forest" x-text="`$${Number(selectedBooking.total_price).toLocaleString()}`"></p>
                             </div>
                         </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

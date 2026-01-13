{{-- resources/views/admin/properties/partials/property-details-modal.blade.php --}}

<div x-show="showPropertyModal" x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0"
    x-transition:enter-end="opacity-100" x-transition:leave="transition ease-in duration-200"
    x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
    class="fixed inset-0 z-30 bg-forest/50 backdrop-blur-sm flex items-center justify-center p-4" style="display: none;">
    <div @click.away="showPropertyModal = false" x-show="showPropertyModal"
        x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-95"
        x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-95"
        class="bg-cream rounded-xl shadow-2xl w-full max-w-4xl min-h-[50vh] max-h-[90vh] flex flex-col"
        x-data="{ currentImageSrc: '', allImages: [] }" x-init="$watch('selectedProperty', value => {
            if (value) {
                const mainImg = { image: value.main_image, mime_type: value.mime_type, alt: 'Main Image' };
                allImages = [mainImg, ...value.images];
                currentImageSrc = `data:${mainImg.mime_type};base64,${mainImg.image}`;
            }
        })">
        {{-- Loading State --}}
        <div x-show="isLoading" class="flex items-center justify-center flex-grow">
            <svg class="animate-spin h-8 w-8 text-ochre" xmlns="http://www.w3.org/2000/svg" fill="none"
                viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
                </circle>
                <path class="opacity-75" fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                </path>
            </svg>
        </div>

        {{-- Error State --}}
        <div x-show="hasError" class="flex flex-col items-center justify-center flex-grow p-8 text-center"
            style="display: none;">
            <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100">
                <svg class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
            <h3 class="mt-4 text-lg font-bold text-walnut font-heading">Failed to Load Property</h3>
            <p class="mt-2 text-sm text-forest/70">The property details could not be loaded. Please check the browser
                console for errors and ensure the server is running correctly.</p>
            <button @click="showPropertyModal = false"
                class="mt-6 px-6 py-2.5 rounded-lg font-semibold text-sm bg-white border border-sandstone/50 text-walnut hover:bg-sandstone/30 transition">Close</button>
        </div>

        {{-- Content Area --}}
        <div x-show="!isLoading && selectedProperty && !hasError" class="flex flex-col flex-grow"
            style="display: none;">
            <div class="flex items-center justify-between p-4 border-b border-sandstone/30">
                <h3 class="text-lg font-bold text-walnut font-heading" x-text="selectedProperty.title"></h3>
                <button @click="showPropertyModal = false"
                    class="p-2 rounded-full hover:bg-sandstone/50 transition-colors">
                    <svg class="h-5 w-5 text-walnut" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="flex-1 overflow-y-auto">
                <div class="grid grid-cols-1 lg:grid-cols-2">

                    <div class="p-6">
                        <!-- Main Image Display -->
                        <div class="mb-4">
                            <img class="aspect-video w-full object-contain rounded-lg bg-white/50 border border-sandstone/30"
                                :src="currentImageSrc" alt="Selected property image">
                        </div>
                        <!-- Thumbnails -->
                        <div class="grid grid-cols-5 gap-2">
                            <template x-for="(image, index) in allImages" :key="index">
                                <button @click="currentImageSrc = `data:${image.mime_type};base64,${image.image}`">
                                    <img class="aspect-square w-full object-cover rounded-md cursor-pointer border-2 transition"
                                        :class="currentImageSrc === `data:${image.mime_type};base64,${image.image}` ?
                                            'border-ochre' : 'border-transparent hover:border-ochre/50'"
                                        :src="`data:${image.mime_type};base64,${image.image}`" alt="Property thumbnail">
                                </button>
                            </template>
                        </div>
                    </div>

                    <div class="p-6">
                        <div class="flex items-center justify-between">
                            <p class="text-sm text-ochre font-semibold"
                                x-text="selectedProperty.type + ' in ' + selectedProperty.city"></p>
                            <div class="px-3 py-1 text-xs font-bold rounded-full"
                                :class="{
                                    'bg-amber-500/80 text-white': selectedProperty
                                        .status === 'pending',
                                    'bg-forest/80 text-white': selectedProperty
                                        .status === 'approved',
                                    'bg-red-500/80 text-white': selectedProperty
                                        .status === 'rejected'
                                }"
                                x-text="selectedProperty.status.charAt(0).toUpperCase() + selectedProperty.status.slice(1)">
                            </div>
                        </div>
                        <h3 class="font-bold font-heading text-2xl text-walnut mt-2" x-text="selectedProperty.title">
                        </h3>
                        <p class="text-2xl font-semibold text-forest mt-2"
                            x-html="`$${Number(selectedProperty.price).toLocaleString()} <span class='text-sm font-normal text-forest/70'>/ night</span>`">
                        </p>

                        <div class="grid grid-cols-3 gap-4 text-center border-t border-b border-sandstone/20 py-4 my-6">
                            <div>
                                <p class="font-bold text-lg text-walnut" x-text="selectedProperty.number_of_bedrooms">
                                </p>
                                <p class="text-xs text-forest/60">Beds</p>
                            </div>
                            <div>
                                <p class="font-bold text-lg text-walnut" x-text="selectedProperty.number_of_baths"></p>
                                <p class="text-xs text-forest/60">Baths</p>
                            </div>
                            <div>
                                <p class="font-bold text-lg text-walnut" x-html="`${selectedProperty.area} m²`"></p>
                                <p class="text-xs text-forest/60">Area</p>
                            </div>
                        </div>

                        <h4 class="text-sm font-semibold text-walnut mb-2">Description</h4>
                        <p class="text-sm text-forest/80 mb-6"
                            x-text="selectedProperty.description || 'No description provided.'"></p>

                        <h4 class="text-sm font-semibold text-walnut mb-2">Address</h4>
                        <p class="text-sm text-forest/80 mb-6"
                            x-text="`${selectedProperty.address}, ${selectedProperty.city}, ${selectedProperty.governorate}`">
                        </p>

                        <h4 class="text-sm font-semibold text-walnut mb-2">Owner</h4>
                        <div
                            class="flex items-center justify-between p-3 bg-white/50 rounded-lg border border-sandstone/30">
                            <p class="text-sm font-semibold text-walnut"
                                x-text="selectedProperty.user.first_name + ' ' + selectedProperty.user.last_name"></p>
                            <button @click="showPropertyModal = false; openUserModal(selectedProperty.user.id)"
                                class="px-4 py-2 text-xs font-semibold bg-white border border-sandstone/40 rounded-md hover:bg-sandstone/30 transition">
                                View Owner Details
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

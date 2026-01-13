{{-- resources/views/partials/confirm-delete-modal.blade.php --}}

<div
    x-show="showConfirmModal"
    x-transition:enter="transition ease-out duration-300"
    x-transition:enter-start="opacity-0"
    x-transition:enter-end="opacity-100"
    x-transition:leave="transition ease-in duration-200"
    x-transition:leave-start="opacity-100"
    x-transition:leave-end="opacity-0"
    class="fixed inset-0 z-30 bg-forest/50 backdrop-blur-sm flex items-center justify-center p-4"
    style="display: none;"
>
    {{-- The Modal Card --}}
    <div
        @click.away="showConfirmModal = false"
        x-show="showConfirmModal"
        x-transition:enter="transition ease-out duration-300"
        x-transition:enter-start="opacity-0 transform scale-95"
        x-transition:enter-end="opacity-100 transform scale-100"
        x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="opacity-100 transform scale-100"
        x-transition:leave-end="opacity-0 transform scale-95"
        class="bg-cream rounded-xl shadow-2xl w-full max-w-md"
    >
        <div class="p-6 text-center">
            {{-- Icon --}}
            <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100">
                <svg class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>

            {{-- Text --}}
            <h3 class="mt-4 text-lg font-bold text-walnut font-heading">Delete User?</h3>
            <p class="mt-2 text-sm text-forest/70">
                Are you sure you want to permanently delete this user? This action cannot be undone.
            </p>

            {{-- Action Buttons --}}
            <div class="mt-6 flex justify-center gap-4">
                <button
                    @click="showConfirmModal = false"
                    type="button"
                    class="px-6 py-2.5 rounded-lg font-semibold text-sm bg-white border border-sandstone/50 text-walnut hover:bg-sandstone/30 transition"
                >
                    Cancel
                </button>

                {{-- === THE FIX IS HERE === --}}
                {{-- This button now finds the form using the `deleteFormAction` URL and submits it. --}}
                <form :action="deleteFormAction" method="POST" id="dynamicDeleteForm">
                    @csrf
                    @method('DELETE')
                    <button
                        type="submit"
                        class="px-6 py-2.5 rounded-lg font-semibold text-sm bg-red-600 text-white hover:bg-red-700 shadow-sm hover:shadow-md transition-all"
                    >
                        Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

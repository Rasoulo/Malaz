@extends('layouts.admin')

@section('title', 'Edit Property')

@section('page-title', 'Edit Property')

@section('breadcrumb')
    <li>
        <a href="{{ route('admin.properties.index') }}" class="text-sm font-medium text-gray-700">Properties</a>
    </li>
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400 text-xs mx-2"></i>
            <span class="text-sm font-medium text-gray-700">Edit #{{ str_pad($property->id, 6, '0', STR_PAD_LEFT) }}</span>
        </div>
    </li>
@endsection

@section('content')
    <div class="max-w-4xl mx-auto px-4 sm:px-6">
        <div class="bg-white rounded-2xl shadow-md border border-gray-200 p-6">
            <form action="{{ route('admin.properties.update', $property) }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                @if ($errors->any())
                    <div class="mb-4 p-4 bg-red-50 border border-red-100 rounded">
                        <ul class="text-sm text-red-700 space-y-1">
                            @foreach ($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="text-sm font-medium text-gray-700">Property Type</label>
                        <input type="text" name="type" value="{{ old('type', $property->type) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('type')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-700">Area (m²)</label>
                        <input type="number" step="0.01" name="area" value="{{ old('area', $property->area) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('area')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-700">Rooms</label>
                        <input type="number" name="number_of_rooms"
                            value="{{ old('number_of_rooms', $property->number_of_rooms) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('number_of_rooms')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-700">Bathrooms</label>
                        <input type="number" name="number_of_baths"
                            value="{{ old('number_of_baths', $property->number_of_baths) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('number_of_baths')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Governorate removed per request --}}

                    <div>
                        <label class="text-sm font-medium text-gray-700">City</label>
                        <input type="text" name="city" value="{{ old('city', $property->city) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('city')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div class="md:col-span-2">
                        <label class="text-sm font-medium text-gray-700">Address</label>
                        <input type="text" name="address" value="{{ old('address', $property->address) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('address')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div>
                        <label class="text-sm font-medium text-gray-700">Monthly Rent (USD)</label>
                        <input type="number" step="0.01" name="price" value="{{ old('price', $property->price) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('price')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Security Deposit removed per request --}}

                    <div>
                        <label class="text-sm font-medium text-gray-700">Minimum Stay (months)</label>
                        <input type="number" name="minimum_stay"
                            value="{{ old('minimum_stay', $property->minimum_stay) }}"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                        @error('minimum_stay')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <div class="md:col-span-2">
                        <label class="text-sm font-medium text-gray-700">Description</label>
                        <textarea name="description" rows="4"
                            class="mt-1 block w-full border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">{{ old('description', $property->description) }}</textarea>
                        @error('description')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Amenities removed per request --}}

                    <div class="md:col-span-2">
                        <label class="text-sm font-medium text-gray-700">Upload Images</label>
                        <input type="file" name="images[]" multiple class="mt-1 block w-full text-sm text-gray-700">
                        @error('images')
                            <p class="text-xs text-red-600 mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Utilities included removed per request --}}

                    <div>
                        <label class="text-sm font-medium text-gray-700">Status</label>
                        <div class="relative mt-1">
                            <select name="status"
                                class="appearance-none w-full text-sm font-medium border border-gray-200 bg-white px-3 py-2 rounded-lg shadow-sm pr-10 transition focus:outline-none focus:ring-2 focus:ring-primary focus:border-primary">
                                @php
                                    $statuses = [
                                        'pending' => 'Pending',
                                        'approved' => 'Approved',
                                        'suspended' => 'Suspended',
                                        'rejected' => 'Rejected',
                                    ];
                                @endphp
                                @foreach ($statuses as $k => $label)
                                    <option value="{{ $k }}"
                                        {{ old('status', $property->status) == $k ? 'selected' : '' }}>{{ $label }}
                                    </option>
                                @endforeach
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                    viewBox="0 0 20 20">
                                    <path
                                        d="M5.23 7.21a.75.75 0 011.06.02L10 10.94l3.71-3.71a.75.75 0 111.06 1.06l-4.24 4.24a.75.75 0 01-1.06 0L5.21 8.29a.75.75 0 01.02-1.08z" />
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-6 flex items-center justify-end space-x-3">
                    <a href="{{ route('admin.properties.show', $property) }}"
                        class="inline-flex items-center px-4 py-2 border border-gray-200 rounded-lg text-sm text-gray-700 hover:bg-gray-50 transition">Cancel</a>
                    <button type="submit"
                        class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:opacity-95 transition shadow-md focus:outline-none focus:ring-2 focus:ring-primary">Save
                        Changes</button>
                </div>
            </form>
        </div>
    </div>
@endsection

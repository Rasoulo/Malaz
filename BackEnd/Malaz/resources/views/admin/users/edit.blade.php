@extends('layouts.admin')

@section('title', 'Edit User')

@section('page-title', 'Edit User')

@section('breadcrumb')
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <a href="{{ route('admin.users.index') }}"
                class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Users</a>
        </div>
    </li>
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <a href="{{ route('admin.users.show', $user) }}"
                class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">{{ $user->first_name }}
                {{ $user->last_name }}</a>
        </div>
    </li>
    <li>
        <div class="flex items-center">
            <i class="fas fa-chevron-right text-gray-400"></i>
            <span class="ml-1 text-sm font-medium text-gray-700 md:ml-2">Edit</span>
        </div>
    </li>
@endsection

@section('content')
    <div class="max-w-3xl mx-auto">
        <div class="bg-white rounded-xl shadow-sm border border-gray-200">
            <div class="px-6 py-4 border-b border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900">Edit User Information</h3>
            </div>

            <form method="POST" action="{{ route('admin.users.update', $user) }}" class="p-6">
                @csrf
                @method('PUT')

                <div class="space-y-6">
                    <!-- Personal Information -->
                    <div>
                        <h4 class="text-md font-medium text-gray-900 mb-4">Personal Information</h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- First Name -->
                            <div>
                                <label for="first_name" class="block text-sm font-medium text-gray-700 mb-1">
                                    First Name *
                                </label>
                                <input type="text" name="first_name" id="first_name"
                                    value="{{ old('first_name', $user->first_name) }}"
                                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent"
                                    required>
                                @error('first_name')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Last Name -->
                            <div>
                                <label for="last_name" class="block text-sm font-medium text-gray-700 mb-1">
                                    Last Name *
                                </label>
                                <input type="text" name="last_name" id="last_name"
                                    value="{{ old('last_name', $user->last_name) }}"
                                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent"
                                    required>
                                @error('last_name')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Email -->
                            <div>
                                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                                    Email Address (Optional - for admin only)
                                </label>
                                <input type="email" name="email" id="email" value="{{ old('email', $user->email) }}"
                                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent"
                                    placeholder="admin@example.com">
                                <p class="mt-1 text-xs text-gray-500">Leave empty for mobile users. Only needed for admin
                                    login.</p>
                                @error('email')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Phone -->
                            <div>
                                <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">
                                    Phone Number *
                                </label>
                                <input type="text" name="phone" id="phone"
                                    value="{{ old('phone', $user->phone) }}"
                                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent"
                                    required>
                                @error('phone')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Date of Birth -->
                            <div>
                                <label for="date_of_birth" class="block text-sm font-medium text-gray-700 mb-1">
                                    Date of Birth *
                                </label>
                                <input type="date" name="date_of_birth" id="date_of_birth"
                                    value="{{ old('date_of_birth', $user->date_of_birth ? $user->date_of_birth->format('Y-m-d') : '') }}"
                                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent"
                                    required>
                                @error('date_of_birth')
                                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                @enderror
                            </div>
                        </div>
                    </div>

                    <!-- Account Settings -->
                    <div class="pt-6 border-t border-gray-200">
                        <h4 class="text-md font-medium text-gray-900 mb-4">Account Settings</h4>

                        <!-- Role -->
                        <div class="mb-6">
                            <label for="role" class="block text-sm font-medium text-gray-700 mb-1">
                                User Role *
                            </label>
                            <select name="role" id="role"
                                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent">
                                <option value="PENDING" {{ old('role', $user->role) == 'PENDING' ? 'selected' : '' }}>
                                    Pending</option>
                                <option value="USER" {{ old('role', $user->role) == 'USER' ? 'selected' : '' }}>User
                                </option>
                                <option value="ADMIN" {{ old('role', $user->role) == 'ADMIN' ? 'selected' : '' }}>
                                    Administrator</option>
                            </select>
                            @error('role')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                        </div>

                        <!-- Password Update (Optional) -->
                        <div>
                            <h5 class="text-sm font-medium text-gray-700 mb-3">Change Password (Optional)</h5>
                            <div class="space-y-4">
                                <div>
                                    <label for="password" class="block text-sm text-gray-600 mb-1">
                                        New Password
                                    </label>
                                    <input type="password" name="password" id="password"
                                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent">
                                    @error('password')
                                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                                    @enderror
                                </div>

                                <div>
                                    <label for="password_confirmation" class="block text-sm text-gray-600 mb-1">
                                        Confirm New Password
                                    </label>
                                    <input type="password" name="password_confirmation" id="password_confirmation"
                                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-light focus:border-transparent">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="mt-8 pt-6 border-t border-gray-200">
                    <div class="flex justify-end space-x-4">
                        <a href="{{ route('admin.users.show', $user) }}"
                            class="px-5 py-2.5 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition font-medium">
                            Cancel
                        </a>

                        <button type="submit"
                            class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition font-medium shadow-md hover:shadow-lg flex items-center">
                            <i class="fas fa-save mr-2"></i>
                            Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
@endsection

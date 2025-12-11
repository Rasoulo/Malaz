<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    /**
     * Display registration requests (pending users)
     */
    public function registrationRequests(Request $request)
    {
        $search = $request->input('search');

        $pendingUsers = User::where('role', 'PENDING')
            ->when($search, function ($query, $search) {
                return $query->where(function ($q) use ($search) {
                    $q->where('first_name', 'like', '%' . $search . '%')
                        ->orWhere('last_name', 'like', '%' . $search . '%')
                        ->orWhere('phone', 'like', '%' . $search . '%');
                });
            })
            ->latest()
            ->paginate(15)
            ->withQueryString();

        return view('admin.users.registration-requests', compact('pendingUsers', 'search'));
    }

    /**
     * Approve a registration request
     */
    public function approve(User $user, Request $request)
    {
        // Check if user is pending
        if ($user->role !== 'PENDING') {
            return redirect()->back()
                ->with('error', 'This user is already approved.');
        }

        // Simple direct update
        $user->role = 'USER';
        $user->phone_verified_at = date('Y-m-d H:i:s');

        if ($user->save()) {
            return redirect()->route('admin.users.registration-requests')
                ->with('success', 'User approved successfully.');
        }

        return redirect()->back()
            ->with('error', 'Failed to approve user.');
    }

    /**
     * Reject a registration request
     */
    public function reject(User $user, Request $request)
    {
        // Check if user is pending
        if ($user->role !== 'PENDING') {
            return redirect()->back()
                ->with('error', 'This user is already approved.');
        }

        // Add a reason for rejection (optional)
        $reason = $request->input('reason', 'Registration rejected by admin.');

        // You might want to store the rejection reason in a separate table
        // For now, we'll just delete the user
        $user->delete();

        return redirect()->route('admin.users.registration-requests')
            ->with('success', 'Registration request rejected and user removed.');
    }

    /**
     * Display a listing of all users (except pending)
     */
    public function index(Request $request)
    {
        $search = $request->input('search');
        $role = $request->input('role');

        // Get approved users (not pending)
        $users = User::where('role', '!=', 'PENDING')
            ->when($search, function ($query, $search) {
                return $query->where(function ($q) use ($search) {
                    $q->where('first_name', 'like', '%' . $search . '%')
                        ->orWhere('last_name', 'like', '%' . $search . '%')
                        ->orWhere('phone', 'like', '%' . $search . '%');
                });
            })
            ->when($role, function ($query, $role) {
                return $query->where('role', $role);
            })
            ->latest()
            ->paginate(15)
            ->withQueryString();

        return view('admin.users.index', compact('users', 'search'));
    }

    /**
     * Display the specified user.
     */
    public function show(User $user)
    {
        return view('admin.users.show', compact('user'));
    }

    /**
     * Show the form for editing the specified user.
     */
    public function edit(User $user)
    {
        return view('admin.users.edit', compact('user'));
    }

    /**
     * Update the specified user in storage.
     */
    public function update(Request $request, User $user)
    {
        // Remove email validation since it's for admin only
        $validated = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'phone' => [
                'required',
                'string',
                Rule::unique('users')->ignore($user->id),
            ],
            'date_of_birth' => 'required|date',
            'role' => 'required|in:PENDING,USER,ADMIN',
        ]);

        // Only update email if it exists (for admin users)
        if ($request->has('email') && $request->email) {
            $request->validate([
                'email' => [
                    'nullable',
                    'email',
                    Rule::unique('users')->ignore($user->id),
                ],
            ]);
            $validated['email'] = $request->email;
        }

        // Check if password is being updated
        if ($request->filled('password')) {
            $request->validate([
                'password' => 'min:8|confirmed',
            ]);
            $validated['password'] = Hash::make($request->password);
        }

        $user->update($validated);

        return redirect()->route('admin.users.index')
            ->with('success', 'User updated successfully.');
    }

    /**
     * Remove the specified user from storage.
     */
    public function destroy(User $user)
    {
        // Prevent deleting yourself
        if ($user->id === auth()->id()) {
            return redirect()->back()
                ->with('error', 'You cannot delete your own account.');
        }

        $user->delete();

        return redirect()->route('admin.users.index')
            ->with('success', 'User deleted successfully.');
    }
}

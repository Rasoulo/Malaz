<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PropertyController extends Controller
{
    /**
     * Display a listing of properties.
     *
     * This method handles the main properties page with search and filters.
     */
    public function index(Request $request)
    {
        // Get search and filter parameters from the request
        $search = $request->input('search');
        $status = $request->input('status');

        // Start building our query
        // 'with' loads the owner relationship to avoid N+1 query problem
        $properties = Property::with('user')
            // Search functionality
            ->when($search, function ($query, $search) {
                return $query->where(function ($q) use ($search) {
                    $q->where('address', 'like', '%' . $search . '%')
                      ->orWhere('city', 'like', '%' . $search . '%')
                      ->orWhere('governorate', 'like', '%' . $search . '%')
                      ->orWhere('description', 'like', '%' . $search . '%');
                });
            })
            // Filter by status if provided
            ->when($status, function ($query, $status) {
                return $query->where('status', $status);
            })
            // Order by newest first
            ->latest()
            // Paginate results (15 per page)
            ->paginate(15)
            // Keep search parameters in pagination links
            ->withQueryString();

        // Pass data to the view
        return view('admin.properties.index', compact('properties', 'search'));
    }

    /**
     * Display the specified property.
     */
    public function show(Property $property)
    {
        // Eager load owner relationship to display owner info
        $property->load('user');

        return view('admin.properties.show', compact('property'));
    }

    /**
     * Show the form for editing the specified property.
     */
    public function edit(Property $property)
    {
        return view('admin.properties.edit', compact('property'));
    }

    /**
     * Update the specified property in storage.
     */
    public function update(Request $request, Property $property)
    {
        // Validate the incoming data
        $validator = Validator::make($request->all(), [
            'price' => 'required|integer|min:0',
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'description' => 'nullable|string',
            'latitude' => 'nullable|string',
            'longitude' => 'nullable|string',
            'type' => 'required|string',
            'number_of_rooms' => 'required|integer|min:0',
            'number_of_baths' => 'required|integer|min:0',
            'area' => 'required|integer|min:0',
            'status' => 'required|in:pending,approved,rejected,suspended',
        ]);

        // If validation fails, redirect back with errors
        if ($validator->fails()) {
            return redirect()->back()
                ->withErrors($validator)
                ->withInput();
        }

        // Update the property with validated data
        $property->update($validator->validated());

        return redirect()->route('admin.properties.show', $property)
            ->with('success', 'Property updated successfully.');
    }

    /**
     * Approve a pending property.
     */
    public function approve(Property $property)
    {
        // Check if property is pending
        if ($property->status !== 'pending' && $property->status !== 'suspended') {
            return redirect()->back()
                ->with('error', 'Only pending properties can be approved.');
        }

        // Update status to approved
        $property->update(['status' => 'approved']);

        return redirect()->back()
            ->with('success', 'Property approved successfully.');
    }

    /**
     * Reject a pending property.
     */
    public function reject(Property $property)
    {
        // Check if property is pending
        if ($property->status !== 'pending') {
            return redirect()->back()
                ->with('error', 'Only pending properties can be rejected.');
        }

        // Update status to rejected
        $property->update(['status' => 'rejected']);

        return redirect()->back()
            ->with('success', 'Property rejected successfully.');
    }

    /**
     * Suspend an approved property.
     */
    public function suspend(Property $property)
    {
        // Check if property is approved
        if ($property->status !== 'approved') {
            return redirect()->back()
                ->with('error', 'Only approved properties can be suspended.');
        }

        // Update status to suspended
        $property->update(['status' => 'suspended']);

        return redirect()->back()
            ->with('success', 'Property suspended successfully.');
    }

    /**
     * Remove the specified property from storage.
     */
    public function destroy(Property $property)
    {
        // Delete the property
        $property->delete();

        return redirect()->route('admin.properties.index')
            ->with('success', 'Property deleted successfully.');
    }
}

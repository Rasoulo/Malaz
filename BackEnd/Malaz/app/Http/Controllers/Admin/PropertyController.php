<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use Illuminate\Http\Request;

class PropertyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $properties = Property::with('user')
            ->when($request->search, function ($query, $search) {
                $query->where('title', 'like', "%{$search}%")
                      ->orWhere('city', 'like', "%{$search}%");
            })
            ->when($request->status, function ($query, $status) {
                $query->where('status', 'like', $status);
            })
            ->latest()
            ->paginate(9);

        return view('admin.properties.index', compact('properties'));
    }

    /**
     * Fetch and return a single property's data for the details modal.
     */
    public function show(Property $property)
    {
        // === THE FIX IS HERE ===
        // Load both 'user' and the 'images' relationship.
        $property->load(['user', 'images']);

        // Explicitly make the large image fields visible for the JSON response.
        $property->makeVisible(['main_image', 'mime_type']);
        foreach ($property->images as $image) {
            $image->makeVisible(['image', 'mime_type']);
        }

        return $property;
    }

    /**
     * Approve a pending property.
     */
    public function approve(Property $property)
    {
        if ($property->status === 'pending') {
            $property->update(['status' => 'approved']);
            return redirect()->back()->with('success', 'Property has been approved.');
        }
        return redirect()->back()->with('error', 'This property is not pending and cannot be approved.');
    }

    /**
     * Reject a pending property.
     */
    public function reject(Property $property)
    {
        if ($property->status === 'pending') {
            $property->update(['status' => 'rejected']);
            return redirect()->back()->with('success', 'Property has been rejected.');
        }
        return redirect()->back()->with('error', 'This property is not pending and cannot be rejected.');
    }
}

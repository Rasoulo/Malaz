<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class PropertyController extends Controller
{
    /**
     * Display a listing of properties.
     *
     * This method handles the main properties page with search and filters.
     */
    public function index(Request $request)
    {
        $search = $request->input('search');
        $status = $request->input('status');

        $query = Property::with(['user', 'images'])
            ->when($search, function ($query, $search) {
                return $query->where(function ($q) use ($search) {
                    $q->where('address', 'like', '%' . $search . '%')
                        ->orWhere('city', 'like', '%' . $search . '%')
                        ->orWhere('governorate', 'like', '%' . $search . '%')
                        ->orWhere('description', 'like', '%' . $search . '%')
                        ->orWhere('title', 'like', '%' . $search . '%');
                });
            })
            ->when($status, function ($query, $status) {
                return $query->where('status', $status);
            })
            // Filter by property type
            ->when($request->filled('type'), function ($q) use ($request) {
                return $q->where('type', $request->input('type'));
            })
            // Price range
            ->when($request->filled('price_min'), function ($q) use ($request) {
                return $q->where('price', '>=', (int) $request->input('price_min'));
            })
            ->when($request->filled('price_max'), function ($q) use ($request) {
                return $q->where('price', '<=', (int) $request->input('price_max'));
            })
            // Rooms
            ->when($request->filled('rooms_min'), function ($q) use ($request) {
                return $q->where('number_of_rooms', '>=', (int) $request->input('rooms_min'));
            })
            ->when($request->filled('rooms_max'), function ($q) use ($request) {
                return $q->where('number_of_rooms', '<=', (int) $request->input('rooms_max'));
            })
            // Baths
            ->when($request->filled('baths_min'), function ($q) use ($request) {
                return $q->where('number_of_baths', '>=', (int) $request->input('baths_min'));
            })
            ->when($request->filled('baths_max'), function ($q) use ($request) {
                return $q->where('number_of_baths', '<=', (int) $request->input('baths_max'));
            })
            // Area
            ->when($request->filled('area_min'), function ($q) use ($request) {
                return $q->where('area', '>=', (int) $request->input('area_min'));
            })
            ->when($request->filled('area_max'), function ($q) use ($request) {
                return $q->where('area', '<=', (int) $request->input('area_max'));
            })
            // Governorate / city filters
            ->when($request->filled('governorate'), function ($q) use ($request) {
                return $q->where('governorate', $request->input('governorate'));
            })
            ->when($request->filled('city'), function ($q) use ($request) {
                return $q->where('city', $request->input('city'));
            });

        // Map-only: return properties with coordinates as JSON (no pagination)
        if ($request->boolean('map')) {
            $mapQuery = (clone $query)->whereNotNull('latitude')->whereNotNull('longitude');

            // If user provided lat/lng and radius, apply Haversine filter
            if ($request->filled('lat') && $request->filled('lng')) {
                $lat = (float) $request->input('lat');
                $lng = (float) $request->input('lng');
                $haversine = "(6371 * acos(cos(radians(?)) * cos(radians(latitude+0)) * cos(radians(longitude+0) - radians(?)) + sin(radians(?)) * sin(radians(latitude+0))))";
                $mapQuery->selectRaw('properties.*,' . $haversine . ' AS distance', [$lat, $lng, $lat]);

                if ($request->filled('radius_km')) {
                    $radius = (float) $request->input('radius_km');
                    $mapQuery->having('distance', '<=', $radius);
                }

                $mapQuery->orderBy('distance');
            }

            $results = $mapQuery->get();

            return response()->json($results->map(function ($p) {
                return [
                    'id' => $p->id,
                    'title' => $p->title,
                    'price' => $p->price,
                    'type' => $p->type,
                    'latitude' => $p->latitude,
                    'longitude' => $p->longitude,
                    'number_of_rooms' => $p->number_of_rooms,
                    'number_of_baths' => $p->number_of_baths,
                    'area' => $p->area,
                    'main_image_url' => $p->main_image_url,
                    'distance' => $p->distance ?? null,
                ];
            }));
        }

        // Sorting: nearest (requires lat & lng) or other orders
        if ($request->input('sort') === 'nearest' && $request->filled('lat') && $request->filled('lng')) {
            $lat = (float) $request->input('lat');
            $lng = (float) $request->input('lng');
            $haversine = "(6371 * acos(cos(radians(?)) * cos(radians(latitude+0)) * cos(radians(longitude+0) - radians(?)) + sin(radians(?)) * sin(radians(latitude+0))))";
            $query->selectRaw('properties.*,' . $haversine . ' AS distance', [$lat, $lng, $lat]);
            $query->orderBy('distance');
        } else {
            // price asc/desc or id desc (newest)
            if ($request->input('sort') === 'price_asc') {
                $query->orderBy('price', 'asc');
            } elseif ($request->input('sort') === 'price_desc') {
                $query->orderBy('price', 'desc');
            } else {
                $query->orderBy('id', 'desc');
            }
        }

        $properties = $query->paginate(15)->withQueryString();

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

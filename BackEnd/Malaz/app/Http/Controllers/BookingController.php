<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Property;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    /**
     * Display a list of bookings.
     */
    public function index(Request $request)
    {
        // If filtering by user_id, allow only the user themselves or admins (view-only)
        if ($request->has('user_id')) {
            $userId = $request->query('user_id');
            if (auth()->id() != $userId && auth()->user()->role !== 'ADMIN') {
                return response()->json(['error' => 'Forbidden'], 403);
            }

            return Booking::where('user_id', $userId)->with('property')->get();
        }

        // If filtering by property_id, allow property owner or admin (view-only)
        if ($request->has('property_id')) {
            $propertyId = $request->query('property_id');
            $property = Property::findOrFail($propertyId);
            if (auth()->id() != $property->owner_id && auth()->user()->role !== 'ADMIN') {
                return response()->json(['error' => 'Forbidden'], 403);
            }

            return Booking::where('property_id', $propertyId)->with('property')->get();
        }

        // Default: show all bookings for the authenticated user
        return Booking::where('user_id', auth()->id())->with('property')->get();
    }

    /**
     * Store a new booking.
     */
    public function store(Request $request)
    {
        $request->validate([
            'property_id' => 'required|exists:properties,id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'total_price' => 'required|numeric|min:0',
        ]);

        $propertyId = $request->property_id;
        $checkIn = $request->check_in;
        $checkOut = $request->check_out;

        // Prevent double-booking
        $overlap = Booking::where('property_id', $propertyId)
            ->where('status', 'confirmed')
            ->where(function ($query) use ($checkIn, $checkOut) {
                $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<', $checkIn)
                            ->where('check_out', '>', $checkOut);
                    });
            })
            ->exists();

        if ($overlap) {
            return response()->json(['error' => 'Property already booked for these dates'], 422);
        }

        // Create booking
        $booking = Booking::create([
            'user_id' => auth()->id(),
            'property_id' => $propertyId,
            'check_in' => $checkIn,
            'check_out' => $checkOut,
            'status' => 'pending',
            'total_price' => $request->total_price,
            'currency' => $request->currency ?? 'USD',
            'payment_status' => 'unpaid',
        ]);

        return response()->json($booking, 201);
    }

    /**
     * List bookings for a specific user (authorized).
     */
    public function userBookings($userId)
    {
        if (auth()->id() != $userId && auth()->user()->role !== 'ADMIN') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return Booking::where('user_id', $userId)->with('property')->get();
    }

    /**
     * List bookings for a specific property (authorized: owner or admin).
     */
    public function propertyBookings($propertyId)
    {
        $property = Property::findOrFail($propertyId);
        if (auth()->id() != $property->owner_id && auth()->user()->role !== 'ADMIN') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return Booking::where('property_id', $propertyId)->with('property')->get();
    }

    /**
     * List all bookings for properties owned by a specific user (owner).
     */
    public function ownerBookings($ownerId)
    {
        if (auth()->id() != $ownerId && auth()->user()->role !== 'ADMIN') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $propertyIds = Property::where('owner_id', $ownerId)->pluck('id');

        $bookings = Booking::whereIn('property_id', $propertyIds)
            ->with('property')
            ->get();

        return response()->json(['bookings' => $bookings]);
    }

    /**
     * Show a single booking.
     */
    public function show(Booking $booking)
    {
        $this->authorize('view', $booking); // optional policy
        return $booking->load('property');
    }

    /**
     * Update a booking (e.g., confirm, cancel).
     */
    public function update(Request $request, Booking $booking)
    {
        $this->authorize('update', $booking);
        $request->validate([
            'property_id' => 'sometimes|exists:properties,id',
            'check_in' => 'sometimes|date|after_or_equal:today',
            'check_out' => 'sometimes|date|after:check_in',
            'status' => 'sometimes|in:pending,confirmed,cancelled,completed',
            'total_price' => 'sometimes|numeric|min:0'
        ]);

        $propertyId = $request->filled('property_id') ? $request->property_id : $booking->property_id;
        $checkIn = $request->filled('check_in') ? $request->check_in : $booking->check_in;
        $checkOut = $request->filled('check_out') ? $request->check_out : $booking->check_out;

        $overlap = Booking::where('property_id', $propertyId)
            ->where('id', '!=', $booking->id)
            ->where('status', 'confirmed')
            ->where(function ($query) use ($checkIn, $checkOut) {
                $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<', $checkIn)
                            ->where('check_out', '>', $checkOut);
                    });
            })
            ->exists();

        if ($overlap) {
            return response()->json(['error' => 'Property already booked for these dates'], 422);
        }

        $booking->update($request->only('property_id', 'check_in', 'check_out', 'status', 'total_price'));

        return response()->json($booking->fresh()->load('property'));
    }

    /**
     * Delete a booking.
     */
    public function destroy(Booking $booking)
    {
        $this->authorize('delete', $booking);
        $booking->delete();

        return response()->json(['message' => 'Booking deleted successfully']);
    }

    public function availability($propertyId)
    {
        // Validate property exists
        $property = Property::findOrFail($propertyId);

        // Get pending + confirmed bookings for this property
        $bookings = Booking::where('property_id', $propertyId)
            ->whereIn('status', ['pending', 'confirmed'])
            ->select('check_in', 'check_out', 'status')
            ->get();

        // Return booked date ranges with status
        return response()->json([
            'booked_ranges' => $bookings
        ]);
    }
}

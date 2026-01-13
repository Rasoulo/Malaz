<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class BookingController extends Controller
{
    /**
     * Helper method to update booking status based on dates
     */
    private function updateBookingStatus(Booking $booking)
    {
        $today = Carbon::today();
        $checkIn = Carbon::parse($booking->check_in);
        $checkOut = Carbon::parse($booking->check_out);

        // Check if status needs to be updated
        if ($booking->status === 'confirmed' && $today->between($checkIn, $checkOut)) {
            $booking->status = 'ongoing';
            $booking->save();
        } elseif ($booking->status === 'ongoing' && $today->greaterThan($checkOut)) {
            $booking->status = 'completed';
            $booking->save();
        } else if ($booking->status === 'confirmed' && $today->greaterThan($checkOut)) {
            $booking->status = 'completed';
            $booking->save();
        } else if ($booking->status === 'pending' && $today->greaterThan($checkIn)) {
            $booking->status = 'rejected';
            $booking->save();
        } else if ($booking->status === 'conflicted' && $today->greaterThan($checkIn)) {
            $booking->status = 'rejected';
            $booking->save();
        }

        return $booking;
    }

    /**
     * Display a list of bookings with auto-updated statuses
     */
    public function index(Request $request)
    {
        $query = Booking::query();

        // If filtering by user_id
        if ($request->has('user_id')) {
            $userId = $request->query('user_id');
            if (auth()->id() != $userId && auth()->user()->role !== 'ADMIN') {
                return response()->json(['error' => 'Forbidden'], 403);
            }
            $query->where('user_id', $userId);
        }
        // If filtering by property_id
        elseif ($request->has('property_id')) {
            $propertyId = $request->query('property_id');
            $property = Property::findOrFail($propertyId);
            if (auth()->id() != $property->owner_id && auth()->user()->role !== 'ADMIN') {
                return response()->json(['error' => 'Forbidden'], 403);
            }
            $query->where('property_id', $propertyId);
        }
        // Default: show all bookings for the authenticated user
        else {
            $query->where('user_id', auth()->id());
        }

        // Get bookings
        $bookings = $query->with('property')->get();

        // Update statuses for each booking
        $updatedBookings = $bookings->map(function ($booking) {
            return $this->updateBookingStatus($booking);
        });

        return $updatedBookings->sortByDesc('id');
    }

    /**
     * Show a single booking with auto-updated status
     */
    public function show(Booking $booking)
    {
        $this->authorize('view', $booking);

        // Update status before returning
        $updatedBooking = $this->updateBookingStatus($booking);

        return $updatedBooking->load('property');
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

        $bookings = Booking::where('user_id', $userId)
            ->with('property')
            ->get()
            ->map(function ($booking) {
                return $this->updateBookingStatus($booking);
            });

        return $bookings->sortByDesc('id');
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

        $bookings = Booking::where('property_id', $propertyId)
            ->with('property')
            ->get()
            ->map(function ($booking) {
                return $this->updateBookingStatus($booking);
            });

        return $bookings->sortByDesc('id');
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
            ->with(['property', 'user:id,first_name,last_name'])
            ->get()
            ->map(function ($booking) {
                return $this->updateBookingStatus($booking);
            });

        return response()->json(['bookings' => $bookings])->sortedByDesc('id');
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
            'status' => 'sometimes|in:pending,confirmed,cancelled,rejected,completed,conflicted,ongoing',
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

        // Enforce status-change permissions
        if ($request->filled('status')) {
            $newStatus = $request->input('status');
            $user = auth()->user();

            // Booking owner may only set status to 'cancelled'
            if ($user->id === $booking->user_id && $newStatus !== 'cancelled') {
                return response()->json(['error' => 'You may only cancel your own booking'], 403);
            }

            // Property owner may set to 'confirmed' or 'rejected'
            if ($user->id === $booking->property->owner_id) {
                if (!in_array($newStatus, ['confirmed', 'rejected'])) {
                    return response()->json(['error' => 'Property owners may only confirm or reject bookings'], 403);
                }
            }

            // Other users (including admins per your current policy) are not allowed to change status here
            if ($user->id !== $booking->user_id && $user->id !== $booking->property->owner_id) {
                return response()->json(['error' => 'Forbidden to change booking status'], 403);
            }
        }

        $booking->update($request->only('property_id', 'check_in', 'check_out', 'status', 'total_price'));

        // If this booking was just confirmed, mark overlapping PENDING bookings as conflicted
        if ($request->filled('status') && $request->input('status') === 'confirmed') {
            $propId = $booking->property_id;
            $cIn = $booking->check_in;
            $cOut = $booking->check_out;

            Booking::where('property_id', $propId)
                ->where('status', 'pending')
                ->where(function ($q) use ($cIn, $cOut) {
                    $q->whereBetween('check_in', [$cIn, $cOut])
                        ->orWhereBetween('check_out', [$cIn, $cOut])
                        ->orWhere(function ($qq) use ($cIn, $cOut) {
                            $qq->where('check_in', '<', $cIn)
                                ->where('check_out', '>', $cOut);
                        });
                })
                ->update(['status' => 'conflicted']);

            $booking->refresh();
        }

        // Check and update status based on dates after the update
        $this->updateBookingStatus($booking);

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

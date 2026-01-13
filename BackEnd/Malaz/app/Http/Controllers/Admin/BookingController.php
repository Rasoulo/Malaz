<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $bookings = Booking::with(['user', 'property']) // Eager-load for performance
            ->when($request->status, function ($query, $status) {
                $query->where('status', $status);
            })
            ->latest() // Show most recent bookings first
            ->paginate(12);

        return view('admin.bookings.index', compact('bookings'));
    }

    /**
     * Fetch and return a single booking's data for the modal.
     */
    public function show(Booking $booking)
    {
        // Load all relationships for the detailed view and return as JSON
        $booking = $booking->load(['user', 'property']);
        $booking->property->makeVisible(['main_image', 'mime_type']);
        return $booking;
    }
}

<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Property;
use App\Models\Booking;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        // Get statistics without payment data
        $stats = [
            'total_users' => User::where('role', '!=', 'PENDING')->count(),
            'new_users_today' => User::whereDate('created_at', today())
                ->where('role', '!=', 'PENDING')
                ->count(),
            'total_properties' => Property::count(),
            'pending_properties' => Property::where('status', 'pending')->count(),
            'active_bookings' => Booking::whereIn('status', ['confirmed', 'ongoing'])->count(),
            'total_bookings' => Booking::count(),
            // We'll add a placeholder for revenue based on bookings if available
            'estimated_revenue' => $this->getEstimatedRevenue(),
        ];

        // Get recent users
        $recentUsers = User::latest()->take(5)->get();

        // Get recent bookings
        $recentBookings = Booking::with(['user', 'property'])
            ->latest()
            ->take(5)
            ->get();

        // Get property status breakdown
        $propertyStatuses = [
            'approved' => Property::where('status', 'approved')->count(),
            'pending' => Property::where('status', 'pending')->count(),
            'rejected' => Property::where('status', 'rejected')->count(),
            'suspended' => Property::where('status', 'suspended')->count(),
        ];

        return view('admin.dashboard.index', compact(
            'stats',
            'recentUsers',
            'recentBookings',
            'propertyStatuses'
        ));
    }

    /**
     * Get estimated revenue from completed bookings
     */
    private function getEstimatedRevenue()
    {
        // Check if bookings have a total_amount field
        if (\Schema::hasColumn('bookings', 'total_price')) {
            return Booking::where('status', 'completed')->sum('total_price');
        }

        // Alternative: Calculate from property price if booking has dates
        if (\Schema::hasColumn('bookings', 'check_in') && \Schema::hasColumn('bookings', 'check_out')) {
            $completedBookings = Booking::where('status', 'completed')->get();
            $total = 0;

            foreach ($completedBookings as $booking) {
                // Calculate days
                $days = $booking->check_out->diffInDays($booking->check_in);
                // If property has price per day
                if ($booking->property && $booking->property->price) {
                    $total += $days * $booking->property->price;
                }
            }

            return $total;
        }

        return 0;
    }
}

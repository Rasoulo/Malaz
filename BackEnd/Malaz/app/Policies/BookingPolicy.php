<?php

namespace App\Policies;

use App\Models\Booking;
use App\Models\User;

class BookingPolicy
{
    /**
     * Determine if the user can view the booking.
     */
    public function view(User $user, Booking $booking)
    {
        // Users can view their own bookings, Admins can view all
        return $user->id === $booking->user_id || $user->role === 'ADMIN';
    }

    /**
     * Determine if the user can create a booking.
     */
    public function create(User $user)
    {
        // Any authenticated user can create a booking
        return $user->role === 'USER' || $user->role === 'ADMIN';
    }

    /**
     * Determine if the user can update a booking.
     */
    public function update(User $user, Booking $booking)
    {
        // Users can update their own bookings (e.g., cancel),
        // Admins can update any booking

        return $user->id === $booking->property->owner_id || $user->role === 'ADMIN';
    }

    /**
     * Determine if the user can delete a booking.
     */
    public function delete(User $user, Booking $booking)
    {
        // Users can cancel their own bookings,
        // Admins can cancel any booking
        return $user->id === $booking->user_id || $user->role === 'ADMIN';
    }
}

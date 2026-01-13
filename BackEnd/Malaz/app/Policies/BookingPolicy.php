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
        // Only normal users may create bookings; admins are view-only
        return $user->role === 'USER';
    }

    /**
     * Determine if the user can update a booking.
     */
    public function update(User $user, Booking $booking)
    {
        // Allow property owner or the booking owner to update (admins not allowed)
        return $user->id === $booking->property->owner_id || $user->id === $booking->user_id;
    }

    /**
     * Determine if the user can delete a booking.
     */
    public function delete(User $user, Booking $booking)
    {
        // Only the booking owner can delete/cancel their booking (admins are view-only)
        return $user->id === $booking->user_id || $user->role === 'ADMIN';
    }
}

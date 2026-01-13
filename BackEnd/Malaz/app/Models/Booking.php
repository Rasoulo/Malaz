<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Booking extends Model
{
    protected $fillable = [
        'user_id',
        'property_id',
        'check_in',
        'check_out',
        'status',
        'total_price',
    ];

    protected $casts = [
        'check_in' => 'date',
        'check_out' => 'date',
    ];

    // A booking belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // A booking belongs to a property
    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    /**
     * Auto-update the booking status based on dates
     * Call this method whenever you need to ensure status is current
     */
    public function autoUpdateStatus()
    {
        $today = Carbon::today();
        $checkIn = Carbon::parse($this->check_in);
        $checkOut = Carbon::parse($this->check_out);

        // Update confirmed → ongoing
        if ($this->status === 'confirmed' && $today->between($checkIn, $checkOut)) {
            $this->status = 'ongoing';
            $this->save();
        }
        // Update ongoing → completed
        elseif ($this->status === 'ongoing' && $today->greaterThan($checkOut)) {
            $this->status = 'completed';
            $this->save();
        }

        return $this;
    }
}

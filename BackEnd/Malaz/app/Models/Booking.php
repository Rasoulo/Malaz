<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $fillable = [
        'user_id',
        'property_id',
        'check_in',
        'check_out',
        'status',
        'total_price',
        'payment_status',
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
}

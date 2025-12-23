<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Property extends Model
{
    /** @use HasFactory<\Database\Factories\PropertyFactory> */
    use HasFactory;

    public function images()
    {
        return $this->hasMany(Image::class, 'property_id', 'id');
    }

    public function user()
    {
        return $this->belongsTo(User::class,'owner_id','id');
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function conversation()
    {
        return $this->hasMany(Conversation::class, 'property_id', 'id');
    }

    public function favoritedBy()
    {
        return $this->belongsToMany(User::class, 'favorites')
            ->withTimestamps();
    }

    public function getMainImageUrlAttribute()
    {
        return $this->main_image
            ? route('property.main_pic', $this->id)
            : null;
    }

    protected $appends = ['main_image_url'];
    protected $hidden = ['main_image'];



    protected $guarded = [];
}

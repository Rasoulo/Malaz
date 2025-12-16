<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Image extends Model
{
    /** @use HasFactory<\Database\Factories\ImageFactory> */
    use HasFactory;

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function getImageUrlAttribute()
    {
        return $this->image
            ? route('images.show', $this->id)
            : null;
    }

    protected $appends = ['image_url'];
    protected $guarded = [];

    protected $hidden = ['image'];

}

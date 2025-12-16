<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */

    public function property()
    {
        return $this->hasMany(Property::class, 'owner_id', 'id');
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function edit_request()
    {
        return $this->hasMany(EditRequest::class, 'user_id', 'id');
    }

    public function conversations()
    {
        return $this->belongsToMany(Conversation::class);
    }

    public function messages()
    {
        return $this->hasMany(Message::class);
    }

    public function favorites()
    {
        return $this->belongsToMany(Property::class, 'favorites')
            ->withTimestamps();
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function getProfileImageUrlAttribute()
    {
        return $this->profile_image
            ? route('users.profile_image', $this->id)
            : null;
    }

    public function getIdentityCardImageUrlAttribute()
    {
        return $this->identity_card_image
            ? route('users.identity_card_image', $this->id)
            : null;
    }

    protected $appends = ['profile_image_url', 'identity_card_image_url'];

    protected $guarded = ['role'];
    
    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'profile_image',
        'identity_card_image',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'phone_verified_at' => 'datetime',
            'password' => 'hashed',
            'date_of_birth' => 'date',
        ];
    }

    public function isAdmin()
    {
        return $this->role === 'ADMIN';
    }
}

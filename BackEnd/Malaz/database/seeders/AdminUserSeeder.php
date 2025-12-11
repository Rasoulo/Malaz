<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        User::create([
            'first_name' => 'Admin',
            'last_name' => 'User',
            'email' => 'admin@example.com',
            'phone' => '+1234567890', // Use a unique phone
            'password' => bcrypt('admin123'),
            'role' => 'ADMIN',
            'date_of_birth' => '1990-01-01',
            'profile_image' => '',
            'identity_card_image' => '',
            'phone_verified_at' => now(),
            'email_verified_at' => now(),
        ]);
    }
}

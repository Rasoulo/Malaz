<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['phone' => '0999999999'],
            [
                'first_name' => 'Super',
                'last_name' => 'Admin',
                'role' => 'ADMIN',
                'date_of_birth' => '1990-01-01',
                'profile_image' => 'default_admin_profile.png',
                'identity_card_image' => 'default_admin_id.png',
                'phone_verified_at' => now(),
                'password' => bcrypt('Admin@123'),
                'remember_token' => Str::random(10),
            ]
        );

        //User::factory()->count(20)->create();
        // User::factory()->count(5)->unverified()->create();
    }
}
